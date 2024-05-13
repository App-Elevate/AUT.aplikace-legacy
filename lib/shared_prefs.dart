import 'package:shared_preferences/shared_preferences.dart';

void saveIntToSharedPreferences(String key, int value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, value);
}

void saveBoolToSharedPreferences(String key, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

void saveDoubleToSharedPreferences(String key, double value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble(key, value);
}

void saveStringToSharedPreferences(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

void saveStringListToSharedPreferences(String key, List<String> value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(key, value);
}

Future<int?> readIntFromSharedPreferences(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future<bool?> readBoolFromSharedPreferences(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

Future<double?> readDoubleFromSharedPreferences(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(key);
}

Future<String?> readStringFromSharedPreferences(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<List<String>?> readListStringFromSharedPreferences(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key);
}

Future<void> removeFromSharedPreferences(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}
