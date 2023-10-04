import 'package:flutter/cupertino.dart';

import './../every_import.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({
    super.key,
    required this.setHomeWidget,
  });
  final Function setHomeWidget;

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

  ///reloads the page
  Future<void> reload() async {
    if (refreshing) return;
    setState(() {
      loadingIndicator = true;
    });
    refreshing = true;
    try {
      await initCanteen(hasToBeNew: true);
    } catch (e) {
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      if (context.mounted && !snackbarshown.shown) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackbarFunction(
                'nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu',
                context))
            .closed
            .then((SnackBarClosedReason reason) {
          snackbarshown.shown = false;
        });
      }
    }
    setState(() {
      loadingIndicator = false;
    });
    refreshing = false;
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
            backgroundColor: const Color.fromARGB(255, 148, 18, 148),
            centerTitle: true,
            title: const Text('Autojídelna'),
            actions: [
              //calendar button
              IconButton(
                  onPressed: () {
                    changeDate(newDate: DateTime.now(), animateToPage: true);
                  },
                  icon: Icon(Icons.calendar_today_rounded,
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black)),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 30,
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

  ///changes the date of the Jidelnicek
  ///newDate - just sets the new date
  ///newDate and animateToPage - animates to the new page
  ///daysChange - animates the change of date by the number of days
  ///index - changes the date by the index of the page
  void changeDate(
      {DateTime? newDate, int? daysChange, int? index, bool? animateToPage}) {
    if (newDate != null && animateToPage != null && animateToPage) {
      smartPreIndexing(newDate);
      dateListener.value = newDate;
      getJidelnicekPageNum().pageNumber =
          newDate.difference(minimalDate).inDays;
      pageviewController.animateToPage(
        newDate.difference(minimalDate).inDays,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    } else if (daysChange != null) {
      newDate = dateListener.value.add(Duration(days: daysChange));
      smartPreIndexing(newDate);
      pageviewController.animateToPage(
        newDate.difference(minimalDate).inDays,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    } else if (index != null) {
      newDate = minimalDate.add(Duration(days: index));
      smartPreIndexing(newDate);
      dateListener.value = newDate;
      getJidelnicekPageNum().pageNumber =
          newDate.difference(minimalDate).inDays;
    } else if (newDate != null) {
      smartPreIndexing(newDate);
      dateListener.value = newDate;
      getJidelnicekPageNum().pageNumber =
          newDate.difference(minimalDate).inDays;
      pageviewController.jumpToPage(newDate.difference(minimalDate).inDays);
    }
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
                String dayOfWeek = ziskatDenZData(currentDate.weekday);
                return SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            changeDate(daysChange: -1);
                          },
                          icon: const Icon(Icons.arrow_left)),
                      CupertinoButton(
                        onPressed: () async {
                          var datePicked = await showDatePicker(
                            context: context,
                            helpText: 'Vyberte datum Jídelníčku',
                            initialDate: currentDate,
                            currentDate: DateTime.now(),
                            firstDate: minimalDate,
                            lastDate:
                                currentDate.add(const Duration(days: 365 * 2)),
                          );
                          if (datePicked == null) return;
                          changeDate(newDate: datePicked);
                        },
                        child: SizedBox(
                          //relative to the width of the viewport
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Center(
                            child: Text(
                                style: const TextStyle(color: Colors.purple),
                                "${currentDate.day}. ${currentDate.month}. ${currentDate.year} - $dayOfWeek"),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            changeDate(daysChange: 1);
                          },
                          icon: const Icon(Icons.arrow_right))
                    ],
                  ),
                );
              }),
          Expanded(
            child: PageView.builder(
              controller: pageviewController,
              onPageChanged: (value) {
                changeDate(index: value);
                getJidelnicekPageNum().pageNumber = value;
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

  ///widget for the Jidelnicek for the day - mainly the getting lunches logic
  SizedBox jidelnicekDenWidget(int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: getLunchesForDay(minimalDate.add(Duration(days: index))),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Future.delayed(
                  Duration.zero,
                  () => failedLoginDialog(context, 'Nelze Připojit k internetu',
                      widget.setHomeWidget));
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
          }),
    );
  }
}

