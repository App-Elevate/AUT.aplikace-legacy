// Purpose: Contains the themes and color schemes used in the app.

import 'package:autojidelna/local_imports.dart';
import 'package:flutter/material.dart';

class Themes {
  /// Gets themeData
  static ThemeData getTheme(ThemeStyle themeStyle, {bool? isPureBlack}) {
    ColorScheme colorScheme = ColorSchemes.getColorScheme(themeStyle, isPureBlack: isPureBlack);
    bool dark = colorScheme.brightness == Brightness.dark;
    bool pureBlack = isPureBlack ?? false;

    return ThemeData(
      // Misc
      useMaterial3: true,
      applyElevationOverlayColor: true,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Colors
      colorScheme: colorScheme,
      canvasColor: colorScheme.surface,
      disabledColor: colorScheme.surfaceContainerHighest,
      scaffoldBackgroundColor: colorScheme.surface,
      shadowColor: Colors.transparent,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      typography: Typography.material2021(),

      // Texts
      textTheme: TextTheme(
        bodySmall: TextStyle(fontFamily: Fonts.body),
        bodyMedium: TextStyle(fontFamily: Fonts.body),
        bodyLarge: TextStyle(fontFamily: Fonts.body),
        labelSmall: TextStyle(fontFamily: Fonts.headings, color: colorScheme.onSurfaceVariant),
        labelMedium: TextStyle(fontFamily: Fonts.headings, color: colorScheme.onSurfaceVariant),
        labelLarge: TextStyle(fontFamily: Fonts.headings, color: colorScheme.onSurfaceVariant),
        titleSmall: TextStyle(fontFamily: Fonts.headings),
        titleMedium: TextStyle(fontFamily: Fonts.headings),
        titleLarge: TextStyle(fontFamily: Fonts.headings),
        headlineSmall: TextStyle(fontFamily: Fonts.headings),
        headlineMedium: TextStyle(fontFamily: Fonts.headings),
        headlineLarge: TextStyle(fontFamily: Fonts.headings),
        displaySmall: TextStyle(fontFamily: Fonts.headings),
        displayMedium: TextStyle(fontFamily: Fonts.headings),
        displayLarge: TextStyle(fontFamily: Fonts.headings),
      ),

      // Main
      iconTheme: IconThemeData(size: 30, color: colorScheme.onSurface),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: pureBlack ? 0 : 2,
        elevation: pureBlack ? 0 : 2,
        actionsIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      dividerTheme: DividerThemeData(color: colorScheme.surfaceContainerHighest),
      drawerTheme: DrawerThemeData(
        surfaceTintColor: colorScheme.surfaceTint,
        backgroundColor: colorScheme.surface,
        scrimColor: colorScheme.scrim,
        elevation: 2,
        width: 275,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.secondary,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: pureBlack ? 0 : null,
      ),

      // Popups
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        elevation: pureBlack ? 0 : 2,
        contentTextStyle: TextStyle(fontFamily: Fonts.body, color: colorScheme.onInverseSurface),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        showCloseIcon: true,
        closeIconColor: colorScheme.onInverseSurface,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        headerBackgroundColor: dark ? colorScheme.onSurface.withOpacity(0.1) : colorScheme.secondary,
        headerForegroundColor: dark ? colorScheme.onSurface : colorScheme.onSecondary,
        dividerColor: Colors.transparent,
        elevation: pureBlack ? 0 : 2,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 3,
        surfaceTintColor: colorScheme.surfaceTint,
        alignment: Alignment.center,
        iconColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: Fonts.headings,
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(fontFamily: Fonts.body, fontSize: 15),
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 16, 7),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colorScheme.surface,
        dialHandColor: dark ? colorScheme.onSurface.withOpacity(0.1) : colorScheme.secondary,
        elevation: 3,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        alignLabelWithHint: true,
        isDense: true,
        errorMaxLines: 1,
        labelStyle: TextStyle(fontFamily: Fonts.body),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        hintStyle: TextStyle(fontFamily: Fonts.body),
        helperStyle: TextStyle(fontFamily: Fonts.body),
        border: const OutlineInputBorder(),
      ),

