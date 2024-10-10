import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = const Color.fromARGB(255, 148, 187, 233);
Color secondaryColor = const Color.fromARGB(255, 233, 174, 202);

Color baseColor = const Color(0xffffffff);
Color backgroundColor = const Color(0xffF3F4F6);
Color textColor = const Color.fromARGB(255, 43, 52, 64);

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: backgroundColor,
    elevation: 0
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
  ),
  textTheme: GoogleFonts.promptTextTheme(),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: baseColor,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: backgroundColor,
  ),
  useMaterial3: true,
);
