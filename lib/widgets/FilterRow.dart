import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';

class clsFilterRow extends StatelessWidget {
  final String Title;
  final String supTitle;
  final VoidCallback? onSeeAllTap;

  const clsFilterRow({
    super.key,
    required this.Title,
    required this.supTitle,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Title,
            style: Appstyle.font18withbold.copyWith(fontSize: 18),
          ),
          GestureDetector(
            onTap: onSeeAllTap,
            child: Text(
              supTitle,
              style: TextStyle(
                color: Appstyle.MainColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
