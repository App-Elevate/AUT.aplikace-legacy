import 'package:autojidelna/app_themes.dart';
import 'package:flutter/material.dart';

class Themes {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        applyElevationOverlayColor: true,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        colorScheme: ColorSchemes.light,

        // Colors
        hintColor: hintColor,
        cardColor: cardColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        shadowColor: shadowColor,
        splashColor: splashColor,
        canvasColor: canvasColor,
        dividerColor: dividerColor,
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        disabledColor: disabledColor,
        highlightColor: highlightColor,
        indicatorColor: indicatorColor,
        secondaryHeaderColor: secondaryHeaderColor,
        dialogBackgroundColor: dialogBackgroundColor,
        unselectedWidgetColor: unselectedWidgetColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,

        // Icons
        iconTheme: IconThemeData(),
        actionIconTheme: ActionIconThemeData(),
        primaryIconTheme: IconThemeData(),

        // Buttons
        buttonTheme: ButtonThemeData(),
        buttonBarTheme: ButtonBarThemeData(),
        iconButtonTheme: IconButtonThemeData(),
        menuButtonTheme: MenuButtonThemeData(),
        textButtonTheme: TextButtonThemeData(),
        filledButtonTheme: FilledButtonThemeData(),
        toggleButtonsTheme: ToggleButtonsThemeData(),
        elevatedButtonTheme: ElevatedButtonThemeData(),
        outlinedButtonTheme: OutlinedButtonThemeData(),
        segmentedButtonTheme: SegmentedButtonThemeData(),
        floatingActionButtonTheme: FloatingActionButtonThemeData(),

        // Menus
        menuTheme: MenuThemeData(),
        menuBarTheme: MenuBarThemeData(),
        popupMenuTheme: PopupMenuThemeData(),
        dropdownMenuTheme: DropdownMenuThemeData(),

        // ListTiles
        listTileTheme: ListTileThemeData(),
        expansionTileTheme: ExpansionTileThemeData(),

        // Pickers
        datePickerTheme: DatePickerThemeData(),
        timePickerTheme: TimePickerThemeData(),

        cardTheme: CardTheme(),
        chipTheme: ChipThemeData(),
        textTheme: TextTheme(),
        badgeTheme: BadgeThemeData(),
        radioTheme: RadioThemeData(),
        appBarTheme: AppBarTheme(),
        bannerTheme: MaterialBannerThemeData(),
        dialogTheme: DialogTheme(),
        drawerTheme: DrawerThemeData(),
        sliderTheme: SliderThemeData(),
        switchTheme: SwitchThemeData(),
        tabBarTheme: TabBarTheme(),
        dividerTheme: DividerThemeData(),
        tooltipTheme: TooltipThemeData(),
        checkboxTheme: CheckboxThemeData(),
        snackBarTheme: SnackBarThemeData(),
        dataTableTheme: DataTableThemeData(),
        scrollbarTheme: ScrollbarThemeData(),
        searchBarTheme: SearchBarThemeData(),
        searchViewTheme: SearchViewThemeData(),
        primaryTextTheme: TextTheme(),
        bottomSheetTheme: BottomSheetThemeData(),
        bottomAppBarTheme: BottomAppBarTheme(),
        navigationBarTheme: NavigationBarThemeData(),
        textSelectionTheme: TextSelectionThemeData(),
        navigationRailTheme: NavigationRailThemeData(),
        pageTransitionsTheme: PageTransitionsTheme(),
        inputDecorationTheme: InputDecorationTheme(),
        navigationDrawerTheme: NavigationDrawerThemeData(),
        progressIndicatorTheme: ProgressIndicatorThemeData(),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(),
      );
  static ThemeData get dark => ThemeData();
}
