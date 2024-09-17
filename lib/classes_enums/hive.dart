class Boxes {
  static const String settings = 'settings';
  static const String appState = 'appState';
  static const String notifications = 'notifications';
  static const String statistics = 'statistics';
}

class HiveKeys {
  // appState box
  static String get locale => 'locale';
  static String get lastVersion => 'lastVersion';
  static String get firstTime => 'firstTime';
  static String get url => 'url';
  static String get hideBurzaAlertDialog => 'hideBurzaAlertDialog';
  static String location(String userName, String url) => 'location_${userName}_$url';

  //settings box
  static String get themeMode => 'themeMode';
  static String get themeStyle => 'themeStyle';
  static String get tabletUi => 'tabletUi';
  static String get listUi => 'listUi';
  static String get pureBlack => 'amoledMode';
  static String get bigCalendarMarkers => 'bigCalendarMarkers';
  static String get dateFormat => 'dateFormat';
  static String get relTimeStamps => 'relativeTimeStamps';
  static String get skipWeekends => 'skipWeekends';
  static String get todaysFood => 'todaysFood';
  static String get sendTodaysFood => 'sendTodaysFood';
  static String get lowCredit => 'lowCredit';
  static String get weekLongFamine => 'weekLongFamine';
  static String get analytics => 'analytics';

  // notification box
  static String lastNotificationCheck(String userName, String url) => 'lastCheck_${userName}_$url';
  static String lastJidloDneCheck(String userName, String url) => 'lastJidloDneCheck_${userName}_$url';
  static String nemateObjednanoNotifications(String userName, String url) => 'ignore_objednat_${userName}_$url';
  static String get onlyNemateObjednanoNotifications => 'ignore_objednat_';
  static String kreditNotifications(String userName, String url) => 'ignore_kredit_${userName}_$url';
  static String get onlykreditNotifications => 'ignore_kredit_';
  static String dailyFoodInfo(String userName, String url) => 'sendFoodInfo_${userName}_$url';

  // statistics box
  static String get statistikaObjednavka => 'statistika:objednavka';
  static String get statistikaAuto => 'statistika:auto';
  static String get statistikaBurzaCatcher => 'statistika:burzaCatcher';
}
