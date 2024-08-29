// Purpose: stores constants used throughout the app.

/// Shared Preferences Ids
class Prefs {
  static const String theme = 'theme';
  static const String calendarBigMarkers = 'calendar_big_markers';
  static const String disableAnalytics = 'analytics';
  static const String skipWeekends = 'skipWeekends';
  static const String dailyFoodInfo = 'sendFoodInfo-';
  static const String foodNotifTime = 'FoodNotificationTime';
  static const String kreditNotifications = 'ignore_kredit_';
  static const String nemateObjednanoNotifications = 'ignore_objednat_';
  static const String lastJidloDneCheck = 'lastJidloDneCheck-';
  static const String lastNotificationCheck = 'lastCheck-';
  static const String lastVersion = 'lastVersion';
  static const String statistikaObjednavka = 'statistika:objednavka';
  static const String url = 'url';
  static const String firstTime = 'firstTime';
  static const String location = 'location_';
}

class OldPrefs {
  static const String theme = 'themeMode';
  static const String disableAnalytics = 'disableAnalytics';
}

class NotificationIds {
  static const String kreditChannel = 'kredit_channel_';
  static const String objednanoChannel = 'objednano_channel_';
  static const String dnesniJidloChannel = 'jidlo_channel_';
  static const String channelGroup = 'channel_group_';
  static const String channelGroupElse = 'channel_group_else';
  static const String channelElse = 'else_channel';
  static const String payloadUser = 'user';
  static const String payloadIndex = 'index';
  static const String payloadIndexDne = 'indexDne';
  static const String objednatButton = 'objednat_';
}

class Nums {
  static const int switchAccountPanelDuration = 300;
}

class AnalyticsEventIds {
  static const String updateButtonClicked = 'updateButtonClicked';
  static const String oldVer = 'oldVersion';
  static const String newVer = 'newVersion';
  static const String updateDownloaded = 'updateDownloaded';
}

// Strings shown to the user
class NotificationsTexts {
  /// initAwesome and notifications in general have a problem with the localization package so we just force czech
  static String notificationsFor(String user) => 'Notifikace pro $user';
  static const String jidloChannelName = 'Dnešní jídlo';
  static String jidloChannelDescription(String user) => 'Notifikace každý den o tom jaké je dnes jídlo pro $user';
  static const String dochazejiciKreditChannelName = 'Docházející kredit';
  static String dochazejiciKreditChannelDescription(String user) => 'Notifikace o tom, zda vám dochází kredit týden dopředu pro $user';
  static const String objednanoChannelName = 'Objednáno?';
  static String objednanoChannelDescription(String user) => "Notifikace každý den o tom jaké je dnes jídlo pro $user";
  static const String notificationOther = 'Ostatní';
  static const String notificationOtherDescription = 'Ostatní notifikace, např. chybové hlášky...';
  static const String gettingDataNotifications = 'Získávám data pro notifikace';
  static const String notificationDochaziVamKredit = 'Dochází vám kredit!';
  static String notificationKreditPro(String jmeno, String prijmeni, int kredit) => 'Kredit pro $jmeno $prijmeni: $kredit Kč';
  static const String notificationZtlumit = 'Ztlumit na týden';
  static const String notificationObjednejteSi = 'Objednejte si na příští týden';
  static String notificationObjednejteSiDetail(String jmeno, String prijmeni) => 'Uživatel $jmeno $prijmeni si stále ještě neobjenal na příští týden';
  static const String objednatAction = 'Objednat náhodně';
  static const String notificationNoFood = 'Žádná jídla pro tento den';
  static const String nastalaChyba = 'Nastala chyba';
}

class Links {
  static const String autojidelna = 'https://autojidelna.cz/';
  static const String repo = 'https://github.com/Autojidelna/autojidelna';
  static const latestVersionApi = 'https://api.github.com/repos/Autojidelna/autojidelna/releases/latest';
  static const String appStore = 'https://autojidelna.cz/release/appStore.json';
  static String currentVersionCode(String appVersion) {
    return '$repo/blob/v$appVersion';
  }

  static String currentChangelog(String version) {
    return 'https://raw.githubusercontent.com/Autojidelna/autojidelna/v$version/CHANGELOG.md';
  }

  static String listSbiranychDat(String appVersion) {
    return '${currentVersionCode(appVersion)}/collected_data.md';
  }

  static String get latestRelease => '$repo/releases/latest';
}
