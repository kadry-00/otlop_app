import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/models/brand_model.dart';

class clsBrandChip extends StatelessWidget {
  final BrandModel brand;
  final bool isSelected;
  final VoidCallback onTap;

  const clsBrandChip({
    super.key,
    required this.brand,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Appstyle.MainColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? Appstyle.MainColor : Colors.transparent,
          ),
        ),
        child: Text(
          brand.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
