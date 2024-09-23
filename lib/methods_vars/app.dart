import 'package:autojidelna/classes_enums/adapters.hive.dart';
import 'package:autojidelna/classes_enums/hive.dart';
import 'package:hive_flutter/adapters.dart';

class App {
  static bool _initHiveExecuted = false;

  static Future<void> initHive() async {
    assert(_initHiveExecuted == false, 'App.initHive() must be called only once');
    if (_initHiveExecuted) return;

    await Hive.initFlutter();
    Hive.registerAdapter(ThemeModeAdapter());
    Hive.registerAdapter(ThemeStyleAdapter());
    Hive.registerAdapter(TabletUiAdapter());
    Hive.registerAdapter(DateFormatOptionsAdapter());
    await Hive.openBox(Boxes.settings);
    await Hive.openBox(Boxes.appState);
    await Hive.openBox(Boxes.notifications);
    await Hive.openBox(Boxes.statistics);

    _initHiveExecuted = true;
  }
}
