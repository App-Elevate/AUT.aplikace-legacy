import 'package:flutter/material.dart';

class LightColorScheme {
  static Brightness get brightness => Brightness.light;
  static Color get text => const Color(0xFF040316);
  static Color get background => const Color(0xFFfbfbfe);
  static Color get primary => const Color(0xFF370377);
  static Color get primaryFg => const Color(0xFFfbfbfe);
  static Color get secondary => const Color(0xFF76fefe);
  static Color get secondaryFg => const Color(0xFF040316);
  static Color get accent => const Color(0xFFc4aae4);
  static Color get accentFg => const Color(0xFF040316);

  /*
  static const colorScheme = ColorScheme(
    brightness: Brightness.light,
    background: backgroundColor,
    onBackground: textColor,
    primary: primaryColor,
    onPrimary: primaryFgColor,
    secondary: secondaryColor,
    onSecondary: secondaryFgColor,
    tertiary: accentColor,
    onTertiary: accentFgColor,
    surface: backgroundColor,
    onSurface: textColor,
    error: Brightness.light == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
    onError: Brightness.light == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
  );
  */
}

class DarkColorScheme {
  static Brightness get brightness => Brightness.dark;
  static Color get text => const Color(0xFFeae9fc);
  static Color get background => const Color(0xFF121212);
  static Color get primary => const Color(0xFFbc88fc);
  static Color get primaryFg => const Color(0xFF121212);
  static Color get secondary => const Color(0xFF018989);
  static Color get secondaryFg => const Color(0xFF121212);
  static Color get accent => const Color(0xFFc699ff);
  static Color get accentFg => const Color(0xFF121212);

  /*
  static colorScheme = ColorScheme(
    brightness: Brightness.dark,
    background: backgroundColor,
    onBackground: textColor,
    primary: primaryColor,
    onPrimary: primaryFgColor,
    secondary: secondaryColor,
    onSecondary: secondaryFgColor,
    tertiary: accentColor,
    onTertiary: accentFgColor,
    surface: backgroundColor,
    onSurface: textColor,
    error: Brightness.dark == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
    onError: Brightness.dark == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
  );
  */
}

class PureBlackColorScheme {
  static Brightness get brightness => Brightness.dark;
  static Color get text => const Color(0xFFebe9fc);
  static Color get background => const Color(0xFF010104);
  static Color get primary => const Color(0xFFbb86fc);
  static Color get primaryFg => const Color(0xFF010104);
  static Color get secondary => const Color(0xFF018786);
  static Color get secondaryFg => const Color(0xFF010104);
  static Color get accent => const Color(0xFF361b56);
  static Color get accentFg => const Color(0xFFebe9fc);

  /*
  static const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    background: backgroundColor,
    onBackground: textColor,
    primary: primaryColor,
    onPrimary: primaryFgColor,
    secondary: secondaryColor,
    onSecondary: secondaryFgColor,
    tertiary: accentColor,
    onTertiary: accentFgColor,
    surface: backgroundColor,
    onSurface: textColor,
    error: Brightness.dark == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
    onError: Brightness.dark == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
  );
  */
}