class ListJidel extends StatelessWidget {
  final Jidelnicek jidelnicek;
  final int indexDne;
  final Function setHomeWidget;
  final Function(Widget widget) setScaffoldBody;
  final ValueNotifier<List<Jidlo>> jidlaListener =
      ValueNotifier<List<Jidlo>>([]);
  ListJidel(
      {required this.indexDne,
      required this.setHomeWidget,
      required this.jidelnicek,
      super.key,
      required this.setScaffoldBody});
  void refreshButtons(BuildContext context) async {
    DateTime currentDate = minimalDate.add(Duration(days: indexDne));
    try {
      jidlaListener.value = (await refreshLunches(currentDate)).jidla;
    } catch (e) {
      Future.delayed(
          Duration.zero,
          () => failedLoginDialog(
              context, 'Nelze Připojit k internetu', setHomeWidget));
    }
  }

  @override
  Widget build(BuildContext context) {
    jidlaListener.value = jidelnicek.jidla;
    if (jidlaListener.value.length < numberOfMaxLunches) {
      getLunchesForDay(minimalDate.add(Duration(days: indexDne)),
              requireNew: true)
          .then((value) {
        if (jidlaListener.value.length < numberOfMaxLunches) {
          jidlaListener.value = value.jidla;
        }
      });
    }
    return Column(
      children: [
        Builder(builder: (_) {
          Future<void> softRefresh() async {
            if (refreshing) return;
            refreshing = true;
            try {
              await initCanteen(hasToBeNew: true);
            } catch (e) {
              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              if (context.mounted && !snackbarshown.shown) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackbarFunction(
                        'Nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu',
                        context))
                    .closed
                    .then((SnackBarClosedReason reason) {
                  snackbarshown.shown = false;
                });
              }
            }
            refreshing = false;
            setScaffoldBody(MainAppScreenState().jidelnicekWidget());
          }

          if (jidelnicek.jidla.isEmpty) {
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
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 2 - 100),
                          child: const Text('Žádná Jídla pro tento den'),
                        )),
                  )),
            );
          }
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await softRefresh();
              },
              child: ListView.builder(
                itemCount: jidelnicek.jidla.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JidloDetail(
                            indexDne: indexDne,
                            refreshButtons: refreshButtons,
                            jidlaListener: jidlaListener,
                            datumJidla:
                                minimalDate.add(Duration(days: indexDne)),
                            indexJidlaVeDni: index,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? const Color.fromARGB(20, 255, 255, 255)
                                      : const Color.fromARGB(20, 0, 0, 0),
                                  offset: const Offset(0, 0),
                                )
                              ],
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 122, 122, 122),
                                  width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.5, 4, 0.5, 0),
                                    child: Builder(builder: (_) {
                                      String jidlo = parseJidlo(
                                              jidelnicek.jidla[index].nazev,
                                              alergeny: jidelnicek
                                                  .jidla[index].alergeny
                                                  .join(', '))
                                          .zkracenyNazevJidla;
                                      return HtmlWidget(
                                        jidlo,
                                        textStyle: const TextStyle(
                                          fontSize: 25,
                                        ),
                                      );
                                    }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 16.0, 0, 0),
                                    child: ObjednatJidloTlacitko(
                                      indexDne: indexDne,
                                      refreshButtons: refreshButtons,
                                      jidlaListener: jidlaListener,
                                      indexJidlaVeDni: index,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}

