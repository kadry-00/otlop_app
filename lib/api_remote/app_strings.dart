class AppStrings {
  static const String fieldRequired = "This field is required.";

  static const String emailRequired = "Email is required.";
  static const String emailInvalidFormat = "Enter a valid email address.";

  static const String nameRequired = "Name is required.";
  static const String nameError =
      "Enter a valid name (letters and spaces only, at least 2 characters).";

  static const String phoneRequired = "Phone number is required.";
  static const String phoneInvalidFormat =
      "Phone number can only contain numbers.";
  static const String phoneInvalidStart =
      "Phone number must start with 01 followed by 0, 1, 2 or 5.";
  static const String phoneInvalidLength =
      "Phone number must be exactly 11 digits long.";

  static const String passwordLength =
      "Password must be between 6 and 10 characters.";
  static const String passwordAtLeast1Uppercase =
      "Password must contain at least one uppercase letter.";
  static const String passwordAtLeast1Lowercase =
      "Password must contain at least one lowercase letter.";
  static const String passwordAtLeast1Number =
      "Password must contain at least one number.";
  static const String passwordAtLeast1SpecialChar =
      "Password must contain at least one special character.";
}
