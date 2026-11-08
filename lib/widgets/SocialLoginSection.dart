import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/widgets/OtherLogMethodButton.dart';

class clsSocialLoginSection extends StatelessWidget {
  final String supText;
  final String maiText;
  final VoidCallback onPressedLink;

  const clsSocialLoginSection({
    super.key,
    required this.maiText,
    required this.supText,
    required this.onPressedLink,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Or With",
                style: Appstyle.font14withSemiBold.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: clsOtherLogMethodButton(
                IconText: "Google",
                ImagePath: "",
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: clsOtherLogMethodButton(
                IconText: "Apple",
                ImagePath: "",
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              supText,
              style: Appstyle.font14withSemiBold.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            TextButton(
              onPressed: onPressedLink,
              child: Text(
                maiText,
                style: Appstyle.font14withSemiBold.copyWith(
                  color: Appstyle.MainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
