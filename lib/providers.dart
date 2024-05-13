import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/shared_prefs_functions.dart';
import 'package:flutter/material.dart';

/// Manages user preferences related to UI settings.
///
/// [themeStyle]
/// [themeMode]
/// [isListUi]
/// [isPureBlack]
/// [bigCalendarMarkers]
/// [skipWeekends]
class UserPreferences with ChangeNotifier {
  ThemeStyle _themeStyle = ThemeStyle.defaultStyle;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isListUi = false;
  bool _isPureBlack = false;
  bool _bigCalendarMarkers = false;
  bool _skipWeekends = false;

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

  void setAll(
    ThemeStyle themeStyle,
    ThemeMode themeMode,
    bool isListUi,
    bool isPureBlack,
    bool bigCalendarMarkers,
    bool skipWeekends,
  ) {
    _themeStyle = themeStyle;
    _themeMode = themeMode;
    _isListUi = isListUi;
    _isPureBlack = isPureBlack;
    _bigCalendarMarkers = bigCalendarMarkers;
    _skipWeekends = skipWeekends;
    notifyListeners();
  }

  /// Setter for theme style
  set setThemeStyle(ThemeStyle themeStyle) {
    if (_themeStyle == themeStyle) return;
    _themeStyle = themeStyle;
    saveStringToSharedPreferences("ThemeStyle", _themeStyle.toString());
    notifyListeners();
  }

  /// Setter for theme mode
  set setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    saveStringToSharedPreferences("ThemeMode", _themeMode.toString());
    notifyListeners();
  }

  /// Setter for list UI
  set setListUi(bool isListUi) {
    _isListUi = isListUi;
    saveBoolToSharedPreferences("ListUi", _isListUi);
    notifyListeners();
  }

  /// Setter for pure black
  set setPureBlack(bool isPureBlack) {
    _isPureBlack = isPureBlack;
    saveBoolToSharedPreferences("PureBlack", _isPureBlack);
    notifyListeners();
  }

  /// Setter for big calendar markers
  set setCalendarMarkers(bool bigCalendarMarkers) {
    _bigCalendarMarkers = bigCalendarMarkers;
    saveBoolToSharedPreferences("BigCalendarMarkers", _bigCalendarMarkers);
    notifyListeners();
  }

  /// Setter for skip weekends
  set setSkipWeekends(bool skipWeekends) {
    _skipWeekends = skipWeekends;
    saveBoolToSharedPreferences("SkipWeekends", _skipWeekends);
    notifyListeners();
  }
}
