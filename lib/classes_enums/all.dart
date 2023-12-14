// Všechny objekty a enumy, které se používají v aplikaci
import 'dart:async';

import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';

export '../methods_vars/notifications.dart';

///enum pro výběr stránky v navigačním menu
enum NavigationDrawerItem { jidelnicek, automatickeObjednavky, burzaCatcher }

//classy pro přihlašování

///samotný uživatel
class LoggedInUser {
  String username;
  String password;
  String url;
  LoggedInUser({
    required this.username,
    required this.password,
    required this.url,
  });
  LoggedInUser.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        url = json['url'];
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'url': url,
      };
}

///všichni přihlášení uživatelé
class LoginDataAutojidelna {
  LoginDataAutojidelna({
    required this.currentlyLoggedIn,
  });
  bool currentlyLoggedIn;
  int? currentlyLoggedInId;
  List<LoggedInUser> users = [];

  LoginDataAutojidelna.fromJson(Map<String, dynamic> json)
      : currentlyLoggedIn = json['currentlyLoggedIn'],
        currentlyLoggedInId = json['currentlyLoggedInId'],
        users = json['users'].map<LoggedInUser>((e) => LoggedInUser.fromJson(e)).toList();

  Map<String, dynamic> toJson() => {
        'currentlyLoggedIn': currentlyLoggedIn,
        'currentlyLoggedInId': currentlyLoggedInId,
        'users': users.map((e) => e.toJson()).toList(),
      };
}

///omezená data pro zobrazení ve výběru účtů
class LoggedAccountsInAccountPanel {
  List<String> usernames;
  int? loggedInID;
  LoggedAccountsInAccountPanel({required this.usernames, required this.loggedInID});
}

///informace o nejnovější verzi aplikace (podpora jen pro android)
class ReleaseInfo {
  ReleaseInfo({
    required this.isAndroid,
    this.latestVersion,
    this.downloadUrl,
    this.changelog,
    this.appStoreUrl,
    this.isOnAppstore,
    this.googlePlayUrl,
    this.isOnGooglePlay,
    required this.currentlyLatestVersion,
  });
  String? latestVersion;
  String? downloadUrl;
  String? changelog;
  bool? isOnAppstore;
  bool? isOnGooglePlay;
  String? googlePlayUrl;
  String? appStoreUrl;
  bool currentlyLatestVersion;
  bool isAndroid;
}

///Třída pro kešování dat Canteeny
class CanteenData {
  /// id, aby se nám neindexovaly špatně jídelníčky
  int id;

  /// login uživatele
  String username;

  /// url kantýny
  String url;

  /// info o uživateli - např kredit,jméno,příjmení...
  Uzivatel uzivatel;

  /// seznam předindexovaných jídelníčků začínající Od Pondělí tohoto týdne
  Map<DateTime, Jidelnicek> jidelnicky;

  /// fix pro api vracející méně jídel než by mělo
  Map<DateTime, int> pocetJidel;

  /// seznam jídel, které jsou na burze
  List<Burza> jidlaNaBurze;

  /// jídelníčky, které aktuálně načítáme
  Map<DateTime, Completer<Jidelnicek>> currentlyLoading;

  CanteenData({
    required this.username,
    required this.url,
    required this.uzivatel,
    required this.jidlaNaBurze,
    this.id = 0,
    required this.currentlyLoading,
    required this.jidelnicky,
    required this.pocetJidel,
  });
  CanteenData copyWith() {
    return CanteenData(
        username: username,
        url: url,
        uzivatel: uzivatel,
        jidlaNaBurze: jidlaNaBurze,
        currentlyLoading: currentlyLoading,
        jidelnicky: jidelnicky,
        pocetJidel: pocetJidel);
  }
}

///class pro general access o stavu snackbaru
class SnackBarShown {
  SnackBarShown({required this.shown});
  bool shown = false;
}

///class pro public access k aktuální zobrazované stránce
class JidelnicekPageNum {
  JidelnicekPageNum({required this.pageNumber});
  int pageNumber;
}

///Popisuje všechny možné stavy jídla
enum StavJidla {
  /// je objednano a lze odebrat
  objednano,

  /// je objednano a lze pouze dát na burzu
  objednanoNelzeOdebrat,

  /// bylo objednano a pravděpodobně snězeno ;)
  objednanoVyprsenaPlatnost,

  /// nabízíme jídlo na burze
  naBurze,

  /// jídlo nemáme objednané, ale je dostupné na burze
  dostupneNaBurze,

  /// jídlo nemáme objednané, ale můžeme stále ještě normálně objednat
  neobjednano,

  /// jídlo nemáme objednané a není dostupné na burze, vypršela platnost nebo nemá uživatel dostatečný kredit
  nedostupne
}

///Popisuje možnosti kdy se login nepovedl
enum LoginFormErrorField {
  ///heslo nebo uživatelské jméno je neplatné
  password,

  ///url je neplatná
  url,
}

enum TypStatistiky {
  ///normální objednávky
  objednavka,

  ///automatické objednávky
  auto,

  ///objednávky chycené burzaCatherem
  burzaCatcher
}

//Dovoluje otevřít account switcher z account drawer
class SwitchAccountVisible {
  bool visible = false;
  VoidCallback? visibilityCallback; // Callback to notify changes

  // Private constructor for singleton
  SwitchAccountVisible._();

  // Singleton instance
  static final SwitchAccountVisible _instance = SwitchAccountVisible._();

  // Factory constructor to provide the singleton instance
  factory SwitchAccountVisible() => _instance;

  void setVisible(bool value) {
    visible = value;
    if (visibilityCallback != null) {
      visibilityCallback!(); // Notify changes using the callback
    }
  }

  bool isVisible() {
    return visible;
  }

  // Function to set the visibility callback
  void setVisibilityCallback(VoidCallback callback) {
    visibilityCallback = callback;
  }
}

class NotifyTheme {
  // Private constructor to prevent external instantiation
  NotifyTheme._();

  static final NotifyTheme _instance = NotifyTheme._();

  factory NotifyTheme() {
    return _instance;
  }

  ValueNotifier<ThemeMode> themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  // Method to update the theme mode and notify listeners.
  void setTheme(ThemeMode mode) {
    themeNotifier.value = mode;
  }
}

class LoginStructure {
  bool success;
  int id;
  LoginStructure(this.id, this.success);
}
