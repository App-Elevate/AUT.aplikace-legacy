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
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

late Canteen canteen;

void pressed(BuildContext context, Jidlo dish, StavJidla stavJidla) async {
  final prov = context.read<DishesOfTheDay>();
  Ordering ordering = context.read<Ordering>();

  DateTime day = dish.den;
  int dayIndex = convertDateTimeToIndex(day);
  int dishIndex = prov.getMenu(dayIndex)!.jidla.indexOf(dish);

  void updateJidelnicek(Jidelnicek jidelnicek) {
    Jidelnicek menu = prov.getMenu(dayIndex)!;
    prov.setMenu(dayIndex, jidelnicek);
    prov.setNumberOfDishes(dayIndex, menu.jidla.length);
  }

  if (ordering.ordering) return;
  if (!await InternetConnection().hasInternetAccess) {
    snackBarMessage(lang.errorsObjednavaniJidla);
    return;
  }

  ordering.ordering = true;
  try {
    canteen = await loggedInCanteen.canteenInstance;
  } catch (e) {
    snackBarMessage(lang.errorsObjednavaniJidla);
    return;
  }

  Jidlo jidloSafe;
  try {
    jidloSafe = (await loggedInCanteen.getLunchesForDay(day, requireNew: true)).jidla[dishIndex];
  } catch (e) {
    snackBarMessage(lang.errorsObjednavaniJidla);
    if (context.mounted) ordering.ordering = false;

    return;
  }

  switch (stavJidla) {
    case StavJidla.neobjednano:
      {
        try {
          Jidelnicek jidelnicek = await canteen.objednat(jidloSafe);
          if (jidelnicek.jidla[dishIndex].objednano == false) {
            jidelnicek = await loggedInCanteen.getLunchesForDay(day, requireNew: true);
            jidelnicek = await canteen.objednat(jidelnicek.jidla[dishIndex]);
          }
          updateJidelnicek(jidelnicek);
          loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
        } catch (e) {
          snackBarMessage(lang.errorsObjednavaniJidla);
        }
      }
      break;
    case StavJidla.dostupneNaBurze:
      {
        try {
          String varianta = jidloSafe.varianta;
          DateTime den = jidloSafe.den;
          bool nalezenoJidloNaBurze = false;
          for (var jidloNaBurze in (await loggedInCanteen.canteenData).jidlaNaBurze) {
            if (jidloNaBurze.den == den && jidloNaBurze.varianta == varianta) {
              try {
                // first try
                Jidelnicek jidelnicek = await canteen.objednatZBurzy(jidloNaBurze);
                if (jidelnicek.jidla[dishIndex].objednano == false) {
                  List<Burza> burza = await canteen.ziskatBurzu();
                  for (var jidloNaBurze in burza) {
                    if (jidloNaBurze.den == den && jidloNaBurze.varianta == varianta) {
                      // second try
                      jidelnicek = await canteen.objednatZBurzy(jidloNaBurze);
                    }
                  }
                }
                updateJidelnicek(jidelnicek);
                loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
              } catch (e) {
                snackBarMessage(lang.errorsObjednavaniJidla);
              }
            }
          }
          if (nalezenoJidloNaBurze == false) {
            snackBarMessage(lang.errorsJidloNeniNaBurze);
          }
        } catch (e) {
          snackBarMessage(lang.errorsObjednavaniJidla);
        }
      }
      break;
    case StavJidla.objednanoVyprsenaPlatnost:
      {
        snackBarMessage(lang.errorsObedNelzeZrusit);
      }
      break;
    case StavJidla.objednanoNelzeOdebrat:
      {
        try {
          Jidelnicek jidelnicek = await canteen.doBurzy(jidloSafe);
          if (jidelnicek.jidla[dishIndex].naBurze == false) {
            jidelnicek = await loggedInCanteen.getLunchesForDay(day, requireNew: true);
            jidelnicek = await canteen.doBurzy(jidelnicek.jidla[dishIndex]);
          }
          updateJidelnicek(jidelnicek);
        } catch (e) {
          snackBarMessage(lang.errorsObjednavaniJidla);
        }
      }
      break;
    case StavJidla.nedostupne:
      {
        if (day.isBefore(DateTime.now())) {
          snackBarMessage(lang.errorsNelzeObjednat);
          break;
        }
        try {
          if (loggedInCanteen.uzivatel!.kredit < jidloSafe.cena!) {
            snackBarMessage(lang.errorsNelzeObjednatKredit);
            break;
          }
        } catch (e) {
          //pokud se nepodaří načíst kredit, tak to necháme být
        }
        snackBarMessage(lang.errorsNelzeObjednat);
      }
      break;
    case StavJidla.objednano:
      {
        try {
          Jidelnicek jidelnicek = await canteen.objednat(jidloSafe);
          if (jidelnicek.jidla[dishIndex].objednano == true) {
            jidelnicek = await loggedInCanteen.getLunchesForDay(day, requireNew: true);
            jidelnicek = await canteen.objednat(jidelnicek.jidla[dishIndex]);
          }
          updateJidelnicek(jidelnicek);
        } catch (e) {
          snackBarMessage(lang.errorsChybaPriRuseni);
        }
      }
      break;
    case StavJidla.naBurze:
      {
        try {
          Jidelnicek jidelnicek = await canteen.doBurzy(jidloSafe);
          if (jidelnicek.jidla[dishIndex].naBurze == true) {
            jidelnicek = await loggedInCanteen.getLunchesForDay(day, requireNew: true);
            jidelnicek = await canteen.doBurzy(jidelnicek.jidla[dishIndex]);
          }
          updateJidelnicek(jidelnicek);
        } catch (e) {
          snackBarMessage(lang.errorsChybaPriDavaniNaBurzu);
        }
      }
      break;
  }
  if (context.mounted) ordering.ordering = false;
}

