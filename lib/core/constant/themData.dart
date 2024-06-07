import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

const Color primaryColor = Color(0xff0264a5);
const Color secondaryColor = Color(0xff0363a5);
const Color secondaryButtonColor = Color.fromARGB(255, 9, 152, 247);
const Color tertiaryColor = Color(0xffe5eff6);
const Color scaffoldBackgroundColor = Color(0xffF5F5F5);
const Color accentColor = Color(0xffFFFFFF);
const Color errorColor = Color(0xff0264a5);
const Color introBackgroundColor = Color(0xff000000);
const Color descriptionColor = Color(0xffF5F5F5);
const Color titleColor = Color(0xffF5F5F5);
// const Color whiteTextColor = Color(0xffffffff);
const Color darkAppBarColor = Color(0xff252525);
const Color textColor = Color.fromARGB(255, 73, 92, 102);

const MaterialColor kprimary = MaterialColor(
  0xff0264a5,
  <int, Color>{
    50: Color(0xff0264a5),
    100: Color(0xff0264a5),
    200: Color(0xff0264a5),
    300: Color(0xff0264a5),
    400: Color(0xff0264a5),
    500: Color(0xff0264a5),
    600: Color(0xff0264a5),
    700: Color(0xff0264a5),
    800: Color(0xff0264a5),
    900: Color(0xff0264a5),
  },
);

ThemeData themeData(BuildContext context) => ThemeData(
      appBarTheme: const AppBarTheme(color: primaryColor),
      primaryColor: primaryColor,
      primarySwatch: kprimary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      brightness: Brightness.light,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: textColor,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: textColor.withOpacity(0.6),
        unselectedLabelColor: textColor.withOpacity(0.4),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ).apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      focusColor: primaryColor,
      indicatorColor: primaryColor,
    );

TextStyle appBarTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: textColor,
);

TextStyle headerTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w700,
        );

TextStyle descriptionStyle(BuildContext context) =>
    Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: 12,
          color: textColor.withOpacity(0.6),
          fontWeight: FontWeight.w400,
        );

TextStyle buttonTextStyle(BuildContext context) =>
    TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 12);

TextStyle titleStyle(BuildContext context) =>
    Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        );

TextStyle priceStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 14,
      color: textColor,
      textStyle: const TextStyle(decoration: TextDecoration.lineThrough),
      fontWeight: FontWeight.w900,
    );
TextStyle discountedStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 14,
      color: primaryColor,
      fontWeight: FontWeight.w900,
    );

EdgeInsetsGeometry? contentPadding =
    EdgeInsets.only(left: 4.w, bottom: 0.h, right: 0.w);
