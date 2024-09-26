// Všechny objekty a enumy, které se používají v aplikaci
import 'dart:async';

import 'package:canteenlib/canteenlib.dart';

enum ConnectionErrors {
  /// user is not logged in (no username and password in secure storage)
  noLogin,

  /// user has entered the wrong password/username
  badLogin,

  /// user has entered the wrong url
  wrongUrl,

  /// connection to the canteen server failed
  connectionFailed,

  /// user is not connected to the internet
  noInternet,
}

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

  // Override == to compare properties
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoggedInUser && other.username == username && other.password == password && other.url == url;
  }

  // Override hashCode to generate a consistent hash code based on properties
  @override
  int get hashCode => username.hashCode ^ password.hashCode ^ url.hashCode;
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

  Map<int, String>? vydejny;

  CanteenData(
      {required this.username,
      required this.url,
      required this.uzivatel,
      required this.jidlaNaBurze,
      this.id = 0,
      required this.currentlyLoading,
      required this.jidelnicky,
      required this.pocetJidel,
      this.vydejny});
  CanteenData copyWith() {
    return CanteenData(
        username: username,
        url: url,
        uzivatel: uzivatel,
        jidlaNaBurze: jidlaNaBurze,
        currentlyLoading: currentlyLoading,
        jidelnicky: jidelnicky,
        pocetJidel: pocetJidel,
        vydejny: vydejny);
  }
}

///class pro general access o stavu snackbaru
class SnackBarShown {
  SnackBarShown({required this.shown});
  bool shown = false;
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

/// Describes what colors will be used by the app
enum ThemeStyle {
  defaultStyle,
  plumBrown,
  blueMauve,
  rustOlive,
  evergreenSlate,
  crimsonEarth,
}

/// Describes what time format will be used by the app
enum DateFormatOptions {
  dMy,
  mmddyy,
  ddmmyy,
  yyyymmdd,
  ddmmmyyyy,
  mmmddyyyy,
}

/// Class containing all fonts used by the apps
class Fonts {
  static String get body => 'Inter';
  static String get headings => 'Lexend';
}

enum TabletUi {
  auto,
  always,
  landscape,
  never,
}
