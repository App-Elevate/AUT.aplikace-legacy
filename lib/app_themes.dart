import 'package:autojidelna/every_import.dart';
import 'package:flutter/cupertino.dart';

class Themes {
  //darkmode
  ThemeData darkTheme = ThemeData(
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
    canvasColor: Colors.black,
    colorScheme: const ColorScheme(
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
      surfaceTint: Colors.white,
    ),
    dialogBackgroundColor: const Color(0xFF3C3C3C),
    disabledColor: Colors.black26,
    focusColor: Colors.black45,
    highlightColor: Colors.black54,
    //MaterialColor primarySwatch,
    scaffoldBackgroundColor: const Color(0xff121212),
    //Color secondaryHeaderColor,
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    /* Color unselectedWidgetColor,
    String fontFamily,
    List<String> fontFamilyFallback,
    String package,*/
    iconTheme: const IconThemeData(
      size: 30,
      color: Colors.white,
    ),
    //primaryIconTheme:IconThemeData(),
    //TextTheme primaryTextTheme,
    textTheme: const TextTheme(),
    typography: Typography(),
    actionIconTheme: const ActionIconThemeData(),
    appBarTheme: const AppBarTheme(
      elevation: 2,
      backgroundColor: Color(0xff121212),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    /*badgeTheme:BadgeThemeData(),*/
    /*MaterialBannerThemeData bannerTheme, */
    /*BottomAppBarTheme bottomAppBarTheme,*/
    /*BottomNavigationBarThemeData bottomNavigationBarTheme,*/
    /* BottomSheetThemeData bottomSheetTheme,*/
    /* ButtonBarThemeData buttonBarTheme,*/
    buttonTheme: const ButtonThemeData(),
    cardTheme: const CardTheme(elevation: 2),
    /* CheckboxThemeData checkboxTheme,*/
    /* ChipThemeData chipTheme, */
    /*DataTableThemeData dataTableTheme,*/
    datePickerTheme: DatePickerThemeData(
      backgroundColor: const Color(0xff121212),
      headerBackgroundColor: Colors.white.withOpacity(0.1),
      headerForegroundColor: Colors.white,
      dividerColor: Colors.transparent,
      elevation: 0,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xff121212),
      elevation: 4,
      surfaceTintColor: Colors.black54,
      alignment: Alignment.center,
      iconColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        backgroundColor: Colors.transparent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        fontSize: 15,
      ),
      actionsPadding: EdgeInsets.fromLTRB(0, 0, 20, 7),
    ),
    dividerTheme: const DividerThemeData(color: Colors.white12),
    drawerTheme: const DrawerThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Color(0xff121212),
      scrimColor: Colors.black54, //this darkens the rest of app when drawer is open
      elevation: 2,
      width: 300,
    ),
    /* DropdownMenuThemeData dropdownMenuTheme,*/
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
            return Colors.white12; // Disabled color
          }
          return Themes().darkTheme.colorScheme.background; // Regular color
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.white38;
          }
          return Themes().darkTheme.colorScheme.onBackground;
        }),
        fixedSize: const MaterialStatePropertyAll(Size.fromHeight(50)),
        splashFactory: InkRipple.splashFactory,
        alignment: Alignment.center,
        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
        elevation: const MaterialStatePropertyAll(4),
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      collapsedTextColor: Color(0xffbb86fc),
      textColor: Colors.white,
    ),
    // filledButtonTheme: const FilledButtonThemeData(),
    // floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      dense: false,
      selectedColor: Colors.purple,
      iconColor: Colors.white,
      textColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
      ),
      leadingAndTrailingTextStyle: TextStyle(),
      visualDensity: VisualDensity.comfortable,
    ),
    /* MenuBarThemeData menuBarTheme,*/
    /* MenuButtonThemeData menuButtonTheme,*/
    /* MenuThemeData menuTheme,*/
    /* NavigationBarThemeData navigationBarTheme,*/
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
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xff121212),
      elevation: 2,
      contentTextStyle: TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      behavior: SnackBarBehavior.floating,
      insetPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      showCloseIcon: true,
      closeIconColor: Colors.white,
    ),
    switchTheme: const SwitchThemeData(splashRadius: 0),
    // tabBarTheme: const TabBarTheme(),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.white),
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(),
    timePickerTheme: const TimePickerThemeData(),
    toggleButtonsTheme: const ToggleButtonsThemeData(),
    tooltipTheme: const TooltipThemeData(),
  );
}
