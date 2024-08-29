import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/datetime_wrapper.dart';
import 'package:autojidelna/methods_vars/snackbar_message.dart';
import 'package:autojidelna/methods_vars/widgets_tracking.dart';
import 'package:autojidelna/providers.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

late Canteen canteen;

void pressed(BuildContext context, Jidlo dish, StavJidla stavJidla) async {
  DishesOfTheDay prov = context.read<DishesOfTheDay>();
  DateTime day = convertIndexToDatetime(prov.dayIndex);
  int dishIndex = prov.menu.jidla.indexOf(dish);

  void updateJidelnicek(Jidelnicek jidelnicek) {
    Jidelnicek menu = prov.menu;
    prov.setMenu(jidelnicek);
    loggedInCanteen.canteenDataUnsafe!.jidelnicky[menu.den] = menu;
    loggedInCanteen.canteenDataUnsafe!.pocetJidel[menu.den] = menu.jidla.length;
  }

  void errorOrderingDish() {
    snackBarMessage(lang.errorsObjednavaniJidla);
    prov.setOrdering(false);
  }

  if (prov.ordering) return;
  if (!await InternetConnectionChecker().hasConnection) {
    errorOrderingDish();
    return;
  }

  prov.setOrdering(true);

  try {
    canteen = await loggedInCanteen.canteenInstance;
  } catch (e) {
    errorOrderingDish();
    return;
  }

  Jidlo jidloSafe;
  try {
    jidloSafe = (await loggedInCanteen.getLunchesForDay(day, requireNew: true)).jidla[dishIndex];
  } catch (e) {
    errorOrderingDish();
    return;
  }

  Future<Jidelnicek> retryObjednavka(Jidelnicek jidelnicek, int dishIndex, DateTime day) async {
    jidelnicek = await loggedInCanteen.getLunchesForDay(day, requireNew: true);
    return await canteen.objednat(jidelnicek.jidla[dishIndex]);
  }

  Future<Jidelnicek> retryDoBurzy(Jidelnicek jidelnicek, int dishIndex, DateTime day) async {
    jidelnicek = await loggedInCanteen.getLunchesForDay(day, requireNew: true);
    return await canteen.doBurzy(jidelnicek.jidla[dishIndex]);
  }

  Future<void> handleBurzaOrder(Burza jidloNaBurze, int dishIndex) async {
    Jidelnicek jidelnicek = await canteen.objednatZBurzy(jidloNaBurze);
    if (!jidelnicek.jidla[dishIndex].objednano) {
      jidelnicek = await retryObjednavka(jidelnicek, dishIndex, jidloNaBurze.den);
    }
    updateJidelnicek(jidelnicek);
    loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
  }

  Future<void> processNeobjednano(Jidlo jidloSafe, int dishIndex, DateTime day) async {
    Jidelnicek jidelnicek = await canteen.objednat(jidloSafe);
    if (!jidelnicek.jidla[dishIndex].objednano) {
      jidelnicek = await retryObjednavka(jidelnicek, dishIndex, day);
    }
    updateJidelnicek(jidelnicek);
    loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
  }

  Future<void> processDostupneNaBurze(Jidlo jidloSafe, int dishIndex) async {
    bool foundOnBurza = false;
    for (var jidloNaBurze in (await loggedInCanteen.canteenData).jidlaNaBurze) {
      if (jidloNaBurze.den == jidloSafe.den && jidloNaBurze.varianta == jidloSafe.varianta) {
        foundOnBurza = true;
        await handleBurzaOrder(jidloNaBurze, dishIndex);
      }
    }
    if (!foundOnBurza) {
      snackBarMessage(lang.errorsJidloNeniNaBurze);
    }
  }

  Future<void> processObjednanoNelzeOdebrat(Jidlo jidloSafe, int dishIndex, DateTime day) async {
    Jidelnicek jidelnicek = await canteen.doBurzy(jidloSafe);
    if (!jidelnicek.jidla[dishIndex].naBurze) {
      jidelnicek = await retryDoBurzy(jidelnicek, dishIndex, day);
    }
    updateJidelnicek(jidelnicek);
  }

  void processNedostupne(Jidlo jidloSafe, DateTime day) {
    if (day.isBefore(DateTime.now())) {
      snackBarMessage(lang.errorsNelzeObjednat);
      return;
    }
    if (loggedInCanteen.uzivatel!.kredit < jidloSafe.cena!) {
      snackBarMessage(lang.errorsNelzeObjednatKredit);
      return;
    }
    snackBarMessage(lang.errorsNelzeObjednat);
  }

  Future<void> processObjednano(Jidlo jidloSafe, int dishIndex, DateTime day) async {
    try {
      Jidelnicek jidelnicek = await canteen.objednat(jidloSafe);
      if (jidelnicek.jidla[dishIndex].objednano) {
        jidelnicek = await retryObjednavka(jidelnicek, dishIndex, day);
      }
      updateJidelnicek(jidelnicek);
    } catch (e) {
      snackBarMessage(lang.errorsChybaPriRuseni);
    }
  }

  Future<void> processNaBurze(Jidlo jidloSafe, int dishIndex, DateTime day) async {
    try {
      Jidelnicek jidelnicek = await canteen.doBurzy(jidloSafe);
      if (jidelnicek.jidla[dishIndex].naBurze) {
        jidelnicek = await retryDoBurzy(jidelnicek, dishIndex, day);
        updateJidelnicek(jidelnicek);
      }
    } catch (e) {
      snackBarMessage(lang.errorsChybaPriDavaniNaBurzu);
    }
  }

  try {
    switch (stavJidla) {
      case StavJidla.neobjednano:
        await processNeobjednano(jidloSafe, dishIndex, day);
        break;
      case StavJidla.dostupneNaBurze:
        await processDostupneNaBurze(jidloSafe, dishIndex);
        break;
      case StavJidla.objednanoNelzeOdebrat:
        await processObjednanoNelzeOdebrat(jidloSafe, dishIndex, day);
        break;
      case StavJidla.nedostupne:
        processNedostupne(jidloSafe, day);
        break;
      case StavJidla.objednano:
        await processObjednano(jidloSafe, dishIndex, day);
        break;
      case StavJidla.naBurze:
        await processNaBurze(jidloSafe, dishIndex, day);
        break;
      case StavJidla.objednanoVyprsenaPlatnost:
        snackBarMessage(lang.errorsObedNelzeZrusit);
        break;
    }
  } catch (e) {
    snackBarMessage(lang.errorsObjednavaniJidla);
  } finally {
    prov.setOrdering(false);
  }

  prov.setOrdering(false);
}

