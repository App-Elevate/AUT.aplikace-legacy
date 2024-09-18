// Purpose: stores constants used throughout the app.

import 'package:flutter/material.dart';

class Locales {
  static Locale get csCZ => const Locale('cs', 'CZ');
}

class NotificationIds {
  static String get kreditChannel => 'kredit_channel_';
  static String get objednanoChannel => 'objednano_channel_';
  static String get dnesniJidloChannel => 'jidlo_channel_';
  static String get channelGroup => 'channel_group_';
  static String get channelGroupElse => 'channel_group_else';
  static String get channelElse => 'else_channel';
  static String get payloadUser => 'user';
  static String get payloadIndex => 'index';
  static String get payloadIndexDne => 'indexDne';
  static String get objednatButton => 'objednat_';
}

class Nums {
  static int get switchAccountPanelDuration => 300;
}

class AnalyticsEventIds {
  static String get updateButtonClicked => 'updateButtonClicked';
  static String get oldVer => 'oldVersion';
  static String get newVer => 'newVersion';
  static String get updateDownloaded => 'updateDownloaded';
}

// Strings shown to the user
class NotificationsTexts {
  /// initAwesome and notifications in general have a problem with the localization package so we just force czech
  static String notificationsFor(String user) => 'Notifikace pro $user';
  static String get jidloChannelName => 'Dnešní jídlo';
  static String jidloChannelDescription(String user) => 'Notifikace každý den o tom jaké je dnes jídlo pro $user';
  static String get dochazejiciKreditChannelName => 'Docházející kredit';
  static String dochazejiciKreditChannelDescription(String user) => 'Notifikace o tom, zda vám dochází kredit týden dopředu pro $user';
  static String get objednanoChannelName => 'Objednáno?';
  static String objednanoChannelDescription(String user) => "Notifikace každý den o tom jaké je dnes jídlo pro $user";
  static String get notificationOther => 'Ostatní';
  static String get notificationOtherDescription => 'Ostatní notifikace, např. chybové hlášky...';
  static String get gettingDataNotifications => 'Získávám data pro notifikace';
  static String get notificationDochaziVamKredit => 'Dochází vám kredit!';
  static String notificationKreditPro(String jmeno, String prijmeni, int kredit) => 'Kredit pro $jmeno $prijmeni: $kredit Kč';
  static String get notificationZtlumit => 'Ztlumit na týden';
  static String get notificationObjednejteSi => 'Objednejte si na příští týden';
  static String notificationObjednejteSiDetail(String jmeno, String prijmeni) => 'Uživatel $jmeno $prijmeni si stále ještě neobjenal na příští týden';
  static String get objednatAction => 'Objednat náhodně';
  static String get notificationNoFood => 'Žádná jídla pro tento den';
  static String get nastalaChyba => 'Nastala chyba';
}

class Links {
  static String get autojidelna => 'https://autojidelna.cz';
  static String get repo => 'https://github.com/App-Elevate/AUT.aplikace';
  static String get latestVersionApi => 'https://api.github.com/repos/App-Elevate/AUT.aplikace/releases/latest';
  static String get appStore => '$autojidelna/release/appStore.json';
  static String currentVersionCode(String appVersion) => '$repo/blob/v$appVersion';

  static String get privacyPolicy => '$autojidelna/cs/privacy-policy/';
  static String currentChangelog(String version) => '$autojidelna/cs/changelogs/#$version';

  static String get latestRelease => '$repo/releases/latest';
  static String get email => 'info@appelevate.cz';
}

class Assets {
  static String get logo => 'assets/images/logo.svg';
}
