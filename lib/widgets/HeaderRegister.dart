import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';

class clsHeaderMessage extends StatelessWidget {
  final String mainText;
  final String supText;

  const clsHeaderMessage({
    super.key,
    required this.mainText,
    required this.supText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainText.trim(),
          style: Appstyle.Font25pxwithSemiBoldweight.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          supText,
          style: Appstyle.font14withSemiBold.copyWith(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
