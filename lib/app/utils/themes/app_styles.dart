part of 'app_theme.dart';

const _kSfProFontFamily = 'sfpro';

class SfPro extends TextStyle {
  SfPro({
    super.fontSize,
    super.color,
    super.decoration,
    super.fontWeight,
    super.overflow,
    super.decorationColor,
  }) : super(
          fontFamily: _kSfProFontFamily,
          height: Platform.isIOS ? 0.9 : null,
          letterSpacing: -0.5,
        );
}

class AppStyles extends ThemeExtension<AppStyles> {
  AppStyles({
    required this.s26w700White,
    required this.s18w400Text,
    required this.s18w400green,
    required this.s18w500Green,
    required this.s18w500White,
    required this.s16w400White,
    required this.s20w700White,
    required this.s22w700White,
    required this.s24w700White,
    required this.s18w400White,
    required this.s18w700White,
    required this.s26w700Black,
    required this.s18w400Black,
    required this.s18w500Black,
    required this.s16w400Black,
    required this.s18w700Black,
    required this.s20w700Black,
    required this.s22w700Black,
    required this.s24w700Black,
  });

  final TextStyle s26w700White;
  final TextStyle s18w400Text;
  final TextStyle s18w400green;
  final TextStyle s18w500Green;
  final TextStyle s18w500White;
  final TextStyle s16w400White;
  final TextStyle s18w400White;
  final TextStyle s18w700White;
  final TextStyle s20w700White;
  final TextStyle s22w700White;
  final TextStyle s24w700White;
  final TextStyle s26w700Black;
  final TextStyle s18w400Black;
  final TextStyle s18w500Black;
  final TextStyle s16w400Black;
  final TextStyle s18w700Black;
  final TextStyle s20w700Black;
  final TextStyle s22w700Black;
  final TextStyle s24w700Black;

  static AppStyles of(BuildContext context) {
    return Theme.of(context).extension<AppStyles>()!;
  }

  @override
  ThemeExtension<AppStyles> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppStyles> lerp(
      covariant ThemeExtension<AppStyles>? other, double t) {
    if (other is! AppStyles) {
      return this;
    }

    return other;
  }
}
