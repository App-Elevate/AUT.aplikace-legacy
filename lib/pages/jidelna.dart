import 'package:autojidelna/main.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import './../every_import.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({
    super.key,
    required this.setHomeWidget,
  });
  final Function(Widget widget) setHomeWidget;

  @override
  State<MainAppScreen> createState() => MainAppScreenState();
}

class MainAppScreenState extends State<MainAppScreen> {
  bool loadingIndicator = false;

  Widget scaffoldBody = const SizedBox();
  PanelController panelController = PanelController();

  /// changes the scaffold body in the [MainAppScreenState]
  void setScaffoldBody(Widget widget) {
    if (!mounted) return;
    setState(() {
      scaffoldBody = widget;
    });
  }

  Future<void> portableSoftRefresh(BuildContext context) async {
    try {
      await loggedInCanteen.getLunchesForDay(dateListener.value, requireNew: true);
    } catch (e) {
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      if (context.mounted && !snackbarshown.shown) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackbarFunction('Nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu'))
            .closed
            .then((SnackBarClosedReason reason) {
          snackbarshown.shown = false;
        });
      }
    }
    setScaffoldBody(MainAppScreenState().jidelnicekWidget());
  }

  @override
  initState() {
    loggedInCanteen.readData('firstTime').then((value) {
      if (value != '1') {
        initPlatformState().then((value) async {
          await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
            if (!isAllowed) {
              // This is just a basic example. For real apps, you must show some
              // friendly dialog box before call the request method.
              // This is very important to not harm the user experience
              //
              //                    /|\
              //                     |
              //                     |
              //                     |
              //
              //              Users are fine ;)
              //
              AwesomeNotifications().requestPermissionToSendNotifications();
            }
            BackgroundFetch.start();
          });
        });
      } else {
        initPlatformState();
      }
      loggedInCanteen.saveData('firstTime', '1');
    });
    super.initState();
  }

  ///callback for SlidingUpPanel
  void _onVisibilityChanged() async {
    if (!mounted) return;
    if (SwitchAccountVisible().isVisible()) {
      panelController.open();
    } else {
      panelController.close();
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    SwitchAccountVisible().setVisibilityCallback(() {
      _onVisibilityChanged();
    });
    scaffoldBody = jidelnicekWidget();
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(16.0),
      topRight: Radius.circular(16.0),
    );
    return WillPopScope(
      onWillPop: () async {
        if (SwitchAccountVisible().isVisible()) {
          SwitchAccountVisible().setVisible(false);
          return false; // Prevents the default back button behavior
        }
        return true; // Allows the default back button behavior
      },
      child: SlidingUpPanel(
        backdropEnabled: true,
        border: Border.all(width: 0),
        borderRadius: radius,
        minHeight: 0,
        maxHeight: 300,
        controller: panelController,
        panel: Builder(
          builder: (context) {
            return SwitchAccountPanel(
              setHomeWidget: widget.setHomeWidget,
            );
          },
        ),
        body: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Autojídelna'),
            actions: [
              //refresh button
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.refresh_rounded,
                  opticalSize: 30,
                ),
                onPressed: () {
                  widget.setHomeWidget(LoggingInWidget(setHomeWidget: widget.setHomeWidget, index: pageviewController.page!.round().toInt()));
                },
              ),
            ],
          ),
          body: scaffoldBody,
          drawer: Builder(
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  //if the drawer is open close the drawer
                  if (Scaffold.of(context).isDrawerOpen) {
                    Navigator.pop(context);
                    return Future.value(false);
                  }
                  return Future.value(true);
                },
                child: MainAccountDrawer(
                  setHomeWidget: widget.setHomeWidget,
                  page: NavigationDrawerItem.jidelnicek,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  ///widget for the Jidelnicek including the date picker with all the lunches
  Builder jidelnicekWidget() {
    //bool isWeekend = dayOfWeek == 'Sobota' || dayOfWeek == 'Neděle'; //to be implemented...
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //open calendar button
                  MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 0,
                    textColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      DateTime currentDate = dateListener.value;
                      var datePicked = await showDatePicker(
                        context: context,
                        helpText: 'Vyberte datum',
                        initialDate: currentDate,
                        currentDate: DateTime.now(),
                        firstDate: minimalDate,
                        lastDate: currentDate.add(const Duration(days: 365 * 2)),
                      );
                      if (datePicked == null) return;
                      changeDate(newDate: datePicked, animateToPage: true);
                    },
                    child: const Icon(Icons.calendar_today),
                  ),

                  //Date
                  ValueListenableBuilder(
                    valueListenable: dateListener,
                    builder: (ctx, value, child) {
                      DateTime currentDate = value;
                      String dayOfWeek = loggedInCanteen.ziskatDenZData(currentDate.weekday);
                      return SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              minWidth: 0,
                              textColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                              onPressed: () {
                                changeDate(daysChange: -1);
                              },
                              child: const Icon(Icons.arrow_left),
                            ),
                            TextButton(
                              style: Theme.of(context).textButtonTheme.style?.copyWith(
                                    foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
                                  ),
                              onPressed: () async {
                                var datePicked = await showDatePicker(
                                  context: context,
                                  helpText: 'Vyberte datum',
                                  initialDate: currentDate,
                                  currentDate: DateTime.now(),
                                  firstDate: minimalDate,
                                  lastDate: currentDate.add(const Duration(days: 365 * 2)),
                                );
                                if (datePicked == null) return;
                                changeDate(newDate: datePicked, animateToPage: true);
                              },
                              child: SizedBox(
                                //relative to the width of the viewport
                                width: MediaQuery.sizeOf(context).width * 0.35,
                                child: Center(child: Text("${currentDate.day}. ${currentDate.month}. - $dayOfWeek")),
                              ),
                            ),
                            MaterialButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              minWidth: 0,
                              textColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                              onPressed: () {
                                changeDate(daysChange: 1);
                              },
                              child: const Icon(Icons.arrow_right),
                            )
                          ],
                        ),
                      );
                    },
                  ),

                  //go to today button
                  MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 0,
                    height: 27.5,
                    textColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                        width: 1.75,
                      ),
                    ),
                    child: Text(DateTime.now().day.toString()),
                    onPressed: () {
                      changeDate(newDate: DateTime.now(), animateToPage: true);
                    },
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageviewController,
                  onPageChanged: (value) {
                    changeDate(index: value);
                  },
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return jidelnicekDenWidget(
                      index,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///widget for the Jidelnicek for the day - mainly the getting lunches logic
  Builder jidelnicekDenWidget(int index) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: loggedInCanteen.getLunchesForDay(convertIndexToDatetime(index)),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                portableSoftRefresh(context);
                return RefreshIndicator(
                  onRefresh: () async {
                    await portableSoftRefresh(context);
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Symbols.sentiment_sad,
                          size: 250,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.025),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          child: Text(
                            'Nepodařilo se načíst obědy, obnovte stránku nebo to zkuste prosím později.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              Jidelnicek jidelnicek = snapshot.data as Jidelnicek;
              return ListJidel(
                portableSoftRefresh: portableSoftRefresh,
                setHomeWidget: widget.setHomeWidget,
                setScaffoldBody: setScaffoldBody,
                indexDne: index,
                jidelnicek: jidelnicek,
              );
            },
          ),
        );
      },
    );
  }
}

