import 'package:background_fetch/background_fetch.dart';

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
              AwesomeNotifications().requestPermissionToSendNotifications();
            }
            BackgroundFetch.start();
          });
        });
      }
      loggedInCanteen.saveData('firstTime', '1');
    });
    super.initState();
  }

  ///reloads the page
  Future<void> reload() async {
    if (loadingIndicator) return;
    setState(() {
      loadingIndicator = true;
    });
    try {
      await loggedInCanteen.refreshLunches(minimalDate.add(Duration(days: pageviewController.page!.round())));
    } catch (e) {
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      if (context.mounted && !snackbarshown.shown) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackbarFunction('nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu'))
            .closed
            .then((SnackBarClosedReason reason) {
          snackbarshown.shown = false;
        });
      }
    }
    setState(() {
      loadingIndicator = false;
    });
    setScaffoldBody(jidelnicekWidget());
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
              //calendar button
              IconButton(
                onPressed: () {
                  changeDate(newDate: DateTime.now(), animateToPage: true);
                },
                icon: const Icon(Icons.calendar_today_rounded),
              ),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.refresh_rounded,
                  opticalSize: 30,
                ),
                onPressed: () {
                  reload();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              scaffoldBody,
              if (loadingIndicator)
                Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
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
  Padding jidelnicekWidget() {
    //bool isWeekend = dayOfWeek == 'Sobota' || dayOfWeek == 'Neděle'; //to be implemented...
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
      child: Column(
        children: [
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
                    IconButton(
                      onPressed: () {
                        changeDate(daysChange: -1);
                      },
                      icon: const Icon(Icons.arrow_left),
                    ),
                    TextButton(
                      style: const ButtonStyle(
                        overlayColor: MaterialStatePropertyAll(Colors.transparent),
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
                        changeDate(newDate: datePicked);
                      },
                      child: SizedBox(
                        //relative to the width of the viewport
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Center(child: Text("${currentDate.day}. ${currentDate.month}. ${currentDate.year} - $dayOfWeek")),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        changeDate(daysChange: 1);
                      },
                      icon: const Icon(Icons.arrow_right),
                    )
                  ],
                ),
              );
            },
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

  ///widget for the Jidelnicek for the day - mainly the getting lunches logic
  SizedBox jidelnicekDenWidget(int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: loggedInCanteen.getLunchesForDay(minimalDate.add(Duration(days: index))),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            portableSoftRefresh(context);
            return RefreshIndicator(
                onRefresh: () async {
                  await portableSoftRefresh(context);
                },
                child: const Center(child: Text('nepodařilo se načíst obědy zkuste znovu načíst stránku')));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Jidelnicek jidelnicek = snapshot.data as Jidelnicek;
          return ListJidel(
            setHomeWidget: widget.setHomeWidget,
            setScaffoldBody: setScaffoldBody,
            indexDne: index,
            jidelnicek: jidelnicek,
          );
        },
      ),
    );
  }
}

class ListJidel extends StatelessWidget {
  final Jidelnicek jidelnicek;
  final int indexDne;
  final Function(Widget widget) setHomeWidget;
  final Function(Widget widget) setScaffoldBody;
  final ValueNotifier<Jidelnicek> jidelnicekListener = ValueNotifier<Jidelnicek>(Jidelnicek(dateListener.value, []));
  ListJidel({
    required this.indexDne,
    required this.setHomeWidget,
    required this.jidelnicek,
    super.key,
    required this.setScaffoldBody,
  });
  void refreshButtons(BuildContext context) async {
    DateTime currentDate = minimalDate.add(Duration(days: indexDne));
    try {
      jidelnicekListener.value = await loggedInCanteen.getLunchesForDay(currentDate, requireNew: true);
      await Future.delayed(const Duration(milliseconds: 30));
      ordering = false;
    } catch (e) {
      //Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Nelze Připojit k internetu', setHomeWidget));
    }
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
  Widget build(BuildContext context) {
    jidelnicekListener.value = jidelnicek;
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
                      .showSnackBar(snackbarFunction('Nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu'))
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
                              softRefresh: softRefresh,
                              indexDne: indexDne,
                              refreshButtons: refreshButtons,
                              jidelnicekListener: jidelnicekListener,
                              datumJidla: minimalDate.add(Duration(days: indexDne)),
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
                                  softRefresh: softRefresh,
                                  indexDne: indexDne,
                                  refreshButtons: refreshButtons,
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
  const ObjednatJidloTlacitko(
      {super.key,
      required this.indexJidlaVeDni,
      required this.jidelnicekListener,
      required this.refreshButtons,
      required this.indexDne,
      required this.softRefresh});
  final ValueNotifier<Jidelnicek> jidelnicekListener;
  final int indexDne;
  final int indexJidlaVeDni;
  final Future<void> Function() softRefresh;
  final Function(BuildContext context) refreshButtons;

  @override
  State<ObjednatJidloTlacitko> createState() => _ObjednatJidloTlacitkoState();
}

class _ObjednatJidloTlacitkoState extends State<ObjednatJidloTlacitko> {
  Widget? icon;
  Jidlo? jidlo;
  //fix for api returning garbage when switching orders
  void cannotBeOrderedFix() async {
    try {
      if (!minimalDate.add(Duration(days: widget.indexDne)).isBefore(DateTime.now())) {
        Jidelnicek jidelnicekCheck = await loggedInCanteen.getLunchesForDay(minimalDate.add(Duration(days: widget.indexDne)), requireNew: true);
        for (int i = 0; i < jidelnicekCheck.jidla.length; i++) {
          if (widget.jidelnicekListener.value.jidla[i].lzeObjednat != jidelnicekCheck.jidla[i].lzeObjednat) {
            widget.jidelnicekListener.value = jidelnicekCheck;
            return;
          }
        }
      }
    } catch (e) {
      //if get lunches for day failes we hope api gave us the right values
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonDisabled = true;
    Color? textColor;
    Color? buttonColor;
    late StavJidla stavJidla;
    final int index = widget.indexJidlaVeDni;
    final DateTime datumJidla = minimalDate.add(Duration(days: widget.indexDne));
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

                  switch (stavJidla) {
                    case StavJidla.neobjednano:
                      {
                        try {
                          await canteen.objednat(jidlo!);
                          loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
                        } catch (e) {
                          snackBarMessage('Nastala chyba při objednávání jídla: $e');
                        }
                      }
                      break;
                    case StavJidla.dostupneNaBurze:
                      {
                        try {
                          String varianta = jidlo!.varianta;
                          DateTime den = jidlo!.den;
                          bool nalezenoJidloNaBurze = false;
                          for (var jidloNaBurze in (await loggedInCanteen.canteenData).jidlaNaBurze) {
                            if (jidloNaBurze.den == den && jidloNaBurze.varianta == varianta) {
                              try {
                                await canteen.objednatZBurzy(jidloNaBurze);
                                loggedInCanteen.pridatStatistiku(TypStatistiky.objednavka);
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
                          await canteen.doBurzy(jidlo!);
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
                          if (loggedInCanteen.uzivatel!.kredit < jidlo!.cena!) {
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
                          await canteen.objednat(jidlo!);
                        } catch (e) {
                          snackBarMessage('Nastala chyba při rušení objednávky: $e');
                        }
                      }
                      break;
                    case StavJidla.naBurze:
                      {
                        try {
                          await canteen.doBurzy(jidlo!);
                        } catch (e) {
                          snackBarMessage('Nastala chyba při dávání jídla na burzu: $e');
                        }
                      }
                      break;
                  }
                  if (context.mounted) {
                    widget.refreshButtons(context);
                  }
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
