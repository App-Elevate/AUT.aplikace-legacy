import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/shared_prefs.dart';
import 'package:flutter/material.dart';

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
/// [skipWeekends]          | If true, doesnt display or skips weekends in Canteen menu
///
/// [dateFormat]            | Date Format used in the app
///
/// [relTimeStamps]         | If true, displays "today" instead of 1.1.2024
class AppearancePreferences with ChangeNotifier {
  ThemeStyle _themeStyle = ThemeStyle.defaultStyle;
  ThemeMode _themeMode = ThemeMode.system;
  TabletUi _tabletUi = TabletUi.auto;
  bool _isListUi = false;
  bool _isPureBlack = false;
  bool _bigCalendarMarkers = false;
  bool _skipWeekends = false;
  DateFormat _dateFormat = DateFormat.system;
  bool _relTimeStamps = false;

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
  bool get skipWeekends => _skipWeekends;

  /// Date Format getter
  DateFormat get dateFormat => _dateFormat;

  /// Relative TimeStamps getter
  bool get relTimeStamps => _relTimeStamps;

  /// Loads settings from shared preferences
  void loadFromShraredPreferences() async {
    _themeStyle = await readEnumFromSharedPreferences(SharedPrefsKeys.themeStyle, ThemeStyle.values, _themeStyle);
    _themeMode = await readEnumFromSharedPreferences(SharedPrefsKeys.themeMode, ThemeMode.values, _themeMode);
    _tabletUi = await readEnumFromSharedPreferences(SharedPrefsKeys.tabletUi, TabletUi.values, _tabletUi);
    _isListUi = await readBoolFromSharedPreferences(SharedPrefsKeys.listUi) ?? _isListUi;
    _isPureBlack = await readBoolFromSharedPreferences(SharedPrefsKeys.pureBlack) ?? _isPureBlack;
    _bigCalendarMarkers = await readBoolFromSharedPreferences(SharedPrefsKeys.bigCalendarMarkers) ?? _bigCalendarMarkers;
    _skipWeekends = await readBoolFromSharedPreferences(SharedPrefsKeys.skipWeekends) ?? _skipWeekends;
    _dateFormat = await readEnumFromSharedPreferences(SharedPrefsKeys.dateFormat, DateFormat.values, _dateFormat);
    _relTimeStamps = await readBoolFromSharedPreferences(SharedPrefsKeys.relTimeStamps) ?? _relTimeStamps;
    notifyListeners();
  }

  /// Setter for theme style
  void setThemeStyle(ThemeStyle themeStyle) {
    if (_themeStyle == themeStyle) return;
    _themeStyle = themeStyle;
    saveEnumToSharedPreferences(SharedPrefsKeys.themeStyle, _themeStyle);
    notifyListeners();
  }

  /// Setter for theme mode
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    saveEnumToSharedPreferences(SharedPrefsKeys.themeMode, _themeMode);
    notifyListeners();
  }

  /// Setter for tablet ui
  void setTabletUi(TabletUi tabletui) {
    _tabletUi = tabletui;
    saveEnumToSharedPreferences(SharedPrefsKeys.tabletUi, _tabletUi);
    notifyListeners();
  }

  /// Setter for list UI
  void setListUi(bool isListUi) {
    _isListUi = isListUi;
    saveBoolToSharedPreferences(SharedPrefsKeys.listUi, _isListUi);
    notifyListeners();
  }

  /// Setter for pure black
  void setPureBlack(bool isPureBlack) {
    _isPureBlack = isPureBlack;
    saveBoolToSharedPreferences(SharedPrefsKeys.pureBlack, _isPureBlack);
    notifyListeners();
  }

  /// Setter for big calendar markers
  void setCalendarMarkers(bool bigCalendarMarkers) {
    _bigCalendarMarkers = bigCalendarMarkers;
    saveBoolToSharedPreferences(SharedPrefsKeys.bigCalendarMarkers, _bigCalendarMarkers);
    notifyListeners();
  }

  /// Setter for date format
  void setDateFormat(DateFormat dateFormat) {
    _dateFormat = dateFormat;
    saveEnumToSharedPreferences(SharedPrefsKeys.dateFormat, _dateFormat);
    notifyListeners();
  }

  /// Setter for relative timestamps
  void setRelTimeStamps(bool relTimeStamps) {
    _relTimeStamps = relTimeStamps;
    saveBoolToSharedPreferences(SharedPrefsKeys.relTimeStamps, _relTimeStamps);
    notifyListeners();
  }

  /// Setter for skip weekends
  void setSkipWeekends(bool skipWeekends) {
    _skipWeekends = skipWeekends;
    saveBoolToSharedPreferences(SharedPrefsKeys.skipWeekends, _skipWeekends);
    notifyListeners();
  }
}

class NotificationPreferences with ChangeNotifier {
  bool _todaysFood = false;
  TimeOfDay _sendTodaysFood = const TimeOfDay(hour: 11, minute: 0);
  bool _lowCredit = false;
  bool _weekLongFamine = false;

  bool get todaysFood => _todaysFood;
  TimeOfDay get sendTodaysFood => _sendTodaysFood;
  bool get lowCredit => _lowCredit;
  bool get weekLongFamine => _weekLongFamine;

  void setAll({
    bool? todaysFood,
    TimeOfDay? sendTodaysFood,
    bool? lowCredit,
    bool? weekLongFamine,
  }) {
    _todaysFood = todaysFood ?? _todaysFood;
    _sendTodaysFood = sendTodaysFood ?? _sendTodaysFood;
    _lowCredit = lowCredit ?? _lowCredit;
    _weekLongFamine = weekLongFamine ?? _weekLongFamine;
  }

  void setTodaysFood(bool todaysFood) {
    _todaysFood = todaysFood;
    saveBoolToSharedPreferences(SharedPrefsKeys.todaysFood, _todaysFood);
    notifyListeners();
  }

  void setSendTodaysFood(TimeOfDay sendTodaysFood) {
    _sendTodaysFood = sendTodaysFood;
    saveStringToSharedPreferences(SharedPrefsKeys.sendTodaysFood, _sendTodaysFood.toString());
    notifyListeners();
  }

  void setLowCredit(bool lowCredit) {
    _lowCredit = lowCredit;
    saveBoolToSharedPreferences(SharedPrefsKeys.lowCredit, _lowCredit);
    notifyListeners();
  }

  void setWeekLongFamine(bool weekLongFamine) {
    _weekLongFamine = weekLongFamine;
    saveBoolToSharedPreferences(SharedPrefsKeys.weekLongFamine, _weekLongFamine);
    notifyListeners();
  }
}
