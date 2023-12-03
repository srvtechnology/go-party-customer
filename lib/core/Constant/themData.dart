import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
