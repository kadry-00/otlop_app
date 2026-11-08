import 'package:otlop_1/api_remote/app_strings.dart';

class Validator {
  static String? validateEmail(String? email) {
    final String value = email?.trim() ?? "";

    if (value.isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return AppStrings.emailInvalidFormat;
    }
    return null;
  }

  static String? validateName(String? name) {
    final String value = name?.trim() ?? "";

    if (value.isEmpty) {
      return AppStrings.nameRequired;
    }
    if (!RegExp(r'^[\p{L} ]{2,}$', unicode: true).hasMatch(value)) {
      return AppStrings.nameError;
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    final String value = phoneNumber?.trim() ?? "";

    if (value.isEmpty) {
      return AppStrings.phoneRequired;
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return AppStrings.phoneInvalidFormat;
    }
    if (!RegExp(r'^01[0125]').hasMatch(value)) {
      return AppStrings.phoneInvalidStart;
    }
    if (value.length != 11) {
      return AppStrings.phoneInvalidLength;
    }
    return null;
  }

  static String? validatePassword(String? password) {
    final String value = password ?? "";

    if (value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 6 || value.length > 10) {
      return AppStrings.passwordLength;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppStrings.passwordAtLeast1Uppercase;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return AppStrings.passwordAtLeast1Lowercase;
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return AppStrings.passwordAtLeast1Number;
    }
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
      return AppStrings.passwordAtLeast1SpecialChar;
    }
    return null;
  }

  static String? validateLoginPassword(String? password) {
    if (password == null || password.isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }
}
