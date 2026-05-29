import '../app_export.dart';

class ColorConstant {
  static const Color primaryBlack = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  static const Color primaryBlue = Color(0xFF222663);
  static const Color textBlack = Color(0xFF303030);
  static const Color text00 = Color(0xFF000000);
  static const Color primaryGreen = Color(0xFF06AF52);
  static const Color flashingGreen = Color(0xFF79C753);
  static const Color flashGreen = Color(0xFF79c753);
  static const Color textRedFF = Color(0xFFFF0000);
  static const Color redFF2 = Color(0xFFFF2121);
  static const Color redF95 = Color(0xFFF95A37);
  static const Color greyE6E6 = Color(0xFFE6E6E6);
  static const Color greyD3 = Color(0xFFD3D3D3);
  static const Color greyF5 = Color(0xFFF5F5F5);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color primaryWhiteDark = Color(0xFF303030);
  // static const Color primaryYellow = Color(0xFFFFB628);
  static const Color primaryYellow = Color(0xFFFBBC31);
  static const Color backGroundColor = Color(0xFFF4F4F4);
  static const Color backGroundColorDark = Color(0xFF202029);
  static const Color grey4c4c = Color(0xFF4C4C4C);
  static const Color greyE2E2 = Color(0xFFE2E2E2);
  static const Color greyF5F4 = Color(0xFFF5F4F4);
  static const Color backGroundGreyColor = Color(0xFFE4E4E4);
  static const Color grey9DA = Color(0xFF9DA3AA);
  static const Color greyDCDC = Color(0xFFDCDCDC);
  static const Color naturalGrey = Color(0xFF8B8680);
  static Color greyDCDCfdgsf = Colors.grey;
  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFF4F4F4) // Light mode background color
        : Color(0xFF1E1E1E); //
    // Dark mode background color
  }

  static Color appBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryBlue // Light mode background color
        : Color(0xFF1E1E1E); // Dark mode background color
  }

  static Color backgroundTextField(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? greyE2E2 // Light mode background color
        : primaryWhiteDark; // Dark mode background color
  }

  static Color containerBackGround(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryWhite // Light mode background color
        : primaryWhiteDark; // Dark mode background color
  }

  static Color yellowToBlack(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryYellow // Light mode background color
        : primaryBlack; // Dark mode background color
  }

  static Color textBlackToYellow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textBlack // Light mode background color
        : primaryYellow; // Dark mode background color
  }

  static Color textBlackToWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textBlack // Light mode background color
        : primaryWhite; // Dark mode background color
  }

  static Color textDarkTOLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryBlue // Light mode background color
        : primaryWhite; // Dark mode background color
  }

  static Color textPrimaryBlackToWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryBlack // Light mode background color
        : primaryWhite; // Dark mode background color
  }

  static Color textGrey4c4cToYellow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? grey4c4c // Light mode background color
        : primaryYellow; // Dark mode background color
  }

  static Color textGrey4c4cToWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryBlack // Light mode background color
        : primaryWhite; // Dark mode background color
  }

  static Color text00ToWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? text00 // Light mode background color
        : primaryWhite; // Dark mode background color
  }

  static Color text00ToYellow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? text00 // Light mode background color
        : primaryYellow; // Dark mode background color
  }

  static Color textBlueToYellow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryBlue // Light mode background color
        : primaryYellow; // Dark mode background color
  }
}

class CustomTheme {
  // light theme
  static final lightTheme = ThemeData(
    primaryColor: lightThemeColor,
    brightness: Brightness.light,
    primaryColorLight: ColorConstant.primaryWhite,
    scaffoldBackgroundColor: ColorConstant.backGroundColor,
    useMaterial3: true,
    switchTheme: SwitchThemeData(
      thumbColor:
          MaterialStateProperty.resolveWith<Color>((states) => lightThemeColor),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: white,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: black,
        fontSize: 23, //20
      ),
      iconTheme: IconThemeData(color: lightThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: lightThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  // dark theme
  static final darkTheme = ThemeData(
    primaryColor: darkThemeColor,
    primaryColorLight: ColorConstant.primaryWhiteDark,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorConstant.backGroundColorDark,
    useMaterial3: true,
    switchTheme: SwitchThemeData(
      trackColor:
          MaterialStateProperty.resolveWith<Color>((states) => darkThemeColor),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: black,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: white,
        fontSize: 23, //20
      ),
      iconTheme: IconThemeData(color: darkThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: darkThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: black,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );

  // colors
  static Color lightThemeColor = Colors.red,
      white = Colors.white,
      black = Colors.black,
      darkThemeColor = Colors.yellow;
}
