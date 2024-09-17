import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/classes_enums/hive.dart';
import 'package:autojidelna/methods_vars/widgets_tracking.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Manages user preferences related to UI settings.
///
/// [themeStyle]            | Colorscheme of the app
///
/// [themeMode]             | Theme mode of the app
///
/// [isTabletUi]            | If true, the app will use a tablet friendly ui
///
/// [isListUi]              | If true, Canteen menu is displayed in a list
///
/// [isPureBlack]           | If true, dark mode joins the dark side of the force
///
/// [bigCalendarMarkers]    | If true, displays big markers in calendar
///
/// [getSkipWeekends]       | If true, doesnt display or skips weekends in Canteen menu
///
/// [dateFormat]            | Date Format used in the app
///
/// [relTimeStamps]         | If true, displays "today" instead of 1.1.2024
///
/// [disableAnalytics]      | If true, disables analytics
class Settings with ChangeNotifier {
  static Box box = Hive.box(Boxes.settings);

  ThemeStyle _themeStyle = box.get(HiveKeys.themeStyle, defaultValue: ThemeStyle.defaultStyle);
  ThemeMode _themeMode = box.get(HiveKeys.themeMode, defaultValue: ThemeMode.dark);
  TabletUi _tabletUi = box.get(HiveKeys.tabletUi, defaultValue: TabletUi.auto);
  bool _isListUi = box.get(HiveKeys.listUi, defaultValue: false);
  bool _isPureBlack = box.get(HiveKeys.pureBlack, defaultValue: false);
  bool _bigCalendarMarkers = box.get(HiveKeys.bigCalendarMarkers, defaultValue: false);
  bool _skipWeekends = box.get(HiveKeys.skipWeekends, defaultValue: false);
  DateFormatOptions _dateFormat = box.get(HiveKeys.dateFormat, defaultValue: DateFormatOptions.dMy);
  bool _relTimeStamps = box.get(HiveKeys.relTimeStamps, defaultValue: false);
  bool _disableAnalytics = box.get(HiveKeys.analytics, defaultValue: false);

  /// Theme style getter
  ThemeStyle get themeStyle => _themeStyle;

  /// Theme mode getter
  ThemeMode get themeMode => _themeMode;

  /// Tablet UI getter
  TabletUi get tabletUi => _tabletUi;

  /// List UI getter
  bool get isListUi => _isListUi;

  /// Pure black getter
  bool get isPureBlack => _isPureBlack;

  /// Big calendar markers getter
  bool get bigCalendarMarkers => _bigCalendarMarkers;

  /// Skip weekends getter
  bool get getSkipWeekends => _skipWeekends;

  /// Date Format getter
  DateFormatOptions get dateFormat => _dateFormat;

  /// Relative TimeStamps getter
  bool get relTimeStamps => _relTimeStamps;

  /// Analytics getter
  bool get disableAnalytics => _disableAnalytics;

  /// Setter for theme style
  void setThemeStyle(ThemeStyle themeStyle) {
    if (_themeStyle == themeStyle) return;
    _themeStyle = themeStyle;
    box.put(HiveKeys.themeStyle, _themeStyle);
    notifyListeners();
  }

  /// Setter for theme mode
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    box.put(HiveKeys.themeMode, _themeMode);
    notifyListeners();
  }

  /// Setter for tablet ui
  void setTabletUi(TabletUi tabletui) {
    _tabletUi = tabletui;
    box.put(HiveKeys.tabletUi, _tabletUi);
    notifyListeners();
  }

  /// Setter for list UI
  void setListUi(bool isListUi) {
    _isListUi = isListUi;
    box.put(HiveKeys.listUi, _isListUi);
    notifyListeners();
  }

  /// Setter for pure black
  void setPureBlack(bool isPureBlack) {
    _isPureBlack = isPureBlack;
    box.put(HiveKeys.pureBlack, _isPureBlack);
    notifyListeners();
  }

  /// Setter for big calendar markers
  void setCalendarMarkers(bool bigCalendarMarkers) {
    _bigCalendarMarkers = bigCalendarMarkers;
    box.put(HiveKeys.bigCalendarMarkers, _bigCalendarMarkers);
    notifyListeners();
  }

  /// Setter for date format
  void setDateFormat(DateFormatOptions dateFormat) {
    _dateFormat = dateFormat;
    box.put(HiveKeys.dateFormat, _dateFormat);
    notifyListeners();
  }

  /// Setter for relative timestamps
  void setRelTimeStamps(bool relTimeStamps) {
    _relTimeStamps = relTimeStamps;
    box.put(HiveKeys.relTimeStamps, _relTimeStamps);
    notifyListeners();
  }

  /// Setter for skip weekends
  void setSkipWeekends(bool privateSkipWeekends) {
    _skipWeekends = privateSkipWeekends;
    skipWeekends = privateSkipWeekends;
    box.put(HiveKeys.skipWeekends, _skipWeekends);
    notifyListeners();
  }

  /// Setter for analytics
  void setAnalytics(bool disabled) {
    _disableAnalytics = disabled;
    analyticsEnabledGlobally = disabled;
    box.put(HiveKeys.analytics, _disableAnalytics);
    notifyListeners();
  }
}

class DishesOfTheDay with ChangeNotifier {
  Map<int, Jidelnicek> _menus = {}; // Store menus by day index
  Map<int, int> _numberOfDishes = {};
  int _dayIndex = DateTime.now().difference(minimalDate).inDays; // Store day index separately if needed

  Map<int, Jidelnicek> get allMenus => _menus;

  Map<int, int> get allNumberOfDishes => _numberOfDishes;

  Jidelnicek? getMenu(int dayIndex) => _menus[dayIndex];

  int? getNumberOfDishes(int dayIndex) => _numberOfDishes[dayIndex];

  int get dayIndex => _dayIndex;

  void reset() {
    _menus = {};
    _numberOfDishes = {};
  }

  void resetMenu() {
    _menus = {};
  }

  void setMenu(int dayIndex, Jidelnicek menu) {
    if (_menus[dayIndex] == menu) return;
    _menus.update(dayIndex, (_) => menu, ifAbsent: () => menu);
    _menus = Map.from(_menus);
    notifyListeners();
  }

  void setNumberOfDishes(int dayIndex, int numberOfDishes) {
    if (_numberOfDishes[dayIndex] == numberOfDishes) return;
    _numberOfDishes.update(dayIndex, (_) => numberOfDishes, ifAbsent: () => numberOfDishes);
    _numberOfDishes = Map.from(_numberOfDishes);
    notifyListeners();
  }

  void setDayIndex(int dayIndex) {
    if (_dayIndex == dayIndex) return;
    _dayIndex = dayIndex;
    notifyListeners();
  }
}

class Ordering with ChangeNotifier {
  bool _ordering = false;

  bool get ordering => _ordering;

  set ordering(bool ordering) {
    if (_ordering == ordering) return;
    _ordering = ordering;
    notifyListeners();
  }
}

class CurrentUser with ChangeNotifier {
  Uzivatel _user = Uzivatel();

  Uzivatel get user => _user;

  set user(Uzivatel user) {
    _user = user;
    notifyListeners();
  }
}