void cannotBeOrderedFix(BuildContext context, int dayIndex) async {
  await Future.delayed(const Duration(milliseconds: 200));
  try {
    if (!convertIndexToDatetime(dayIndex).isBefore(DateTime.now()) && context.mounted) {
      final DishesOfTheDay dishesOfTheDay = context.read<DishesOfTheDay>();
      Jidelnicek jidelnicekCheck = await loggedInCanteen.getLunchesForDay(convertIndexToDatetime(dayIndex), requireNew: true);

      for (int i = 0; i < jidelnicekCheck.jidla.length; i++) {
        if (dishesOfTheDay.menu.jidla[i].lzeObjednat != jidelnicekCheck.jidla[i].lzeObjednat) {
          dishesOfTheDay.setMenu(jidelnicekCheck);
          return;
        }
      }
    }
  } catch (e) {
    snackBarMessage(lang.errorsBadConnection);
  }
}

StavJidla getStavJidla(Jidlo dish) {
  if (dish.naBurze) {
    //pokud je od nás vloženo na burze, tak není potřeba kontrolovat nic jiného
    return StavJidla.naBurze;
  } else if (dish.objednano && dish.lzeObjednat) {
    return StavJidla.objednano;
  } else if (dish.objednano && !dish.lzeObjednat && (dish.burzaUrl == null || dish.burzaUrl!.isEmpty)) {
    //pokud nelze dát na burzu, tak už je po platnosti (nic už s tím neuděláme)
    return StavJidla.objednanoVyprsenaPlatnost;
  } else if (dish.objednano && !dish.lzeObjednat) {
    return StavJidla.objednanoNelzeOdebrat;
  } else if (!dish.objednano && dish.lzeObjednat) {
    return StavJidla.neobjednano;
  } else if (loggedInCanteen.jeJidloNaBurze(dish)) {
    return StavJidla.dostupneNaBurze;
  }
  return StavJidla.nedostupne;
}

bool isButtonEnabled(StavJidla stavJidla) {
  switch (stavJidla) {
    case StavJidla.objednano:
    case StavJidla.neobjednano:
    case StavJidla.objednanoNelzeOdebrat:
    case StavJidla.dostupneNaBurze:
    case StavJidla.naBurze:
      return false;
    default:
      return true;
  }
}

String getObedText(BuildContext context, Jidlo dish, StavJidla stavJidla) {
  Jidelnicek menu = context.select<DishesOfTheDay, Jidelnicek>((data) => data.menu);
  int dayIndex = context.select<DishesOfTheDay, int>((data) => data.dayIndex);
  DateTime datumJidla = convertIndexToDatetime(dayIndex);
  switch (stavJidla) {
    case StavJidla.objednano:
      return lang.cancel;
    case StavJidla.neobjednano:
      return lang.objednat;
    case StavJidla.objednanoVyprsenaPlatnost:
      return lang.nelzeZrusit;
    case StavJidla.objednanoNelzeOdebrat:
      return lang.vlozitNaBurzu;
    case StavJidla.dostupneNaBurze:
      return lang.objednatZBurzy;
    case StavJidla.naBurze:
      return lang.odebratZBurzy;
    case StavJidla.nedostupne:
      try {
        bool jeVeDneDostupnyObed = false;
        int prvniIndex = -1;
        for (int i = 0; i < loggedInCanteen.canteenDataUnsafe!.jidelnicky[datumJidla]!.jidla.length; i++) {
          if (loggedInCanteen.canteenDataUnsafe!.jidelnicky[datumJidla]!.jidla[i].lzeObjednat ||
              loggedInCanteen.canteenDataUnsafe!.jidelnicky[datumJidla]!.jidla[i].objednano ||
              loggedInCanteen.jeJidloNaBurze(loggedInCanteen.canteenDataUnsafe!.jidelnicky[datumJidla]!.jidla[i]) ||
              loggedInCanteen.canteenDataUnsafe!.jidelnicky[datumJidla]!.jidla[i].burzaUrl != null) {
            jeVeDneDostupnyObed = true;
            break;
          } else {
            prvniIndex = i;
          }
        }
        if (!jeVeDneDostupnyObed && prvniIndex == menu.jidla.indexOf(dish)) cannotBeOrderedFix(context, dayIndex);
      } catch (e) {
        if (analyticsEnabledGlobally && analytics != null) FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

        //hope it's not important
      }
      if (loggedInCanteen.uzivatel!.kredit < dish.cena! && !datumJidla.isBefore(DateTime.now())) {
        return lang.nedostatekKreditu;
      } else {
        return lang.nelzeObjednat;
      }
    default:
      return '';
  }
}

bool getPrimaryState(StavJidla stavJidla) {
  switch (stavJidla) {
    case StavJidla.objednano:
    case StavJidla.objednanoNelzeOdebrat:
      return true;
    default:
      return false;
  }
}
