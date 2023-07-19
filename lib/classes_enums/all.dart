import './../every_import.dart';

///enum pro výběr stránky v navigačním menu
enum NavigationDrawerItem { jidelnicek, automatickeObjednavky, burzaCatcher }

///Třída pro kešování dat Canteeny
class CanteenData {
  /// login uživatele
  String username;

  /// url kantýny
  String url;

  /// info o uživateli - např kredit,jméno,příjmení...
  Uzivatel uzivatel;

  /// seznam jídelníčků začínající Od Pondělí tohoto týdne
  Map<DateTime, Jidelnicek> jidelnicky;

  /// seznam jídel, které jsou na burze
  List<Burza> jidlaNaBurze;
  CanteenData({
    required this.username,
    required this.url,
    required this.uzivatel,
    required this.jidelnicky,
    required this.jidlaNaBurze,
  });
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

  /// jídlo nemáme objednané a není dostupné na burze nebo vypršela platnost
  nedostupne
}

///Popisuje možnosti kdy se login nepovedl
enum LoginFormErrorField {
  ///heslo nebo uživatelské jméno je neplatné
  password,

  ///url je neplatná
  url,
}