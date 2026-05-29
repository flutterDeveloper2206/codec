import '../app_export.dart';

abstract class CTC {
  /// Default font family
  static const String defaultFontOfApp = 'Inter';
  static const String _defaultFontFamily = defaultFontOfApp;
  static const FontWeight _defaultFontWeight = FontWeight.w400;

  static TextStyle style(int size,
      {Color? fontColor, String? fontFamily, FontWeight? fontWeight}) {
    const defaultFontColor = ColorConstant.textBlack;
    switch (size) {
      case 12:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(14), //7.5.sp
            fontWeight: fontWeight ?? _defaultFontWeight,
            color: fontColor ?? defaultFontColor);
      case 14:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(14), //7.5.sp
            fontWeight: fontWeight ?? _defaultFontWeight,
            color: fontColor ?? defaultFontColor);
      case 15:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(14), //7.5.sp
            fontWeight: fontWeight ?? _defaultFontWeight,
            color: fontColor ?? defaultFontColor);
      case 16:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(15), //7.5.sp
            fontWeight: fontWeight ?? _defaultFontWeight,
            color: fontColor ?? defaultFontColor);

      case 18:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(16),
            color: fontColor ?? defaultFontColor);
      case 21:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(17),
            color: fontColor ?? defaultFontColor);
      case 24:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(22),
            color: fontColor ?? defaultFontColor);
      case 22:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(16),
            color: fontColor ?? defaultFontColor);

      case 26:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(22),
            color: fontColor ?? defaultFontColor);
      case 27:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(11),
            color: fontColor ?? defaultFontColor);
      case 30:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(25),
            color: fontColor ?? defaultFontColor);

      case 44:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(30),
            color: fontColor ?? defaultFontColor);
      case 50:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(40),
            color: fontColor ?? defaultFontColor);

      case 90:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(75),
            color: fontColor ?? defaultFontColor);
      case 100:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontWeight: fontWeight ?? _defaultFontWeight,
            fontSize: getFontSize(15),
            color: fontColor ?? defaultFontColor);

      default:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(10.5), //12,
            fontWeight: fontWeight ?? _defaultFontWeight,
            color: fontColor ?? defaultFontColor);
    }
  }
}
