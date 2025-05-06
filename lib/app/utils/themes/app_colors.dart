part of 'app_theme.dart';

class KAppColors {
  KAppColors._();

  static const Color transparent = Colors.transparent;
  static const Color red = Color(0xffFF0000);
  static const Color black = Color(0xff01070A);
  static const Color green = Color(0xff2E8B27);
  static const Color blue = Color(0xff286DD8);
  static const Color audio1TopLeftColor = Color(0xffB5CAFF);
  static const Color audio1BottomRightColor = Color(0xff4796FF);
  static const Color audio2TopLeftColor = Color(0xff8CD1FF);
  static const Color audio2BottomRightColor = Color(0xff438FFF);
  static const Color topLeftColor = Color(0xffF6FBFF);
  static const Color bottomRightColor = Color(0xffBDDFFF);
  static const Color white = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color primaryColor = Color(0xff286DD8);
  static const Color backGroundColor = Color(0xff0B0B0B);
  static const Color cardBackGroundColor = Color(0xff141415);
  static const Color borderColor = Color(0xffD0EAFF);
  static const Color textColor = Color(0xff6E6D6D);
  static const Color boxColor = Color(0xff1C1C1C);
  static const Color boxUColor = Color(0xff212121);
  static const Color dividerColor = Color(0xff505050);
  static const Color containerColor = Color(0xff131315);
  static const Color shadowColor = Color(0xffDEEEFD);
  static const Color normalWhiteGradientColor = Color(0xffF7FBFF);
  static const Color normalBlueGradientColor = Color(0xffC3E2FF);
  static const Color veryDarkBlue = Color(0xff172E63);
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.transparent,
    required this.red,
    required this.black,
    required this.green,
    required this.white,
    required this.blackColor,
    required this.primaryColor,
    required this.backGroundColor,
    required this.textColor,
    required this.boxColor,
    required this.blue,
    required this.cardBackGroundColor,
    required this.boxUColor,
    required this.containerColor,
    required this.dividerColor,
    required this.borderColor,
    required this.topLeftColor,
    required this.bottomRightColor,
    required this.audio1TopLeftColor,
    required this.audio1BottomRightColor,
    required this.audio2TopLeftColor,
    required this.audio2BottomRightColor,
    required this.shadowColor,
    required this.normalWhiteGradientColor,
    required this.normalBlueGradientColor,
    required this.veryDarkBlue,
  });

  final Color primary;
  final Color transparent;
  final Color red;
  final Color black;
  final Color green;
  final Color veryDarkBlue;
  final Color white;
  final Color blackColor;
  final Color primaryColor;
  final Color backGroundColor;
  final Color cardBackGroundColor;
  final Color textColor;
  final Color boxColor;
  final Color boxUColor;
  final Color dividerColor;
  final Color borderColor;
  final Color blue;
  final Color containerColor;
  final Color topLeftColor;
  final Color bottomRightColor;
  final Color audio1TopLeftColor;
  final Color audio1BottomRightColor;
  final Color audio2TopLeftColor;
  final Color audio2BottomRightColor;
  final Color shadowColor;
  final Color normalWhiteGradientColor;
  final Color normalBlueGradientColor;

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>()!;
  }

  @override
  ThemeExtension<AppColors> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppColors> lerp(
      covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      veryDarkBlue: Color.lerp(veryDarkBlue, other.veryDarkBlue, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      red: Color.lerp(red, other.red, t)!,
      black: Color.lerp(black, other.black, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      green: Color.lerp(green, other.green, t)!,
      white: Color.lerp(white, other.white, t)!,
      containerColor: Color.lerp(containerColor, other.containerColor, t)!,
      blackColor: Color.lerp(blackColor, other.blackColor, t)!,
      cardBackGroundColor:
          Color.lerp(cardBackGroundColor, other.backGroundColor, t)!,
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      backGroundColor: Color.lerp(backGroundColor, other.backGroundColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      boxColor: Color.lerp(boxColor, other.boxColor, t)!,
      boxUColor: Color.lerp(boxUColor, other.boxUColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      bottomRightColor:
          Color.lerp(bottomRightColor, other.bottomRightColor, t)!,
      topLeftColor: Color.lerp(topLeftColor, other.topLeftColor, t)!,
      audio1TopLeftColor:
          Color.lerp(audio1TopLeftColor, other.audio1TopLeftColor, t)!,
      audio1BottomRightColor:
          Color.lerp(audio1BottomRightColor, other.audio1BottomRightColor, t)!,
      audio2TopLeftColor:
          Color.lerp(audio2TopLeftColor, other.audio2TopLeftColor, t)!,
      audio2BottomRightColor:
          Color.lerp(audio2BottomRightColor, other.audio2BottomRightColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      normalWhiteGradientColor: Color.lerp(
          normalWhiteGradientColor, other.normalWhiteGradientColor, t)!,
      normalBlueGradientColor: Color.lerp(
          normalBlueGradientColor, other.normalBlueGradientColor, t)!,
    );
  }
}
