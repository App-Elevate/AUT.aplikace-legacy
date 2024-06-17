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
class UserPreferences with ChangeNotifier {
  ThemeStyle _themeStyle = ThemeStyle.defaultStyle;
  ThemeMode _themeMode = ThemeMode.system;
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
    _themeStyle = await readEnumFromSharedPreferences(Keys.themeStyle, ThemeStyle.values, _themeStyle);
    _themeMode = await readEnumFromSharedPreferences(Keys.themeMode, ThemeMode.values, _themeMode);
    _isListUi = await readBoolFromSharedPreferences(Keys.listUi) ?? _isListUi;
    _isPureBlack = await readBoolFromSharedPreferences(Keys.pureBlack) ?? _isPureBlack;
    _bigCalendarMarkers = await readBoolFromSharedPreferences(Keys.bigCalendarMarkers) ?? _bigCalendarMarkers;
    _skipWeekends = await readBoolFromSharedPreferences(Keys.skipWeekends) ?? _skipWeekends;
    _dateFormat = await readEnumFromSharedPreferences(Keys.dateFormat, DateFormat.values, _dateFormat);
    _relTimeStamps = await readBoolFromSharedPreferences(Keys.relTimeStamps) ?? _relTimeStamps;
    notifyListeners();
  }

  /// Setter for theme style
  void setThemeStyle(ThemeStyle themeStyle) {
    if (_themeStyle == themeStyle) return;
    _themeStyle = themeStyle;
    saveEnumToSharedPreferences(Keys.themeStyle, _themeStyle);
    notifyListeners();
  }

  /// Setter for theme mode
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    saveEnumToSharedPreferences(Keys.themeMode, _themeMode);
    notifyListeners();
  }

  /// Setter for list UI
  void setListUi(bool isListUi) {
    _isListUi = isListUi;
    saveBoolToSharedPreferences(Keys.listUi, _isListUi);
    notifyListeners();
  }

  /// Setter for pure black
  void setPureBlack(bool isPureBlack) {
    _isPureBlack = isPureBlack;
    saveBoolToSharedPreferences(Keys.pureBlack, _isPureBlack);
    notifyListeners();
  }

  /// Setter for big calendar markers
  void setCalendarMarkers(bool bigCalendarMarkers) {
    _bigCalendarMarkers = bigCalendarMarkers;
    saveBoolToSharedPreferences(Keys.bigCalendarMarkers, _bigCalendarMarkers);
    notifyListeners();
  }

  /// Setter for date format
  void setDateFormat(DateFormat dateFormat) {
    _dateFormat = dateFormat;
    saveEnumToSharedPreferences(Keys.dateFormat, _dateFormat);
    notifyListeners();
  }

  /// Setter for relative timestamps
  void setRelTimeStamps(bool relTimeStamps) {
    _relTimeStamps = relTimeStamps;
    saveBoolToSharedPreferences(Keys.relTimeStamps, _relTimeStamps);
    notifyListeners();
  }

  /// Setter for skip weekends
  void setSkipWeekends(bool skipWeekends) {
    _skipWeekends = skipWeekends;
    saveBoolToSharedPreferences(Keys.skipWeekends, _skipWeekends);
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
    saveBoolToSharedPreferences(Keys.todaysFood, _todaysFood);
    notifyListeners();
  }

  void setSendTodaysFood(TimeOfDay sendTodaysFood) {
    _sendTodaysFood = sendTodaysFood;
    saveStringToSharedPreferences(Keys.sendTodaysFood, _sendTodaysFood.toString());
    notifyListeners();
  }

  void setLowCredit(bool lowCredit) {
    _lowCredit = lowCredit;
    saveBoolToSharedPreferences(Keys.lowCredit, _lowCredit);
    notifyListeners();
  }

  void setWeekLongFamine(bool weekLongFamine) {
    _weekLongFamine = weekLongFamine;
    saveBoolToSharedPreferences(Keys.weekLongFamine, _weekLongFamine);
    notifyListeners();
  }
}