class ObjednatJidloTlacitko extends StatefulWidget {
  const ObjednatJidloTlacitko({
    super.key,
    required this.indexJidlaVeDni,
    required this.jidlaListener,
    required this.refreshButtons,
    required this.indexDne,
  });
  final ValueNotifier<List<Jidlo>> jidlaListener;
  final int indexDne;
  final int indexJidlaVeDni;
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
      if (!minimalDate
          .add(Duration(days: widget.indexDne))
          .isBefore(DateTime.now())) {
        Jidelnicek jidelnicekCheck = await getLunchesForDay(
            minimalDate.add(Duration(days: widget.indexDne)),
            requireNew: true);
        for (int i = 0; i < jidelnicekCheck.jidla.length; i++) {
          if (widget.jidlaListener.value[i].lzeObjednat !=
              jidelnicekCheck.jidla[i].lzeObjednat) {
            widget.jidlaListener.value = jidelnicekCheck.jidla;
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
    Color? buttonColor;
    late StavJidla stavJidla;
    final int index = widget.indexJidlaVeDni;
    final DateTime datumJidla =
        minimalDate.add(Duration(days: widget.indexDne));
    String obedText;
    return ValueListenableBuilder(
        valueListenable: widget.jidlaListener,
        builder: (context, value, child) {
          jidlo = value[index];
          if (jidlo!.naBurze) {
            //pokud je od nás vloženo na burze, tak není potřeba kontrolovat nic jiného
            stavJidla = StavJidla.naBurze;
          } else if (jidlo!.objednano && jidlo!.lzeObjednat) {
            stavJidla = StavJidla.objednano;
          } else if (jidlo!.objednano &&
              !jidlo!.lzeObjednat &&
              (jidlo!.burzaUrl == null || jidlo!.burzaUrl!.isEmpty)) {
            //pokud nelze dát na burzu, tak už je po platnosti (nic už s tím neuděláme)
            stavJidla = StavJidla.objednanoVyprsenaPlatnost;
          } else if (jidlo!.objednano && !jidlo!.lzeObjednat) {
            stavJidla = StavJidla.objednanoNelzeOdebrat;
          } else if (!jidlo!.objednano && jidlo!.lzeObjednat) {
            stavJidla = StavJidla.neobjednano;
          } else if (jeJidloNaBurze(jidlo!)) {
            stavJidla = StavJidla.dostupneNaBurze;
          } else if (!jidlo!.objednano && !jidlo!.lzeObjednat) {
            stavJidla = StavJidla.nedostupne;
          }
          switch (stavJidla) {
            //jednoduché operace
            case StavJidla.objednano:
              buttonColor = const Color.fromRGBO(17, 201, 11, 1);
              obedText =
                  'Zrušit ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            case StavJidla.neobjednano:
              buttonColor = const Color.fromARGB(255, 252, 144, 98);
              obedText =
                  'Objednat ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            //operace v minulosti
            case StavJidla.objednanoVyprsenaPlatnost:
              buttonColor = const Color.fromRGBO(17, 201, 11, 1);
              obedText =
                  'Nelze zrušit ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            case StavJidla.nedostupne:
              try {
                bool jeVeDneDostupnyObed = false;
                int prvniIndex = -1;
                for (int i = 0;
                    i < canteenData!.jidelnicky[datumJidla]!.jidla.length;
                    i++) {
                  if (canteenData!
                          .jidelnicky[datumJidla]!.jidla[i].lzeObjednat ||
                      canteenData!.jidelnicky[datumJidla]!.jidla[i].objednano ||
                      jeJidloNaBurze(
                          canteenData!.jidelnicky[datumJidla]!.jidla[i]) ||
                      canteenData!.jidelnicky[datumJidla]!.jidla[i].burzaUrl !=
                          null) {
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
              buttonColor = const Color.fromARGB(255, 247, 75, 75);
              if (canteenData!.uzivatel.kredit < jidlo!.cena! &&
                  !datumJidla.isBefore(DateTime.now())) {
                obedText =
                    'Nedostatek kreditu ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              } else {
                obedText =
                    'Nelze objednat ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              }
              break;
            //operace na burze
            case StavJidla.objednanoNelzeOdebrat:
              buttonColor = const Color.fromRGBO(17, 201, 11, 1);
              obedText =
                  'Vložit na burzu ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            case StavJidla.dostupneNaBurze:
              buttonColor = const Color.fromARGB(255, 180, 116, 6);
              obedText =
                  'Objednat z burzy ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            case StavJidla.naBurze:
              buttonColor = const Color.fromARGB(255, 180, 116, 6);
              obedText =
                  'Odebrat z burzy ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
          }
          if (!ordering.ordering) {
            switch (stavJidla) {
              case StavJidla.objednano:
                icon = null;
                break;
              case StavJidla.neobjednano:
                icon = null;
                break;
              //operace v minulosti
              case StavJidla.objednanoVyprsenaPlatnost:
                icon = const Icon(
                  Icons.block,
                  color: Color.fromRGBO(255, 255, 255, 1),
                );
                break;
              case StavJidla.nedostupne:
                icon = const Icon(
                  Icons.block,
                  color: Color.fromRGBO(255, 255, 255, 1),
                );
                break;
              //operace na burze
              case StavJidla.objednanoNelzeOdebrat:
                icon = const Icon(
                  Icons.shopping_bag,
                  color: Color.fromRGBO(255, 255, 255, 1),
                );
                break;
              case StavJidla.dostupneNaBurze:
                icon = const Icon(
                  Icons.shopping_bag,
                  color: Color.fromRGBO(255, 255, 255, 1),
                );
                break;
              case StavJidla.naBurze:
                icon = const Icon(
                  //market icon
                  Icons.shopping_bag,
                  color: Color.fromRGBO(255, 255, 255, 1),
                );
                break;
            }
          }

          return ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(500, 50)),
              backgroundColor: MaterialStateProperty.all(buttonColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            onPressed: () async {
              void snackBarMessage(String message) {
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                // toto je upozornění dole (Snackbar)
                // snackbarshown je aby se snackbar nezobrazil vícekrát
                if (context.mounted && snackbarshown.shown == false) {
                  snackbarshown.shown = true;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackbarFunction(message, context))
                      .closed
                      .then((SnackBarClosedReason reason) {
                    snackbarshown.shown = false;
                  });
                }
              }

              if (ordering.ordering) {
                return;
              }
              ordering.ordering = true;
              setState(() {
                icon = const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 34, 150, 243),
                    strokeWidth: 3.5,
                  ),
                );
              });
              Canteen canteen = await initCanteen();
              switch (stavJidla) {
                case StavJidla.neobjednano:
                  {
                    try {
                      for (int i = 0;
                          i < 20 && canteenData!.jidelnicky[datumJidla] == null;
                          i++) {
                        if (i >= 19) {
                          throw Exception(
                              'Nepovedl se načíst jídelníček, aktualizujte stránku');
                        }
                        await Future.delayed(const Duration(milliseconds: 100));
                      }
                      canteenData!.jidelnicky[datumJidla]!.jidla[index] =
                          await canteen.objednat(jidlo!);
                      pridatStatistiku(TypStatistiky.objednavka);
                    } catch (e) {
                      snackBarMessage(
                          'Nastala chyba při objednávání jídla: $e');
                    }
                  }
                  break;
                case StavJidla.dostupneNaBurze:
                  {
                    String varianta = jidlo!.varianta;
                    DateTime den = jidlo!.den;
                    bool nalezenoJidloNaBurze = false;
                    for (var jidloNaBurze in canteenData!.jidlaNaBurze) {
                      if (jidloNaBurze.den == den &&
                          jidloNaBurze.varianta == varianta) {
                        try {
                          await canteen.objednatZBurzy(jidloNaBurze);
                          pridatStatistiku(TypStatistiky.objednavka);
                        } catch (e) {
                          snackBarMessage(
                              'Nastala chyba při objednávání jídla z burzy: $e');
                        }
                      }
                    }
                    if (nalezenoJidloNaBurze == false) {
                      snackBarMessage(
                          'Nepodařilo se najít jídlo na burze, někdo vám ho pravděpodobně vyfouknul před nosem');
                    }
                  }
                  break;
                case StavJidla.objednanoVyprsenaPlatnost:
                  {
                    snackBarMessage(
                        'Oběd nelze zrušit. Platnost objednávky vypršela. (pravděpodobně je toto oběd z minulosti)');
                  }
                  break;
                case StavJidla.objednanoNelzeOdebrat:
                  {
                    try {
                      await canteen.doBurzy(jidlo!);
                    } catch (e) {
                      snackBarMessage(
                          'Nastala chyba při dávání jídla na burzu: $e');
                    }
                  }
                  break;
                case StavJidla.nedostupne:
                  {
                    if (datumJidla.isBefore(DateTime.now())) {
                      snackBarMessage(
                          'Oběd nelze objednat. (pravděpodobně je toto oběd z minulosti)');
                      break;
                    }
                    if (canteenData!.uzivatel.kredit < jidlo!.cena!) {
                      snackBarMessage(
                          'Oběd nelze objednat - Nedostatečný kredit');
                      break;
                    }
                    snackBarMessage(
                        'Oběd nelze objednat. (pravděpodobně je toto oběd z minulosti nebo aktuálně není na burze)');
                  }
                  break;
                case StavJidla.objednano:
                  {
                    try {
                      for (int i = 0;
                          i < 20 && canteenData!.jidelnicky[datumJidla] == null;
                          i++) {
                        if (i >= 19) {
                          throw Exception(
                              'Nepovedlo se načíst jídelníček, aktualizujte stránku');
                        }
                        await Future.delayed(const Duration(milliseconds: 100));
                      }
                      canteenData!.jidelnicky[datumJidla]!.jidla[index] =
                          await canteen.objednat(jidlo!);
                    } catch (e) {
                      snackBarMessage(
                          'Nastala chyba při rušení objednávky: $e');
                    }
                  }
                  break;
                case StavJidla.naBurze:
                  {
                    try {
                      await canteen.doBurzy(jidlo!);
                    } catch (e) {
                      snackBarMessage(
                          'Nsastala chyba při dávání jídla na burzu: $e');
                    }
                  }
                  break;
              }
              if (context.mounted) {
                widget.refreshButtons(context);
              }
              ordering.ordering = false;
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
                        child: Text(
                          obedText,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  icon == null ? const Icon(null) : icon!,
                ]),
          );
        });
  }
}
