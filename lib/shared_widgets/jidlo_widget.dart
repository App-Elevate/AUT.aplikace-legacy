import 'package:autojidelna/local_imports.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:localization/localization.dart';

class JidloWidget extends StatelessWidget {
  const JidloWidget({
    super.key,
    required this.indexDne,
    required this.portableSoftRefresh,
    required this.jidelnicekListener,
    required this.index,
    required this.ordering,
  });

  final ValueNotifier<bool> ordering;

  final int index;
  final int indexDne;
  final Function(BuildContext context) portableSoftRefresh;
  final ValueNotifier<Jidelnicek> jidelnicekListener;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JidloDetail(
              ordering: ordering,
              indexDne: indexDne,
              refreshButtons: portableSoftRefresh,
              jidelnicekListener: jidelnicekListener,
              datumJidla: convertIndexToDatetime(indexDne),
              indexJidlaVeDni: index,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.05, vertical: MediaQuery.sizeOf(context).height * 0.01),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (_) {
                String jidlo =
                    (jidelnicekListener.value.jidla[index].kategorizovano?.hlavniJidlo ?? jidelnicekListener.value.jidla[index].nazev) == ''
                        ? jidelnicekListener.value.jidla[index].nazev
                        : (jidelnicekListener.value.jidla[index].kategorizovano?.hlavniJidlo ?? jidelnicekListener.value.jidla[index].nazev);
                return Text(
                  jidlo,
                  style: Theme.of(context).textTheme.titleLarge,
                );
              }),
              const SizedBox(height: 16),
              ObjednatJidloTlacitko(
                ordering: ordering,
                indexDne: indexDne,
                jidelnicekListener: jidelnicekListener,
                indexJidlaVeDni: index,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ObjednatJidloTlacitko extends StatefulWidget {
  const ObjednatJidloTlacitko({
    super.key,
    required this.indexJidlaVeDni,
    required this.jidelnicekListener,
    required this.indexDne,
    required this.ordering,
  });
  final ValueNotifier<Jidelnicek> jidelnicekListener;
  final int indexDne;
  final int indexJidlaVeDni;
  final ValueNotifier<bool> ordering;

  @override
  State<ObjednatJidloTlacitko> createState() => _ObjednatJidloTlacitkoState();
}

class _ObjednatJidloTlacitkoState extends State<ObjednatJidloTlacitko> {
  Widget? icon;
  Jidlo? jidlo;
  Jidelnicek? lastJidelnicek;
  //fix for api returning garbage when switching orders
  void cannotBeOrderedFix() async {
    void snackBarMessage(String message) {
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      // toto je upozornění dole (Snackbar)
      // snackbarshown je aby se snackbar nezobrazil vícekrát
      if (context.mounted && snackbarshown.shown == false) {
        snackbarshown.shown = true;
        ScaffoldMessenger.of(context).showSnackBar(snackbarFunction(message)).closed.then(
          (SnackBarClosedReason reason) {
            snackbarshown.shown = false;
          },
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 200));
    try {
      if (!convertIndexToDatetime(widget.indexDne).isBefore(DateTime.now())) {
        Jidelnicek jidelnicekCheck = await loggedInCanteen.getLunchesForDay(convertIndexToDatetime(widget.indexDne), requireNew: true);
        for (int i = 0; i < jidelnicekCheck.jidla.length; i++) {
          if (widget.jidelnicekListener.value.jidla[i].lzeObjednat != jidelnicekCheck.jidla[i].lzeObjednat) {
            widget.jidelnicekListener.value = jidelnicekCheck;
            return;
          }
        }
      }
    } catch (e) {
      snackBarMessage(Texts.errorsBadConnection.i18n());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonDisabled = true;
    Color? textColor;
    Color? buttonColor;
    late StavJidla stavJidla;
    final int indexJidlaVeDni = widget.indexJidlaVeDni;
    final DateTime datumJidla = convertIndexToDatetime(widget.indexDne);
    String obedText;
    return ValueListenableBuilder(
      valueListenable: widget.jidelnicekListener,
      builder: (context, value, child) {
        jidlo = value.jidla[indexJidlaVeDni];
        if (jidlo!.naBurze) {
          //pokud je od nás vloženo na burze, tak není potřeba kontrolovat nic jiného
          stavJidla = StavJidla.naBurze;
        } else if (jidlo!.objednano && jidlo!.lzeObjednat) {
          stavJidla = StavJidla.objednano;
        } else if (jidlo!.objednano && !jidlo!.lzeObjednat && (jidlo!.burzaUrl == null || jidlo!.burzaUrl!.isEmpty)) {
          //pokud nelze dát na burzu, tak už je po platnosti (nic už s tím neuděláme)
          stavJidla = StavJidla.objednanoVyprsenaPlatnost;
        } else if (jidlo!.objednano && !jidlo!.lzeObjednat) {
          stavJidla = StavJidla.objednanoNelzeOdebrat;
        } else if (!jidlo!.objednano && jidlo!.lzeObjednat) {
          stavJidla = StavJidla.neobjednano;
        } else if (loggedInCanteen.jeJidloNaBurze(jidlo!)) {
          stavJidla = StavJidla.dostupneNaBurze;
        } else if (!jidlo!.objednano && !jidlo!.lzeObjednat) {
          stavJidla = StavJidla.nedostupne;
        }
        switch (stavJidla) {
          //jednoduché operace
          case StavJidla.objednano:
            textColor = Theme.of(context).colorScheme.onPrimary;
            buttonColor = Theme.of(context).colorScheme.primary;
            obedText = Texts.obedTextZrusit.i18n([jidlo!.varianta, jidlo!.cena!.toInt().toString()]);
            break;
          case StavJidla.neobjednano:
            textColor = Theme.of(context).colorScheme.onSecondary;
            buttonColor = Theme.of(context).colorScheme.secondary;
            obedText = Texts.obedTextObjednat.i18n([jidlo!.varianta, jidlo!.cena!.toInt().toString()]);
            break;
          //operace v minulosti
          case StavJidla.objednanoVyprsenaPlatnost:
            obedText = Texts.obedTextNelzeZrusit.i18n([jidlo!.varianta, jidlo!.cena!.toInt().toString()]);
            break;
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
              if (!jeVeDneDostupnyObed && prvniIndex == indexJidlaVeDni) {
                cannotBeOrderedFix();
              }
            } catch (e) {
              if (analyticsEnabledGlobally && analytics != null) {
                FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
              }
              //hope it's not important
            }
            if (loggedInCanteen.uzivatel!.kredit < jidlo!.cena! && !datumJidla.isBefore(DateTime.now())) {
              obedText = Texts.obedTextNedostatekKreditu.i18n([jidlo!.varianta, jidlo!.cena!.toInt().toString()]);
            } else {
              obedText = Texts.obedTextNelzeObjednat.i18n([jidlo!.varianta, jidlo!.cena!.toInt().toString()]);
            }
            break;
          //operace na burze
          case StavJidla.objednanoNelzeOdebrat:
            textColor = Theme.of(context).colorScheme.onPrimary;
            buttonColor = Theme.of(context).colorScheme.primary;
            obedText = Texts.obedTextVlozitNaBurzu.i18n([jidlo!.varianta, jidlo!.cena!.toInt().toString()]);
            break;
          case StavJidla.dostupneNaBurze:
            textColor = Theme.of(context).colorScheme.onSecondary;
            buttonColor = Theme.of(context).colorScheme.secondary;
            obedText = Texts.obedTextObjednatZBurzy.i18n([jidlo!.varianta, jidlo!.cena!.toInt().toString()]);
            break;
          case StavJidla.naBurze:
            textColor = Theme.of(context).colorScheme.onSecondary;
            buttonColor = Theme.of(context).colorScheme.secondary;
            obedText = Texts.obedTextOdebratZBurzy.i18n([jidlo!.varianta, jidlo!.cena!.toInt().toString()]);
            break;
        }
        if (!widget.ordering.value) {
          switch (stavJidla) {
            case StavJidla.objednano:
              icon = const Icon(Icons.check);
              isButtonDisabled = false;
              break;
            case StavJidla.neobjednano:
              isButtonDisabled = false;
              icon = null;
              break;
            //operace v minulosti
            case StavJidla.objednanoVyprsenaPlatnost:
              icon = const Icon(Icons.block);
              break;
            case StavJidla.nedostupne:
              icon = const Icon(Icons.block);
              break;
            //operace na burze
            case StavJidla.objednanoNelzeOdebrat:
              icon = const Icon(Icons.shopping_bag);
              isButtonDisabled = false;
              break;
            case StavJidla.dostupneNaBurze:
              icon = const Icon(Icons.shopping_bag);
              isButtonDisabled = false;
              break;
            case StavJidla.naBurze:
              icon = const Icon(Icons.shopping_bag); //market icon
              isButtonDisabled = false;
              break;
          }
        }

        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(buttonColor),
            foregroundColor: WidgetStatePropertyAll(textColor),
          ),
          onPressed: isButtonDisabled || widget.ordering.value
              ? null
              : () async {
                  void updateJidelnicek(Jidelnicek jidelnicek) {
                    widget.jidelnicekListener.value = jidelnicek;
                    loggedInCanteen.canteenDataUnsafe!.jidelnicky[widget.jidelnicekListener.value.den] = widget.jidelnicekListener.value;
                    loggedInCanteen.canteenDataUnsafe!.pocetJidel[widget.jidelnicekListener.value.den] = widget.jidelnicekListener.value.jidla.length;
                  }

                  void snackBarMessage(String message) {
                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    // toto je upozornění dole (Snackbar)
                    // snackbarshown je aby se snackbar nezobrazil vícekrát
                    if (context.mounted && snackbarshown.shown == false) {
                      snackbarshown.shown = true;
                      ScaffoldMessenger.of(context).showSnackBar(snackbarFunction(message)).closed.then(
                        (SnackBarClosedReason reason) {
                          snackbarshown.shown = false;
                        },
                      );
                    }
                    if (context.mounted) {
                      setState(() {
                        widget.ordering.value = false;
                        icon = null;
                      });
                    }
                  }

                  if (widget.ordering.value) return;
                  if (!await InternetConnectionChecker().hasConnection) {
                    snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
                    return;
                  }

                  widget.ordering.value = true;
                  setState(() {
                    icon = SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    );
                  });
                  Canteen canteen;
                  try {
                    canteen = await loggedInCanteen.canteenInstance;
                  } catch (e) {
                    snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
                    return;
                  }
                  Jidlo jidloSafe;
                  try {
                    jidloSafe = (await loggedInCanteen.getLunchesForDay(datumJidla, requireNew: true)).jidla[indexJidlaVeDni];
                  } catch (e) {
                    snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
                    if (context.mounted) {
                      setState(() {
                        widget.ordering.value = false;
                        icon = null;
                      });
                    }
                    return;
                  }
                  switch (stavJidla) {
                    case StavJidla.neobjednano:
                      {
                        try {
                          Jidelnicek jidelnicek = await canteen.objednat(jidloSafe);
                          if (jidelnicek.jidla[indexJidlaVeDni].objednano == false) {
                            jidelnicek = await loggedInCanteen.getLunchesForDay(datumJidla, requireNew: true);
                            jidelnicek = await canteen.objednat(jidelnicek.jidla[indexJidlaVeDni]);
                          }
                          updateJidelnicek(jidelnicek);
                          loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
                        } catch (e) {
                          snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
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
                                if (jidelnicek.jidla[indexJidlaVeDni].objednano == false) {
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
                                snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
                              }
                            }
                          }
                          if (nalezenoJidloNaBurze == false) {
                            snackBarMessage(Texts.errorsJidloNeniNaBurze.i18n());
                          }
                        } catch (e) {
                          snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
                        }
                      }
                      break;
                    case StavJidla.objednanoVyprsenaPlatnost:
                      {
                        snackBarMessage(Texts.errorsObedNelzeZrusit.i18n());
                      }
                      break;
                    case StavJidla.objednanoNelzeOdebrat:
                      {
                        try {
                          Jidelnicek jidelnicek = await canteen.doBurzy(jidloSafe);
                          if (jidelnicek.jidla[indexJidlaVeDni].naBurze == false) {
                            jidelnicek = await loggedInCanteen.getLunchesForDay(datumJidla, requireNew: true);
                            jidelnicek = await canteen.doBurzy(jidelnicek.jidla[indexJidlaVeDni]);
                          }
                          updateJidelnicek(jidelnicek);
                        } catch (e) {
                          snackBarMessage(Texts.errorsObjednavaniJidla.i18n());
                        }
                      }
                      break;
                    case StavJidla.nedostupne:
                      {
                        if (datumJidla.isBefore(DateTime.now())) {
                          snackBarMessage(Texts.errorsNelzeObjednat.i18n());
                          break;
                        }
                        try {
                          if (loggedInCanteen.uzivatel!.kredit < jidloSafe.cena!) {
                            snackBarMessage(Texts.errorsNelzeObjednatKredit.i18n());
                            break;
                          }
                        } catch (e) {
                          //pokud se nepodaří načíst kredit, tak to necháme být
                        }
                        snackBarMessage(Texts.errorsNelzeObjednat.i18n());
                      }
                      break;
                    case StavJidla.objednano:
                      {
                        try {
                          Jidelnicek jidelnicek = await canteen.objednat(jidloSafe);
                          if (jidelnicek.jidla[indexJidlaVeDni].objednano == true) {
                            jidelnicek = await loggedInCanteen.getLunchesForDay(datumJidla, requireNew: true);
                            jidelnicek = await canteen.objednat(jidelnicek.jidla[indexJidlaVeDni]);
                          }
                          updateJidelnicek(jidelnicek);
                        } catch (e) {
                          snackBarMessage(Texts.errorsChybaPriRuseni.i18n());
                        }
                      }
                      break;
                    case StavJidla.naBurze:
                      {
                        try {
                          Jidelnicek jidelnicek = await canteen.doBurzy(jidloSafe);
                          if (jidelnicek.jidla[indexJidlaVeDni].naBurze == true) {
                            jidelnicek = await loggedInCanteen.getLunchesForDay(datumJidla, requireNew: true);
                            jidelnicek = await canteen.doBurzy(jidelnicek.jidla[indexJidlaVeDni]);
                          }
                          updateJidelnicek(jidelnicek);
                        } catch (e) {
                          snackBarMessage(Texts.errorsChybaPriDavaniNaBurzu.i18n());
                        }
                      }
                      break;
                  }
                  if (context.mounted) {
                    setState(() {
                      widget.ordering.value = false;
                      icon = null;
                    });
                  }
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Text(obedText),
                  ),
                ),
              ),
              icon == null ? const Icon(null) : icon!,
            ],
          ),
        );
      },
    );
  }
}
