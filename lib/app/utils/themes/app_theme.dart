import 'dart:io';

import 'package:flutter/material.dart';

part 'app_colors.dart';

part 'app_styles.dart';

// TextTheme textTheme = Get.theme.textTheme;
// ColorScheme colorScheme = Get.theme.colorScheme;

class AppTheme {
  AppTheme._();

  static AppStyles get darkAppStyles => AppStyles(
        s26w700Black: SfPro(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: KAppColors.black,
        ),
        s18w400Black: SfPro(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: KAppColors.black,
        ),
        s18w500Black: SfPro(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: KAppColors.black,
        ),
        s16w400Black: SfPro(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: KAppColors.black,
        ),
        s18w700Black: SfPro(
            fontSize: 18, fontWeight: FontWeight.w700, color: KAppColors.black),
        s20w700Black: SfPro(
            fontSize: 20, fontWeight: FontWeight.w700, color: KAppColors.black),
        s22w700Black: SfPro(
            fontSize: 22, fontWeight: FontWeight.w700, color: KAppColors.black),
        s24w700Black: SfPro(
            fontSize: 24, fontWeight: FontWeight.w700, color: KAppColors.black),
        s20w700White: SfPro(
            fontSize: 20, fontWeight: FontWeight.w700, color: KAppColors.white),
        s22w700White: SfPro(
            fontSize: 22, fontWeight: FontWeight.w700, color: KAppColors.white),
        s24w700White: SfPro(
            fontSize: 24, fontWeight: FontWeight.w700, color: KAppColors.white),
        s26w700White: SfPro(
            fontSize: 26, fontWeight: FontWeight.w700, color: KAppColors.white),
        s18w400Text: SfPro(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: KAppColors.textColor),
        s18w400green: SfPro(
            fontSize: 18, fontWeight: FontWeight.w400, color: KAppColors.green),
        s18w500Green: SfPro(
            fontSize: 18, fontWeight: FontWeight.w500, color: KAppColors.green),
        s18w500White: SfPro(
            fontSize: 18, fontWeight: FontWeight.w500, color: KAppColors.white),
        s16w400White: SfPro(
            fontSize: 16, fontWeight: FontWeight.w400, color: KAppColors.white),
        s18w400White: SfPro(
            fontSize: 18, fontWeight: FontWeight.w400, color: KAppColors.white),
        s18w700White: SfPro(
            fontSize: 18, fontWeight: FontWeight.w700, color: KAppColors.white),
      );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    extensions: [
      darkAppStyles,
      AppColors(
        shadowColor: KAppColors.shadowColor,
        audio1TopLeftColor: KAppColors.audio1TopLeftColor,
        audio1BottomRightColor: KAppColors.audio1BottomRightColor,
        audio2TopLeftColor: KAppColors.audio2TopLeftColor,
        audio2BottomRightColor: KAppColors.audio2BottomRightColor,
        bottomRightColor: KAppColors.bottomRightColor,
        topLeftColor: KAppColors.topLeftColor,
        primary: KAppColors.primaryColor,
        transparent: KAppColors.transparent,
        red: KAppColors.red,
        black: KAppColors.black,
        green: KAppColors.green,
        white: KAppColors.white,
        blue: KAppColors.blue,
        blackColor: KAppColors.blackColor,
        primaryColor: KAppColors.primaryColor,
        backGroundColor: KAppColors.backGroundColor,
        textColor: KAppColors.textColor,
        boxColor: KAppColors.boxColor,
        boxUColor: KAppColors.boxUColor,
        containerColor: KAppColors.containerColor,
        dividerColor: KAppColors.dividerColor,
        borderColor: KAppColors.borderColor,
        cardBackGroundColor: KAppColors.cardBackGroundColor,
        normalWhiteGradientColor: KAppColors.normalWhiteGradientColor,
        normalBlueGradientColor: KAppColors.normalBlueGradientColor,
        veryDarkBlue: KAppColors.veryDarkBlue,
      ),
    ],
    colorScheme: ColorScheme(
      brightness: Brightness.dark,

      ///primary
      primary: KAppColors.primaryColor,
      onPrimary: KAppColors.black,
      // primaryContainer: KAppColors.bgOneColor,

      ///secondary
      secondary: KAppColors.boxUColor,
      onSecondary: KAppColors.white,
      // secondaryContainer: KAppColors.greyTextColor,

      ///Error
      error: KAppColors.red,
      onError: KAppColors.red,

      /// Field Bg Color & Text Selection
      surface: KAppColors.boxColor,

      ///Please Make Sure onSurface should be Primary Color
      onSurface: KAppColors.primaryColor,

      /// Borders
      outline: KAppColors.primaryColor,
    ),
    scaffoldBackgroundColor: KAppColors.black,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return KAppColors.white; // Active thumb color
        }
        return KAppColors.red; // Inactive thumb color
      }),
      // trackColor: WidgetStateProperty.resolveWith(
      //   (states) {
      //     if (states.contains(WidgetState.selected)) {
      //       return KAppColors.greyTextColor.withOpacity(0.5);
      //     }
      //     return KAppColors.red.withOpacity(0.5);
      //   },
      // ),
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(
            Icons.done,
            color: KAppColors.primaryColor,
          );
        }
        return null;
      }),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: KAppColors.primaryColor,
      titleTextStyle: SfPro(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: KAppColors.white,
      ),
      iconTheme: IconThemeData(color: KAppColors.black),
    ),
    fontFamily: 'SfPro',
    checkboxTheme: CheckboxThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      visualDensity: VisualDensity.compact,
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return KAppColors.primaryColor;
          }
          return KAppColors.black;
        },
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: KAppColors.boxUColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: KAppColors.red),
      ),
      contentPadding: const EdgeInsets.all(8),
      errorStyle: SfPro(
          color: KAppColors.red, fontSize: 12, fontWeight: FontWeight.w600),
      hintStyle: WidgetStateTextStyle.resolveWith(
        (states) {
          if (states.contains(WidgetState.error)) {
            return SfPro(
              color: KAppColors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            );
          }
          return SfPro(
            color: KAppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          );
        },
      ),
      labelStyle: WidgetStateTextStyle.resolveWith(
        (states) {
          if (states.contains(WidgetState.error)) {
            return SfPro(
              color: KAppColors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            );
          }
          return SfPro(
            color: KAppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          );
        },
      ),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
        (states) {
          if (states.contains(WidgetState.error)) {
            return SfPro(
              color: KAppColors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return SfPro(
            color: KAppColors.primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        },
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: KAppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),
    dividerColor: KAppColors.dividerColor,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: KAppColors.primaryColor,
    ),
  );
}