void cannotBeOrderedFix(BuildContext context, int dayIndex) async {
  await Future.delayed(const Duration(milliseconds: 200));
  try {
    if (!convertIndexToDatetime(dayIndex).isBefore(DateTime.now()) && context.mounted) {
      final DishesOfTheDay dishesOfTheDay = context.read<DishesOfTheDay>();
      Jidelnicek jidelnicekCheck = await loggedInCanteen.getLunchesForDay(convertIndexToDatetime(dayIndex), requireNew: true);

      for (int i = 0; i < jidelnicekCheck.jidla.length; i++) {
        if (dishesOfTheDay.getMenu(dayIndex)!.jidla[i].lzeObjednat != jidelnicekCheck.jidla[i].lzeObjednat) {
          dishesOfTheDay.setMenu(dayIndex, jidelnicekCheck);
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
    case StavJidla.dostupneNaBurze:
    case StavJidla.naBurze:
    case StavJidla.neobjednano:
    case StavJidla.objednano:
    case StavJidla.objednanoNelzeOdebrat:
      return true;
    default:
      return false;
  }
}

String getObedText(BuildContext context, Jidlo dish, StavJidla stavJidla) {
  int dayIndex = convertDateTimeToIndex(dish.den);
  Jidelnicek menu = context.select<DishesOfTheDay, Jidelnicek>((data) => data.getMenu(dayIndex)!);
  DateTime day = convertIndexToDatetime(dayIndex);
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

        for (int i = 0; i < menu.jidla.length; i++) {
          if (menu.jidla[i].lzeObjednat ||
              menu.jidla[i].objednano ||
              loggedInCanteen.jeJidloNaBurze(menu.jidla[i]) ||
              menu.jidla[i].burzaUrl != null) {
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
      if (loggedInCanteen.uzivatel!.kredit < dish.cena! && !day.isBefore(DateTime.now())) {
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
    case StavJidla.objednanoVyprsenaPlatnost:
      return true;
    default:
      return false;
  }
}
