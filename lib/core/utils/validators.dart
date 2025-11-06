import '../constants/app_strings.dart';

class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordShort;
    }
    return null;
  }

  static String? notEmpty(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    return null;
  }
}