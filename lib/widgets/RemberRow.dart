import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';

class clsRemmberMeRow extends StatefulWidget {
  const clsRemmberMeRow({super.key});

  @override
  State<clsRemmberMeRow> createState() => _clsRemmberMeRowState();
}

class _clsRemmberMeRowState extends State<clsRemmberMeRow> {
  bool isRememberMeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox.adaptive(
          value: isRememberMeChecked,
          onChanged: (bool? newValue) {
            setState(() {
              isRememberMeChecked = newValue ?? false;
            });
          },
        ),
        Text(
          "Remember Me",
          style: Appstyle.font14withSemiBold.copyWith(color: Colors.black),
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            "Forgot Password",
            style: Appstyle.font14withSemiBold.copyWith(
              color: Appstyle.MainColor,
            ),
          ),
        ),
      ],
    );
  }
}
