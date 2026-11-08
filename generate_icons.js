const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

function crc32(buf) {
  let table = [];
  for (let i = 0; i < 256; i++) {
    let c = i;
    for (let k = 0; k < 8; k++) c = ((c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1));
    table[i] = c;
  }
  let crc = -1;
  for (let i = 0; i < buf.length; i++) crc = (crc >>> 8) ^ table[(crc ^ buf[i]) & 0xFF];
  return (crc ^ (-1)) >>> 0;
}

function chunk(type, data) {
  const t = Buffer.from(type, 'ascii');
  const len = Buffer.alloc(4);
  len.writeUInt32BE(data.length, 0);
  const crcBuf = Buffer.alloc(4);
  const toCrc = Buffer.concat([t, data]);
  crcBuf.writeUInt32BE(crc32(toCrc), 0);
  return Buffer.concat([len, t, data, crcBuf]);
}

function createPng(width, height, pixelFn) {
  const sig = Buffer.from([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(width, 0);
  ihdr.writeUInt32BE(height, 4);
  ihdr[8] = 8;
  ihdr[9] = 6;
  ihdr[10] = 0;
  ihdr[11] = 0;
  ihdr[12] = 0;

  const raw = Buffer.alloc(height * (1 + width * 4));
  let pos = 0;
  for (let y = 0; y < height; y++) {
    raw[pos++] = 0;
    for (let x = 0; x < width; x++) {
      const [r, g, b, a] = pixelFn(x, y, width, height);
      raw[pos++] = r;
      raw[pos++] = g;
      raw[pos++] = b;
      raw[pos++] = a;
    }
  }
  const idat = zlib.deflateSync(raw);
  return Buffer.concat([
    sig,
    chunk('IHDR', ihdr),
    chunk('IDAT', idat),
    chunk('IEND', Buffer.alloc(0))
  ]);
}

// Distance from point to rounded rectangle
function sdRoundBox(x, y, w, h, r) {
  const dx = Math.abs(x) - w + r;
  const dy = Math.abs(y) - h + r;
  const outside = Math.sqrt(Math.max(dx, 0)**2 + Math.max(dy, 0)**2);
  const inside = Math.min(Math.max(dx, dy), 0);
  return outside + inside - r;
}

function clamp(v, min, max) {
  return Math.min(Math.max(v, min), max);
}

function otlopIconPixel(x, y, size) {
  // Normalize coordinates: center is (0, 0), range is approximately [-1, 1]
  const nx = (x - size / 2) / (size / 2);
  const ny = (y - size / 2) / (size / 2);

  // Background squircle (Talabat rounded card): corner radius ~ 0.45
  const dSquircle = sdRoundBox(nx, ny, 0.95, 0.95, 0.38);
  const aa = 2.0 / size; // antialias range
  const bgAlpha = clamp(1.0 - dSquircle / aa, 0, 1);

  if (bgAlpha <= 0) {
    return [0, 0, 0, 0];
  }

  // Base background color: Talabat Orange #FF5C39 -> (255, 92, 57)
  let r = 255, g = 92, b = 57;

  // Let's draw an iconic white food cloche & delivery smile:
  // 1. Cloche dome: circle centered at (0, 0.05), radius 0.42, only ny <= 0.05
  // Dome base line at ny = 0.05
  const distDome = Math.sqrt(nx * nx + (ny - 0.05) * (ny - 0.05));
  let inDome = false;
  if (distDome <= 0.42 && ny <= 0.05) {
    inDome = true;
  }
  // Cloche top knob: circle at (0, -0.40), radius 0.08
  const distKnob = Math.sqrt(nx * nx + (ny + 0.38) * (ny + 0.38));
  let inKnob = distKnob <= 0.08;

  // Cloche tray base rim: rounded bar at ny = 0.08, width 0.95, height 0.08
  const dRim = sdRoundBox(nx, ny - 0.08, 0.46, 0.045, 0.04);
  let inRim = dRim <= 0;

  // Talabat warm smile under the cloche / food:
  // Arc centered at (0, 0.18), inner radius 0.28, outer radius 0.38, angles from 30 deg to 150 deg (ny > 0.18)
  const distSmile = Math.sqrt(nx * nx + (ny - 0.18) * (ny - 0.18));
  let inSmile = (distSmile >= 0.24 && distSmile <= 0.34 && ny >= 0.22 && Math.abs(nx) <= 0.32);

  // Cutout inside cloche to give a sleek "O" + fork/spoon stylized silhouette:
  // Inner cutout in dome:
  let inCutout = false;
  const distInner = Math.sqrt(nx * nx + (ny - 0.05) * (ny - 0.05));
  if (distInner <= 0.30 && ny <= -0.02) {
    inCutout = true;
  }

  // Fork / Steam / Heart in center of cloche cutout
  // Let's add 3 vertical steam bars / fork tines rising up elegantly:
  let inSteam = false;
  if (ny >= -0.26 && ny <= -0.04) {
    if (Math.abs(nx) <= 0.03 || Math.abs(nx - 0.10) <= 0.025 || Math.abs(nx + 0.10) <= 0.025) {
      inSteam = true;
    }
  }

  // Combine white foreground shapes
  let isWhite = (inKnob || (inDome && !inCutout) || inRim || inSmile || inSteam);

  if (isWhite) {
    return [255, 255, 255, Math.round(bgAlpha * 255)];
  }

  return [r, g, b, Math.round(bgAlpha * 255)];
}

const targets = [
  { p: 'E:/otlop_1/android/app/src/main/res/mipmap-mdpi/ic_launcher.png', s: 48 },
  { p: 'E:/otlop_1/android/app/src/main/res/mipmap-hdpi/ic_launcher.png', s: 72 },
  { p: 'E:/otlop_1/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png', s: 96 },
  { p: 'E:/otlop_1/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png', s: 144 },
  { p: 'E:/otlop_1/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png', s: 192 },
  { p: 'E:/otlop_1/web/favicon.png', s: 32 },
  { p: 'E:/otlop_1/web/icons/Icon-192.png', s: 192 },
  { p: 'E:/otlop_1/web/icons/Icon-512.png', s: 512 },
  { p: 'E:/otlop_1/web/icons/Icon-maskable-192.png', s: 192 },
  { p: 'E:/otlop_1/web/icons/Icon-maskable-512.png', s: 512 },
];

for (const t of targets) {
  const dir = path.dirname(t.p);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  const png = createPng(t.s, t.s, (x, y) => otlopIconPixel(x, y, t.s));
  fs.writeFileSync(t.p, png);
  console.log(`Generated: ${t.p} (${t.s}x${t.s})`);
}
console.log('App icons generated successfully!');
