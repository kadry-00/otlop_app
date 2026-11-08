import 'package:flutter/material.dart';

abstract class Appstyle {
  // Brand colors
  static const Color MainColor = Color.fromRGBO(255, 92, 57, 1);
  static const Color primary = MainColor;
  static const Color secondary = Color(0xFFFFECE8);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color supColor = Colors.grey;

  // Typography
  static const TextStyle Font25pxwithSemiBoldweight = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle font14withSemiBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textSecondary,
  );

  static const TextStyle font17withSemiBold = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle MainTitle24WithBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle font18withbold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle font18withExtrabold = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 24,
    color: textPrimary,
  );

  static const TextStyle font13with500weight = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static const TextStyle font11withMediumweight = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );
}