      // List tiles
      listTileTheme: ListTileThemeData(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        dense: false,
        selectedColor: colorScheme.primary,
        iconColor: colorScheme.primary.withOpacity(.75),
        titleTextStyle: TextStyle(
          fontSize: 19,
          fontFamily: Fonts.body,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 13,
          fontFamily: Fonts.body,
          color: colorScheme.onSurfaceVariant,
        ),
        visualDensity: VisualDensity.comfortable,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        collapsedTextColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
        childrenPadding: const EdgeInsets.only(bottom: 8),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        modalElevation: 1,
        clipBehavior: Clip.hardEdge,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: pureBlack ? colorScheme.surfaceContainerHighest : Colors.transparent, strokeAlign: 1),
        ),
      ),

      // Buttons
      switchTheme: const SwitchThemeData(splashRadius: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontFamily: Fonts.headings,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) return colorScheme.surfaceContainerHighest; // Disabled color
            return colorScheme.surface; // Regular color
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return colorScheme.onSurfaceVariant;
            return colorScheme.onSurface;
          }),
          fixedSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
          splashFactory: InkRipple.splashFactory,
          alignment: Alignment.center,
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(4),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(BorderSide(
            width: 1.75,
            color: colorScheme.onSurfaceVariant,
          )),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.primary;
              }
              return Colors.transparent;
            },
          ),
        ),
      ),
    );
  }
}

class ColorSchemes {
  /// Gets a colorscheme based on arguments
  static ColorScheme getColorScheme(ThemeStyle themeStyle, {bool? isPureBlack}) {
    List<Color> colors = colorStyles[themeStyle] ?? colorStyles.values.first;
    switch (isPureBlack) {
      case true:
        return pureBlack.copyWith(primary: colors[2], secondary: colors[3]);
      case false:
        return dark.copyWith(primary: colors[2], secondary: colors[3]);
      default:
        return light.copyWith(primary: colors[0], secondary: colors[1]);
    }
  }

  /// Map of color combinations used by the app for theme style
  ///
  /// Colors are saved as a List<Color> = [primaryLight, secondaryLight, primaryDark, secondaryDark]
  static Map<ThemeStyle, List<Color>> colorStyles = {
    ThemeStyle.defaultStyle: [
      const Color(0xFFE040FB),
      const Color(0x7B009687),
      const Color(0xffbb86fc),
      const Color(0xff018786),
    ],
    ThemeStyle.plumBrown: [
      const Color(0xFFAC009E),
      const Color(0xFF815342),
      const Color(0xFFA03998),
      const Color(0xFF7F2A0B),
    ],
    ThemeStyle.blueMauve: [
      const Color(0xFF3741F7),
      const Color(0xFFA3385F),
      const Color(0xFF6264D7),
      const Color(0xFF6F354E),
    ],
    ThemeStyle.rustOlive: [
      const Color(0xFFAB4D00),
      const Color(0xFF6D692B),
      const Color(0xFFC54F00),
      const Color(0xFF53500C),
    ],
    ThemeStyle.evergreenSlate: [
      const Color(0xFF306b1e),
      const Color(0xFF54624d),
      const Color(0xBC19A400),
      const Color(0xFF273421),
    ],
    ThemeStyle.crimsonEarth: [
      const Color(0xFFbe0f00),
      const Color(0xFF775651),
      const Color(0xFFC8423D),
      const Color(0xFF442925),
    ]
  };

  static ColorScheme light = const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.purpleAccent,
    onPrimary: Colors.white,
    secondary: Color(0x7B009687),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceContainerHighest: Colors.black12,
    onSurfaceVariant: Colors.black54,
    scrim: Colors.black54,
    surfaceTint: Colors.black,
    inverseSurface: Color(0xFF121212),
    onInverseSurface: Colors.white,
  );

  static ColorScheme dark = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffbb86fc),
    onPrimary: Colors.white,
    secondary: Color(0xff018786),
    onSecondary: Colors.white,
    error: Color(0xFFCF6679),
    onError: Colors.white,
    surface: Color(0xff121212),
    onSurface: Colors.white,
    surfaceContainerHighest: Colors.white12,
    onSurfaceVariant: Colors.white54,
    scrim: Colors.black54,
    surfaceTint: Colors.white,
    inverseSurface: Color(0xFFdddddd),
    onInverseSurface: Colors.black,
  );

  static ColorScheme pureBlack = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffbb86fc),
    onPrimary: Colors.white,
    secondary: Color(0xff018786),
    onSecondary: Colors.white,
    error: Color(0xFFCF6679),
    onError: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    surfaceContainerHighest: Colors.white12,
    onSurfaceVariant: Colors.white54,
    scrim: Colors.black87,
    surfaceTint: Colors.white,
    inverseSurface: Color(0xFFdddddd),
    onInverseSurface: Colors.black,
  );
}

class AutojidelnaStyles {
  final BorderRadiusGeometry accountPanelRadius = const BorderRadius.only(
    topLeft: Radius.circular(16.0),
    topRight: Radius.circular(16.0),
  );
}

AutojidelnaStyles autojidelnaStyles = AutojidelnaStyles();
