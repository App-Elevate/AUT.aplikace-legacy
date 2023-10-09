import 'package:autojidelna/every_import.dart';
import 'package:flutter/cupertino.dart';

class Themes {
  //darkmode
  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    applyElevationOverlayColor: true,
    cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(),
    inputDecorationTheme: const InputDecorationTheme(
      alignLabelWithHint: true,
      isDense: true,
      isCollapsed: true,
      errorMaxLines: 1,
      labelStyle: TextStyle(),
      floatingLabelAlignment: FloatingLabelAlignment.start,
      hintStyle: TextStyle(),
      helperStyle: TextStyle(),
    ),
    materialTapTargetSize: MaterialTapTargetSize.padded,
    /* pageTransitionsTheme: const PageTransitionsTheme(), */
    scrollbarTheme: const ScrollbarThemeData(),
    splashFactory: NoSplash.splashFactory,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    canvasColor: ColorSchemes().darkColorScheme.background,
    colorScheme: ColorSchemes().darkColorScheme,
    disabledColor: ColorSchemes().darkColorScheme.surfaceVariant,
    scaffoldBackgroundColor: ColorSchemes().darkColorScheme.background,
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    /* Color unselectedWidgetColor,
    String fontFamily,
    List<String> fontFamilyFallback,
    String package,*/
    iconTheme: IconThemeData(
      size: 30,
      color: ColorSchemes().darkColorScheme.onBackground,
    ),
    // primaryIconTheme:IconThemeData(),
    // TextTheme primaryTextTheme,
    // textTheme: const TextTheme(),
    typography: Typography.material2021(),
    // actionIconTheme: const ActionIconThemeData(),
    appBarTheme: AppBarTheme(
      elevation: 2,
      backgroundColor: ColorSchemes().darkColorScheme.background,
      iconTheme: IconThemeData(
        color: ColorSchemes().darkColorScheme.onBackground,
      ),
      actionsIconTheme: IconThemeData(
        color: ColorSchemes().darkColorScheme.onBackground,
      ),
    ),
    // badgeTheme:BadgeThemeData(),
    // MaterialBannerThemeData bannerTheme,
    // BottomAppBarTheme bottomAppBarTheme,
    // BottomNavigationBarThemeData bottomNavigationBarTheme,
    // BottomSheetThemeData bottomSheetTheme,
    // ButtonBarThemeData buttonBarTheme,
    // buttonTheme: const ButtonThemeData(),
    cardTheme: const CardTheme(elevation: 2),
    // CheckboxThemeData checkboxTheme,
    // ChipThemeData chipTheme,
    // DataTableThemeData dataTableTheme,
    datePickerTheme: DatePickerThemeData(
      backgroundColor: ColorSchemes().darkColorScheme.background,
      headerBackgroundColor: ColorSchemes().darkColorScheme.onBackground.withOpacity(0.1),
      headerForegroundColor: ColorSchemes().darkColorScheme.onBackground,
      dividerColor: Colors.transparent,
      elevation: 0,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: ColorSchemes().darkColorScheme.background,
      elevation: 1,
      surfaceTintColor: ColorSchemes().darkColorScheme.surfaceTint,
      alignment: Alignment.center,
      iconColor: ColorSchemes().darkColorScheme.onBackground,
      titleTextStyle: TextStyle(
        color: ColorSchemes().darkColorScheme.onBackground,
        backgroundColor: Colors.transparent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        fontSize: 15,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 7),
    ),
    dividerTheme: DividerThemeData(color: ColorSchemes().darkColorScheme.surfaceVariant),
    drawerTheme: DrawerThemeData(
      surfaceTintColor: ColorSchemes().darkColorScheme.surfaceTint,
      backgroundColor: ColorSchemes().darkColorScheme.background,
      scrimColor: ColorSchemes().darkColorScheme.scrim, //this darkens the rest of app when drawer is open
      elevation: 2,
      width: 275,
    ),
    // DropdownMenuThemeData dropdownMenuTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: const MaterialStatePropertyAll(
          TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return ColorSchemes().darkColorScheme.surfaceVariant; // Disabled color
          }
          return ColorSchemes().darkColorScheme.background; // Regular color
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return ColorSchemes().darkColorScheme.onSurfaceVariant;
          }
          return ColorSchemes().darkColorScheme.onBackground;
        }),
        fixedSize: const MaterialStatePropertyAll(Size.fromHeight(50)),
        splashFactory: InkRipple.splashFactory,
        alignment: Alignment.center,
        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
        elevation: const MaterialStatePropertyAll(4),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedTextColor: ColorSchemes().darkColorScheme.primary,
      textColor: ColorSchemes().darkColorScheme.onSurface,
    ),
    // filledButtonTheme: const FilledButtonThemeData(),
    // floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    listTileTheme: ListTileThemeData(
      dense: false,
      selectedColor: ColorSchemes().darkColorScheme.primary,
      iconColor: ColorSchemes().darkColorScheme.onBackground,
      textColor: ColorSchemes().darkColorScheme.onBackground,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
      ),
      visualDensity: VisualDensity.comfortable,
    ),
    // MenuBarThemeData menuBarTheme,
    // MenuButtonThemeData menuButtonTheme,
    // MenuThemeData menuTheme,
    // NavigationBarThemeData navigationBarTheme,
    // navigationDrawerTheme: const NavigationDrawerThemeData(),
    // navigationRailTheme: const NavigationRailThemeData(),
    // outlinedButtonTheme: const OutlinedButtonThemeData(),
    // popupMenuTheme: const PopupMenuThemeData(),
    // progressIndicatorTheme: const ProgressIndicatorThemeData(),
    // radioTheme: const RadioThemeData(),
    // searchBarTheme: const SearchBarThemeData(),
    // searchViewTheme: const SearchViewThemeData(),
    // segmentedButtonTheme: const SegmentedButtonThemeData(),
    // sliderTheme: const SliderThemeData(),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ColorSchemes().darkColorScheme.inverseSurface,
      elevation: 2,
      contentTextStyle: TextStyle(color: ColorSchemes().darkColorScheme.onInverseSurface),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      insetPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      showCloseIcon: true,
      closeIconColor: ColorSchemes().darkColorScheme.onInverseSurface,
    ),
    switchTheme: const SwitchThemeData(splashRadius: 0),
    // tabBarTheme: const TabBarTheme(),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(ColorSchemes().darkColorScheme.onSurface),
        textStyle: const MaterialStatePropertyAll(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    // textSelectionTheme: const TextSelectionThemeData(),
    // timePickerTheme: const TimePickerThemeData(),
    // toggleButtonsTheme: const ToggleButtonsThemeData(),
    // tooltipTheme: const TooltipThemeData(),
  );
}

class ColorSchemes {
  final ColorScheme darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffbb86fc),
    onPrimary: Colors.black,
    secondary: Color(0xff018786),
    onSecondary: Colors.black,
    error: Color(0xFFCF6679),
    onError: Colors.white,
    background: Color(0xff121212),
    onBackground: Colors.white,
    surface: Color(0xff121212),
    onSurface: Colors.white,
    surfaceVariant: Colors.white12,
    onSurfaceVariant: Colors.white54,
    scrim: Colors.black54,
    surfaceTint: Colors.white,
    inverseSurface: Color(0xFFdddddd),
    onInverseSurface: Colors.black,
  );
}
