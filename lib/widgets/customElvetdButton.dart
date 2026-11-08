import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';

class clsCustomElvetdButton extends StatelessWidget {
  const clsCustomElvetdButton({
    super.key,
    required this.BText,
    required this.onPressed,
    this.isLoading = false,
  });

  final String BText;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Appstyle.MainColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                BText,
                style: Appstyle.font17withSemiBold.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
