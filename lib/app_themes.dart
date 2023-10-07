import 'package:autojidelna/every_import.dart';
import 'package:flutter/cupertino.dart';

class Themes {
  //light mode
  ThemeData themeDataLight = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.purple, // Purple as the primary color
      onPrimary: Colors.white, // Text color on primary background
      secondary: Color.fromRGBO(0, 118, 214, 1), // Secondary color (you can change this to your preference)
      onSecondary: Colors.white, // Text color on secondary background
      error: Colors.red, // Error color (you can change this to your preference)
      onError: Colors.white, // Text color on error background
      background: Colors.white, // Background color
      onBackground: Colors.black, // Text color on background
      surface: Colors.grey, // Surface color
      onSurface: Colors.black, // Text color on surface
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),

    //buttons
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        highlightColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 50, 50, 50),
          foregroundColor: Colors.white,
          fixedSize: const Size.fromWidth(500),
          padding: const EdgeInsets.all(10),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17.5,
          )),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Color.fromARGB(230, 0, 0, 0),
      textColor: Colors.black,
      titleTextStyle: TextStyle(fontSize: 20),
    ),
    iconTheme: const IconThemeData(color: Color.fromARGB(230, 0, 0, 0), size: 30),

    primaryTextTheme: const TextTheme(headlineSmall: TextStyle(), bodySmall: TextStyle()),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black, fontSize: 17, height: 1.5),
      displaySmall: TextStyle(color: Colors.black, fontSize: 12),
      headlineLarge: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Color.fromARGB(255, 100, 100, 100), fontSize: 17), //about dialog uses this
      titleLarge: TextStyle(color: Colors.black), // appbar title
      titleMedium: TextStyle(), //textfields
      titleSmall: TextStyle(color: Color.fromARGB(255, 150, 150, 150), fontSize: 18),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 20), //listview and stuff
      bodySmall: TextStyle(color: Color.fromARGB(175, 0, 0, 0), fontSize: 13), //aboutdialog uses this
      labelLarge: TextStyle(color: Colors.black),
      labelMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(color: Color.fromARGB(255, 100, 100, 100), fontSize: 15),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
  );

  //dark mode
  ThemeData themeDataDark = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.purple, // Purple as the primary color
      onPrimary: Colors.white, // Text color on primary background
      secondary: Color.fromRGBO(0, 118, 214, 1), // Secondary color (you can change this to your preference)
      onSecondary: Colors.white, // Text color on secondary background
      error: Colors.red, // Error color (you can change this to your preference)
      onError: Colors.white, // Text color on error background
      background: Colors.black, // Background color
      onBackground: Colors.white, // Text color on background
      surface: Colors.deepPurpleAccent, // Surface color
      onSurface: Colors.white, // Text color on surface
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),

    //buttons
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        highlightColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 100, 100, 100),
          foregroundColor: Colors.white,
          fixedSize: const Size.fromWidth(500),
          padding: const EdgeInsets.all(10),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17.5,
          )),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 20),
    ),
    iconTheme: const IconThemeData(color: Colors.white, size: 30),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white, fontSize: 17, height: 1.5),
      displaySmall: TextStyle(color: Colors.white, fontSize: 12),
      headlineLarge: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Color.fromARGB(255, 200, 200, 200), fontSize: 17), //aboutdialog uses this
      titleLarge: TextStyle(color: Colors.white), // appbar title
      titleMedium: TextStyle(), //textfields
      titleSmall: TextStyle(color: Color.fromARGB(255, 150, 150, 150), fontSize: 18),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 20), //listview and stuff
      bodySmall: TextStyle(color: Color.fromARGB(200, 255, 255, 255), fontSize: 13), //aboutdialog uses this
      labelLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(color: Color.fromARGB(150, 255, 255, 255), fontSize: 15),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
  );

  ThemeData raw = ThemeData(
    applyElevationOverlayColor: true,
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(),
    inputDecorationTheme: InputDecorationTheme(),
    materialTapTargetSize: MaterialTapTargetSize.padded,
    pageTransitionsTheme: PageTransitionsTheme(),
    platform: TargetPlatform.android,
    scrollbarTheme: ScrollbarThemeData(),
    splashFactory: NoSplash.splashFactory,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    canvasColor: Colors.amber,
    cardColor: Colors.amberAccent,
    colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.purple,
        onPrimary: Colors.white,
        secondary: Colors.deepPurple,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        background: Colors.black54,
        onBackground: Colors.white,
        surface: Colors.grey,
        onSurface: Colors.white),
    dialogBackgroundColor: Colors.black12,
    disabledColor: Colors.black26,
    dividerColor: Colors.black38,
    focusColor: Colors.black45,
    highlightColor: Colors.black54,
    hintColor: Colors.green,
    hoverColor: Colors.black87,
    indicatorColor: Colors.blue,
    /*primaryColor:Colors.blueAccent,
    primaryColorDark:Colors.blueGrey,
    primaryColorLight:Colors.purple,
    MaterialColor primarySwatch,*/
    scaffoldBackgroundColor: Colors.black,
    //Color secondaryHeaderColor,
    shadowColor: Colors.black,
    splashColor: Colors.transparent,
    /* Color unselectedWidgetColor,
    String fontFamily,
    List<String> fontFamilyFallback,
    String package,*/
    iconTheme: IconThemeData(),
    //primaryIconTheme:IconThemeData(),
    //TextTheme primaryTextTheme,
    textTheme: TextTheme(),
    typography: Typography(),
    actionIconTheme: ActionIconThemeData(),
    appBarTheme: AppBarTheme(),
    /*badgeTheme:BadgeThemeData(),*/
    /*MaterialBannerThemeData bannerTheme, */
    /*BottomAppBarTheme bottomAppBarTheme,*/
    /*BottomNavigationBarThemeData bottomNavigationBarTheme,*/
    /* BottomSheetThemeData bottomSheetTheme,*/
    /* ButtonBarThemeData buttonBarTheme,*/
    buttonTheme: ButtonThemeData(),
    /* CardTheme cardTheme,*/
    /* CheckboxThemeData checkboxTheme,*/
    /* ChipThemeData chipTheme, */
    /*DataTableThemeData dataTableTheme,*/
    datePickerTheme: DatePickerThemeData(),
    dialogTheme: DialogTheme(),
    dividerTheme: DividerThemeData(),
    drawerTheme: DrawerThemeData(),
    /* DropdownMenuThemeData dropdownMenuTheme,*/
    elevatedButtonTheme: ElevatedButtonThemeData(),
    expansionTileTheme: ExpansionTileThemeData(),
    filledButtonTheme: FilledButtonThemeData(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(),
    iconButtonTheme: IconButtonThemeData(),
    listTileTheme: ListTileThemeData(),
    /* MenuBarThemeData menuBarTheme,*/
    /* MenuButtonThemeData menuButtonTheme,*/
    /* MenuThemeData menuTheme,*/
    /* NavigationBarThemeData navigationBarTheme,*/
    navigationDrawerTheme: NavigationDrawerThemeData(),
    navigationRailTheme: NavigationRailThemeData(),
    outlinedButtonTheme: OutlinedButtonThemeData(),
    popupMenuTheme: PopupMenuThemeData(),
    progressIndicatorTheme: ProgressIndicatorThemeData(),
    radioTheme: RadioThemeData(),
    searchBarTheme: SearchBarThemeData(),
    searchViewTheme: SearchViewThemeData(),
    segmentedButtonTheme: SegmentedButtonThemeData(),
    sliderTheme: SliderThemeData(),
    snackBarTheme: SnackBarThemeData(),
    switchTheme: SwitchThemeData(),
    tabBarTheme: TabBarTheme(),
    textButtonTheme: TextButtonThemeData(),
    textSelectionTheme: TextSelectionThemeData(),
    timePickerTheme: TimePickerThemeData(),
    toggleButtonsTheme: ToggleButtonsThemeData(),
    tooltipTheme: TooltipThemeData(),
  );
}
