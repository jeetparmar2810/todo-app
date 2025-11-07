class AppDimens {
  static const double padding = 16.0;
  static const double radius = 12.0;
  static const double iconSize = 24.0;
  static const double buttonHeight = 48.0;
  static const double fontSmall = 12;
  static const double fontRegular = 14;
  static const double fontMedium = 16;
  static const double fontLarge = 18;
  static const double fontXLarge = 22;
  static const double fontXXLarge = 28;
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space6 = 6;
  static const double space8 = 8;
  static const double space10 = 10;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double iconSmall = 18;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 40;
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 18;
  static const double radiusXLarge = 25;
  static const double buttonCorner = 12;
  static const double inputHeight = 55;
  static const double cardElevation = 4;
  static const double appBarHeight = 56;

  static double responsiveFont(double size, double deviceWidth) {
    if (deviceWidth < 360) {
      return size * 0.9;
    } else if (deviceWidth > 500) {
      return size * 1.1;
    }
    return size;
  }
}