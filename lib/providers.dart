import 'package:autojidelna/classes_enums/all.dart';
import 'package:flutter/material.dart';

/// Manages user preferences related to UI settings.
///
/// [themeStyle]
/// [themeMode]
/// [isListUi]
/// [isPureBlack]
/// [bigCalendarMarkers]
class UserPreferences with ChangeNotifier {
  ThemeStyle _themeStyle = ThemeStyle.defaultStyle;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isListUi = false;
  bool _isPureBlack = false;
  bool _bigCalendarMarkers = false;

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

  void setAll(
    ThemeStyle themeStyle,
    ThemeMode themeMode,
    bool isListUi,
    bool isPureBlack,
    bool bigCalendarMarkers,
  ) {
    _themeStyle = themeStyle;
    _themeMode = themeMode;
    _isListUi = isListUi;
    _isPureBlack = isPureBlack;
    _bigCalendarMarkers = bigCalendarMarkers;
    notifyListeners();
  }

  /// Setter for theme style
  set setThemeStyle(ThemeStyle themeStyle) {
    _themeStyle = themeStyle;
    notifyListeners();
  }

  /// Setter for theme mode
  set setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  /// Setter for list UI
  set setListUi(bool isListUi) {
    _isListUi = isListUi;
    notifyListeners();
  }

  /// Setter for pure black
  set setPureBlack(bool isPureBlack) {
    _isPureBlack = isPureBlack;
    notifyListeners();
  }

  /// Setter for bog calendar markers
  set setCalendarMarkers(bool bigCalendarMarkers) {
    _bigCalendarMarkers = bigCalendarMarkers;
    notifyListeners();
  }
}
