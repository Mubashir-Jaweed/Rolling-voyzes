import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class AppStrings {
  AppStrings._();

  static AppLocalizations get T => AppLocalizations.of(Get.context!)!;

  /// Use other temporary string here.
  /// Make sure your string is defined same as this.
  static String language = 'Languages';
  static String selectLanguage = 'Select a language to get started';
  static String continueText = 'Continue';
  static String english = 'English';
  static String spanish = 'Spanish';
}
