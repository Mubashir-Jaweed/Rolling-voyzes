import 'dart:io';

import 'package:get/get.dart';

import '../../constants/app_strings.dart';

class AppValidations {
  AppValidations._();

  static String? verificationCodeValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleaseEnterOtp;
    return null;
  }

  static String? phoneNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.T.pleaseEnterPhoneNumber;
    }
    return null;
  }

  static String? nameValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleaseEnterName;
    return null;
  }

  static String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.T.pleaseEnterPassword;
    } else if (!isValidPassword(value)) {
      return AppStrings.T.pleaseEnterValidPassowrd;
    }
    return null;
  }

  static String? confirmPasswordValidation(
      String? value, String otherPasswordValue) {
    if (value == null || value.isEmpty) {
      return AppStrings.T.pleaseEnterPassword;
    }
    if (otherPasswordValue.isEmpty) return null;
    if (otherPasswordValue != value) return AppStrings.T.passwordsDoNotMatch;
    return null;
  }

  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.T.pleaseEnterAEmailAddress;
    }
    if (!value.isEmail) return AppStrings.T.pleaseEnterAValidEmailAddress;
    return null;
  }

  static String? imageValidation(File? param0) {
    if (param0 == null) return 'adsasda';
    return null;
  }

  static bool isValidPassword(String password) {
    final regex =
        RegExp(r'^(?=.*[0-9])(?=.*[!@#\$&*~])[A-Za-z0-9!@#\$&*~]{8,}$');
    return regex.hasMatch(password);
  }
}
