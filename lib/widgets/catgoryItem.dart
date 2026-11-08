import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/models/category_model.dart';

class clsCategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const clsCategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 68,
            height: 68,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Appstyle.secondary
                  : const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Appstyle.MainColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: category.pictureUrl != null && category.pictureUrl!.isNotEmpty
                  ? Image.network(
                      category.pictureUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.fastfood_outlined,
                        color: isSelected ? Appstyle.MainColor : Colors.grey.shade400,
                        size: 28,
                      ),
                    )
                  : Icon(
                      Icons.fastfood_outlined,
                      color: isSelected ? Appstyle.MainColor : Colors.grey.shade400,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 72,
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Appstyle.MainColor : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
