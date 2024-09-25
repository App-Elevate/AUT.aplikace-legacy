import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/providers.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'dart:convert';

bool sandbox = false;

class Sandbox {
  static const String _filePath = 'assets/map.json';

  static LoggedInUser get credentials => LoggedInUser(username: 'testUser', password: 'testPassWord123', url: 'jidelna.trebesin.cz');

  static Uzivatel get user => Uzivatel(
        uzivatelskeJmeno: 'skutecny123',
        jmeno: 'Jarmil',
        prijmeni: 'Skutečný',
        kategorie: 'Žáci',
        ucetProPlatby: '1234567890/1010',
        varSymbol: '1244235',
        kredit: 1263,
      );

  static Future<String> _loadJsonFromAssets() async {
    return await rootBundle.loadString(_filePath);
  }

  static Future<Jidelnicek> fakeLunchesForDay(DateTime date) async {
    String jsonString = await _loadJsonFromAssets();

    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    List<Jidelnicek> jidelnicky = jsonData.entries.map((json) => Jidelnicek.fromJson(json.value)).toList();

    int index = convertDateTimeToIndex(date);

    if (jidelnicky.isNotEmpty && index < jidelnicky.length) {
      Jidelnicek jidelnicek = jidelnicky[index];
      jidelnicek.den = DateTime(date.year, date.month, date.day);
      return jidelnicek;
    } else {
      return Jidelnicek(DateTime(date.year, date.month, date.day), []);
    }
  }

  static void login() {
    BuildContext ctx = MyApp.navigatorKey.currentState!.context;
    ctx.read<Ordering>().ordering = true;
    sandbox = true;
  }

  static void logout() {
    BuildContext ctx = MyApp.navigatorKey.currentState!.context;
    ctx.read<Ordering>().ordering = false;
    sandbox = false;
  }
}
