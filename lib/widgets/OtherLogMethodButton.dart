import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';

class clsOtherLogMethodButton extends StatelessWidget {
  final String IconText;
  final String ImagePath;
  final VoidCallback? onTap;

  const clsOtherLogMethodButton({
    super.key,
    required this.IconText,
    required this.ImagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFE5E5E5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Colors.white,
      ),
      onPressed: onTap ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconText.toLowerCase().contains("apple")
                ? Icons.apple
                : Icons.g_mobiledata,
            size: 24,
            color: Colors.black87,
          ),
          const SizedBox(width: 8),
          Text(
            IconText,
            style: Appstyle.font14withSemiBold.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
