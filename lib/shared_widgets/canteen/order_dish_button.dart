import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/consts.dart';
import 'package:autojidelna/main.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/datetime_wrapper.dart';
import 'package:autojidelna/methods_vars/widgets_tracking.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/snackbar.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class OrderDishButton extends StatelessWidget {
  const OrderDishButton(this.dish, {super.key});
  final Jidlo dish;

  @override
  Widget build(BuildContext context) {
    bool ordering = context.select<DishesOfTheDay, bool>((data) => data.ordering);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    StavJidla stavJidla = _getStavJidla();
    bool isPrimary = _getPrimaryState(stavJidla);
    bool disabled = !ordering ? _isButtonEnabled(stavJidla) : true;

    return Selector<DishesOfTheDay, Jidelnicek>(
      selector: (_, p1) => p1.menu,
      builder: (context, menu, child) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isPrimary ? colorScheme.primary : colorScheme.secondary,
              foregroundColor: isPrimary ? colorScheme.onPrimary : colorScheme.onSecondary,
            ),
            onPressed: ordering || disabled ? null : () => pressed(context, stavJidla),
            child: Text(_getObedText(context, stavJidla)),
          ),
        );
      },
    );
  }

  void snackBarMessage(String message) {
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    // toto je upozornění dole (Snackbar)
    // snackbarshown je aby se snackbar nezobrazil vícekrát
    BuildContext? ctx = MyApp.navigatorKey.currentContext;
    if (ctx != null && snackbarshown.shown == false) {
      snackbarshown.shown = true;
      ScaffoldMessenger.of(ctx).showSnackBar(snackbarFunction(message)).closed.then(
        (SnackBarClosedReason reason) {
          snackbarshown.shown = false;
        },
      );
    }
  }

  void _cannotBeOrderedFix(BuildContext context, int dayIndex) async {
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
      snackBarMessage(Texts.errorsBadConnection.i18n());
    }
  }

  StavJidla _getStavJidla() {
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

  bool _isButtonEnabled(StavJidla stavJidla) {
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

  String _getObedText(BuildContext context, StavJidla stavJidla) {
    Jidelnicek menu = context.select<DishesOfTheDay, Jidelnicek>((data) => data.menu);
    int dayIndex = context.select<DishesOfTheDay, int>((data) => data.dayIndex);
    DateTime datumJidla = convertIndexToDatetime(dayIndex);
    switch (stavJidla) {
      case StavJidla.objednano:
        return Texts.obedTextZrusit.i18n();
      case StavJidla.neobjednano:
        return Texts.obedTextObjednat.i18n();
      case StavJidla.objednanoVyprsenaPlatnost:
        return Texts.obedTextNelzeZrusit.i18n();
      case StavJidla.objednanoNelzeOdebrat:
        return Texts.obedTextVlozitNaBurzu.i18n();
      case StavJidla.dostupneNaBurze:
        return Texts.obedTextObjednatZBurzy.i18n();
      case StavJidla.naBurze:
        return Texts.obedTextOdebratZBurzy.i18n();
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
          if (!jeVeDneDostupnyObed && prvniIndex == menu.jidla.indexOf(dish)) _cannotBeOrderedFix(context, dayIndex);
        } catch (e) {
          if (analyticsEnabledGlobally && analytics != null) FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

          //hope it's not important
        }
        if (loggedInCanteen.uzivatel!.kredit < dish.cena! && !datumJidla.isBefore(DateTime.now())) {
          return Texts.obedTextNedostatekKreditu.i18n();
        } else {
          return Texts.obedTextNelzeObjednat.i18n();
        }
      default:
        return '';
    }
  }

  bool _getPrimaryState(StavJidla stavJidla) {
    switch (stavJidla) {
      case StavJidla.objednano:
      case StavJidla.objednanoNelzeOdebrat:
        return true;
      default:
        return false;
    }
  }

  void pressed(BuildContext context, StavJidla stavJidla) async {
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
      snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
      prov.setOrdering(false);
    }

    if (prov.ordering) return;
    if (!await InternetConnectionChecker().hasConnection) {
      errorOrderingDish();
      return;
    }

    prov.setOrdering(true);

    Canteen canteen;
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
        snackBarMessage(Texts.errorsJidloNeniNaBurze.i18n());
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
        snackBarMessage(Texts.errorsNelzeObjednat.i18n());
        return;
      }
      if (loggedInCanteen.uzivatel!.kredit < jidloSafe.cena!) {
        snackBarMessage(Texts.errorsNelzeObjednatKredit.i18n());
        return;
      }
      snackBarMessage(Texts.errorsNelzeObjednat.i18n());
    }

    Future<void> processObjednano(Jidlo jidloSafe, int dishIndex, DateTime day) async {
      try {
        Jidelnicek jidelnicek = await canteen.objednat(jidloSafe);
        if (jidelnicek.jidla[dishIndex].objednano) {
          jidelnicek = await retryObjednavka(jidelnicek, dishIndex, day);
        }
        updateJidelnicek(jidelnicek);
      } catch (e) {
        snackBarMessage(Texts.errorsChybaPriRuseni.i18n());
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
        snackBarMessage(Texts.errorsChybaPriDavaniNaBurzu.i18n());
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
          snackBarMessage(Texts.errorsObedNelzeZrusit.i18n());
          break;
      }
    } catch (e) {
      snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
    } finally {
      prov.setOrdering(false);
    }

    prov.setOrdering(false);
  }
}