class ListJidel extends StatelessWidget {
  final Jidelnicek jidelnicek;
  final int indexDne;
  final Function(Widget widget) setHomeWidget;
  final Function(Widget widget) setScaffoldBody;
  final Function(BuildContext context) portableSoftRefresh;
  final ValueNotifier<Jidelnicek> jidelnicekListener = ValueNotifier<Jidelnicek>(Jidelnicek(dateListener.value, []));
  ListJidel({
    required this.portableSoftRefresh,
    required this.indexDne,
    required this.setHomeWidget,
    required this.jidelnicek,
    super.key,
    required this.setScaffoldBody,
  });

  @override
  Widget build(BuildContext context) {
    jidelnicekListener.value = jidelnicek;
    Future.delayed(const Duration(milliseconds: 50)).then((value) async {
      if (indexJidlaCoMaBytZobrazeno != null && indexJidlaCoMaBytZobrazeno == indexDne) {
        await MyApp.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => JidloDetail(
              indexDne: indexDne,
              refreshButtons: portableSoftRefresh,
              jidelnicekListener: jidelnicekListener,
              datumJidla: convertIndexToDatetime(indexDne),
              indexJidlaVeDni: indexJidlaKtereMaBytZobrazeno!,
            ),
          ),
        );
        indexJidlaCoMaBytZobrazeno = null;
        indexJidlaKtereMaBytZobrazeno = null;
      }
    });
    //second layer fix pro api returning garbage when switching orders
    try {
      if (jidelnicekListener.value.jidla.length < numberOfMaxLunches) {
        Future.delayed(const Duration(milliseconds: 300)).then((_) async {
          Jidelnicek jidelnicekNovy = (await loggedInCanteen.getLunchesForDay(dateListener.value, requireNew: true));
          if (jidelnicekListener.value.jidla.length < jidelnicekNovy.jidla.length) {
            jidelnicekListener.value = jidelnicekNovy;
          }
        });
      }
    } catch (e) {
      //We're fine if it fails. Something else will scream instead
    }
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: jidelnicekListener,
          builder: (context, value, child) {
            Future<void> softRefresh() async {
              try {
                await loggedInCanteen.getLunchesForDay(dateListener.value, requireNew: true);
              } catch (e) {
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                if (context.mounted && !snackbarshown.shown) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackbarFunction('Nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to prosím znovu'))
                      .closed
                      .then((SnackBarClosedReason reason) {
                    snackbarshown.shown = false;
                  });
                }
              }
              setScaffoldBody(MainAppScreenState().jidelnicekWidget());
            }

            if (value.jidla.isEmpty) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await softRefresh();
                  },
                  child: SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        //half of the screen height padding
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 2 - 100),
                        child: const Text('Žádná Jídla pro tento den'),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await softRefresh();
                },
                child: ListView.builder(
                  itemCount: value.jidla.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JidloDetail(
                              indexDne: indexDne,
                              refreshButtons: portableSoftRefresh,
                              jidelnicekListener: jidelnicekListener,
                              datumJidla: convertIndexToDatetime(indexDne),
                              indexJidlaVeDni: index,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        subtitle: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(builder: (_) {
                                  String jidlo = (jidelnicekListener.value.jidla[index].kategorizovano?.hlavniJidlo ??
                                              jidelnicekListener.value.jidla[index].nazev) ==
                                          ''
                                      ? jidelnicekListener.value.jidla[index].nazev
                                      : (jidelnicekListener.value.jidla[index].kategorizovano?.hlavniJidlo ??
                                          jidelnicekListener.value.jidla[index].nazev);
                                  return Text(
                                    jidlo,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  );
                                }),
                                const SizedBox(height: 16),
                                ObjednatJidloTlacitko(
                                  indexDne: indexDne,
                                  jidelnicekListener: jidelnicekListener,
                                  indexJidlaVeDni: index,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ObjednatJidloTlacitko extends StatefulWidget {
  const ObjednatJidloTlacitko({
    super.key,
    required this.indexJidlaVeDni,
    required this.jidelnicekListener,
    required this.indexDne,
  });
  final ValueNotifier<Jidelnicek> jidelnicekListener;
  final int indexDne;
  final int indexJidlaVeDni;

  @override
  State<ObjednatJidloTlacitko> createState() => _ObjednatJidloTlacitkoState();
}

class _ObjednatJidloTlacitkoState extends State<ObjednatJidloTlacitko> {
  bool ordering = false;
  Future<void> refreshButtons({int? indexJidlaKdeProbehlaZmena}) async {
    try {
      Jidelnicek jidelnicek = await loggedInCanteen.getLunchesForDay(convertIndexToDatetime(widget.indexDne), requireNew: true);
      bool probehlaZmena = false;
      if (indexJidlaKdeProbehlaZmena != null) {
        if (jidelnicek.jidla[indexJidlaKdeProbehlaZmena].objednano != widget.jidelnicekListener.value.jidla[indexJidlaKdeProbehlaZmena].objednano) {
          probehlaZmena = true;
        }
        if (jidelnicek.jidla[indexJidlaKdeProbehlaZmena].naBurze != widget.jidelnicekListener.value.jidla[indexJidlaKdeProbehlaZmena].naBurze) {
          probehlaZmena = true;
        }
      }
      while (indexJidlaKdeProbehlaZmena != null && !probehlaZmena) {
        jidelnicek = await loggedInCanteen.getLunchesForDay(convertIndexToDatetime(widget.indexDne), requireNew: true);
        await Future.delayed(const Duration(milliseconds: 200));
        if (jidelnicek.jidla[indexJidlaKdeProbehlaZmena].objednano != widget.jidelnicekListener.value.jidla[indexJidlaKdeProbehlaZmena].objednano) {
          probehlaZmena = true;
        }
        if (jidelnicek.jidla[indexJidlaKdeProbehlaZmena].naBurze != widget.jidelnicekListener.value.jidla[indexJidlaKdeProbehlaZmena].naBurze) {
          probehlaZmena = true;
        }
      }
      ordering = false;
      widget.jidelnicekListener.value = jidelnicek;
      setState(() {});
    } catch (e) {
      if (context.mounted && !snackbarshown.shown) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackbarFunction('Nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu'))
            .closed
            .then((SnackBarClosedReason reason) {
          snackbarshown.shown = false;
        });
      }
    }
  }

  Widget? icon;
  Jidlo? jidlo;
  //fix for api returning garbage when switching orders
  void cannotBeOrderedFix() async {
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
      //if get lunches for day failes we hope api gave us the right values but we still report it to firebase 😉
      if (analyticsEnabledGlobally && analytics != null) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonDisabled = true;
    Color? textColor;
    Color? buttonColor;
    late StavJidla stavJidla;
    final int index = widget.indexJidlaVeDni;
    final DateTime datumJidla = convertIndexToDatetime(widget.indexDne);
    String obedText;
    return ValueListenableBuilder(
      valueListenable: widget.jidelnicekListener,
      builder: (context, value, child) {
        jidlo = value.jidla[index];
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
            obedText = 'Zrušit ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
            break;
          case StavJidla.neobjednano:
            textColor = Theme.of(context).colorScheme.onSecondary;
            buttonColor = Theme.of(context).colorScheme.secondary;
            obedText = 'Objednat ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
            break;
          //operace v minulosti
          case StavJidla.objednanoVyprsenaPlatnost:
            obedText = 'Nelze zrušit ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
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
              if (!jeVeDneDostupnyObed && prvniIndex == index) {
                cannotBeOrderedFix();
              }
            } catch (e) {
              if (analyticsEnabledGlobally && analytics != null) {
                FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
              }
              //hope it's not important
            }
            if (loggedInCanteen.uzivatel!.kredit < jidlo!.cena! && !datumJidla.isBefore(DateTime.now())) {
              obedText = 'Nedostatek kreditu ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
            } else {
              obedText = 'Nelze objednat ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
            }
            break;
          //operace na burze
          case StavJidla.objednanoNelzeOdebrat:
            textColor = Theme.of(context).colorScheme.onPrimary;
            buttonColor = Theme.of(context).colorScheme.primary;
            obedText = 'Vložit na burzu ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
            break;
          case StavJidla.dostupneNaBurze:
            textColor = Theme.of(context).colorScheme.onSecondary;
            buttonColor = Theme.of(context).colorScheme.secondary;
            obedText = 'Objednat z burzy ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
            break;
          case StavJidla.naBurze:
            textColor = Theme.of(context).colorScheme.onSecondary;
            buttonColor = Theme.of(context).colorScheme.secondary;
            obedText = 'Odebrat z burzy ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
            break;
        }
        if (!ordering) {
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
            backgroundColor: MaterialStatePropertyAll(buttonColor),
            foregroundColor: MaterialStatePropertyAll(textColor),
          ),
          onPressed: isButtonDisabled
              ? null
              : () async {
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

                  if (ordering) {
                    return;
                  }
                  ordering = true;
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
                  late Canteen canteen;
                  try {
                    canteen = await loggedInCanteen.canteenInstance;
                  } catch (e) {
                    snackBarMessage('Nastala chyba při objednávání jídla: $e');
                    return;
                  }
                  Jidelnicek jidelnicek = await loggedInCanteen.getLunchesForDay(datumJidla, requireNew: true);
                  if (jidelnicek.jidla.length <= index) {
                    jidelnicek = await loggedInCanteen.getLunchesForDay(datumJidla, requireNew: true);
                  }
                  if (jidelnicek.jidla.length <= index) {
                    snackBarMessage('Nastala chyba při objednávání jídla: Nepodařilo získat url pro objednání. Zkuste to znovu.');
                    return;
                  }
                  Jidlo jidlo = jidelnicek.jidla[index];
                  bool hasAnythingChanged = false;
                  switch (stavJidla) {
                    case StavJidla.neobjednano:
                      {
                        try {
                          await canteen.objednat(jidlo);
                          loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
                          hasAnythingChanged = true;
                        } catch (e) {
                          snackBarMessage('Nastala chyba při objednávání jídla: $e');
                        }
                      }
                      break;
                    case StavJidla.dostupneNaBurze:
                      {
                        try {
                          String varianta = jidlo.varianta;
                          DateTime den = jidlo.den;
                          bool nalezenoJidloNaBurze = false;
                          for (var jidloNaBurze in (await loggedInCanteen.canteenData).jidlaNaBurze) {
                            if (jidloNaBurze.den == den && jidloNaBurze.varianta == varianta) {
                              try {
                                await canteen.objednatZBurzy(jidloNaBurze);
                                loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
                                hasAnythingChanged = true;
                              } catch (e) {
                                snackBarMessage('Nastala chyba při objednávání jídla z burzy: $e');
                              }
                            }
                          }
                          if (nalezenoJidloNaBurze == false) {
                            snackBarMessage('Nepodařilo se najít jídlo na burze, někdo vám ho pravděpodobně vyfouknul před nosem');
                          }
                        } catch (e) {
                          snackBarMessage('Nastala chyba při objednávání jídla z burzy: $e');
                        }
                      }
                      break;
                    case StavJidla.objednanoVyprsenaPlatnost:
                      {
                        snackBarMessage('Oběd nelze zrušit. Platnost objednávky vypršela. (pravděpodobně je toto oběd z minulosti)');
                      }
                      break;
                    case StavJidla.objednanoNelzeOdebrat:
                      {
                        try {
                          await canteen.doBurzy(jidlo);
                          hasAnythingChanged = true;
                        } catch (e) {
                          snackBarMessage('Nastala chyba při dávání jídla na burzu: $e');
                        }
                      }
                      break;
                    case StavJidla.nedostupne:
                      {
                        if (datumJidla.isBefore(DateTime.now())) {
                          snackBarMessage('Oběd nelze objednat. (pravděpodobně je toto oběd z minulosti)');
                          break;
                        }
                        try {
                          if (loggedInCanteen.uzivatel!.kredit < jidlo.cena!) {
                            snackBarMessage('Oběd nelze objednat - Nedostatečný kredit');
                            break;
                          }
                        } catch (e) {
                          //pokud se nepodaří načíst kredit, tak to necháme být
                        }
                        snackBarMessage('Oběd nelze objednat. (pravděpodobně je toto oběd z minulosti nebo aktuálně není na burze)');
                      }
                      break;
                    case StavJidla.objednano:
                      {
                        try {
                          await canteen.objednat(jidlo);
                          hasAnythingChanged = true;
                        } catch (e) {
                          snackBarMessage('Nastala chyba při rušení objednávky: $e');
                        }
                      }
                      break;
                    case StavJidla.naBurze:
                      {
                        try {
                          await canteen.doBurzy(jidlo);
                          hasAnythingChanged = true;
                        } catch (e) {
                          snackBarMessage('Nastala chyba při dávání jídla na burzu: $e');
                        }
                      }
                      break;
                  }
                  refreshButtons(indexJidlaKdeProbehlaZmena: hasAnythingChanged ? index : null);
                  if (context.mounted) {
                    setState(() {
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
