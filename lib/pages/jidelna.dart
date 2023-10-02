import 'package:flutter/cupertino.dart';

import './../every_import.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({
    super.key,
    required this.setHomeWidget,
  });
  final Function setHomeWidget;

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  PanelController panelController = PanelController();
  Widget scaffoldBody = const Placeholder();
  bool loadingIndicator = false;
  void setScaffoldBody(Widget widget) {
    setState(() {
      scaffoldBody = widget;
    });
  }

  void loading(bool loading) {
    setState(() {
      loadingIndicator = loading;
    });
  }

  void _onVisibilityChanged() async{
    if(!mounted)return;
    if (SwitchAccountVisible().isVisible()) {
      panelController.open();
    }else{
      panelController.close();
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if(!mounted)return;
}

  @override
  Widget build(BuildContext context) {
    SwitchAccountVisible().setVisibilityCallback(() {
      _onVisibilityChanged();
    });
    scaffoldBody = JidelnicekDenWidget(
      setScaffoldBody: setScaffoldBody,
      setHomeWidget: widget.setHomeWidget,
    );
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
                IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_rounded, color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black)),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    if (refreshing) return;
                    loading(true);
                    refreshing = true;
                    try {
                      await initCanteen(hasToBeNew: true);
                    } catch (e) {
                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      if (context.mounted && !snackbarshown.shown) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackbarFunction('nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu', context))
                            .closed
                            .then((SnackBarClosedReason reason) {
                          snackbarshown.shown = false;
                        });
                      }
                    }
                    loading(false);
                    refreshing = false;
                    setScaffoldBody(JidelnicekDenWidget(
                      customCanteenData: getCanteenData(),
                      setScaffoldBody: setScaffoldBody,
                      setHomeWidget: widget.setHomeWidget,
                    ));
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
}

class PopupMenuButtonInAppbar extends StatelessWidget {
  const PopupMenuButtonInAppbar({
    super.key,
    required this.widget,
    required this.setScaffoldBody,
    required this.loading,
  });
  final Function setScaffoldBody;
  final Function loading;
  final MainAppScreen widget;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (context) {
      return [
        PopupMenuItem(
            value: 'about',
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('O Aplikaci'),
                //info icon
                Icon(Icons.info_rounded, color: Colors.black)
              ],
            ),
            onTap: () async {
              var packageInfo = await PackageInfo.fromPlatform();
              // why: it says this is the use case we should use in the docs
              // ignore: use_build_context_synchronously
              if (!context.mounted) return;
              showAboutDialog(
                  context: context,
                  applicationName: "Autojidelna",
                  applicationLegalese: "© 2023 Tomáš Protiva, Matěj Verhaegen a kolaborátoři\nZveřejněno pod licencí GNU GPLv3",
                  applicationVersion: packageInfo.version,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: ElevatedButton(
                        onPressed: (() => launchUrl(Uri.parse("https://github.com/tpkowastaken/autojidelna"), mode: LaunchMode.externalApplication)),
                        child: const Text('Zdrojový kód'),
                      ),
                    ),
                    Builder(builder: (context) {
                      try {
                        if (!releaseInfo.isAndroid) {
                          return const SizedBox(
                            height: 0,
                            width: 0,
                          );
                        }
                      } catch (e) {
                        return const SizedBox(
                          height: 0,
                          width: 0,
                        );
                      }
                      return ElevatedButton(
                        onPressed: () async {
                          await getLatestRelease();
                          if (releaseInfo.isAndroid && releaseInfo.currentlyLatestVersion! && context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbarFunction('Aktuálně jste na nejnovější verzi aplikace 👍', context))
                                .closed
                                .then((SnackBarClosedReason reason) {
                              snackbarshown.shown = false;
                            });
                            return;
                          } else if (!releaseInfo.isAndroid) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                                    snackbarFunction('nepovedlo se připojit k serverům githubu. Ověřte připojení a zkuste to znovu...', context))
                                .closed
                                .then((SnackBarClosedReason reason) {
                              snackbarshown.shown = false;
                            });
                            return;
                          }
                          Future.delayed(Duration.zero, () => newUpdateDialog(context));
                        },
                        child: const Text('Zkontrolovat aktualizace'),
                      );
                    }),
                  ]);
            }),
      ];
    });
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
    required this.setHomeWidget,
  });
  final Function setHomeWidget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          logout();
          setHomeWidget(LoginScreen(
            setHomeWidget: setHomeWidget,
          ));
        },
        child: const Text('Log out'));
  }
}

class JidelnicekDenWidget extends StatelessWidget {
  //define key
  JidelnicekDenWidget({
    super.key,
    this.customCanteenData,
    required this.setScaffoldBody,
    required this.setHomeWidget,
  });
  final Function setHomeWidget;
  final Function setScaffoldBody;

  final DateTime currentDate = DateTime(2006, 5, 23).add(Duration(days: getJidelnicekPageNum().pageNumber));
  final ValueNotifier<DateTime> dateListener = ValueNotifier<DateTime>(DateTime(2006, 5, 23).add(Duration(days: getJidelnicekPageNum().pageNumber)));
  final ValueNotifier<CanteenData> canteenDataListener = ValueNotifier<CanteenData>(getCanteenData());

  final PageController pageviewController = PageController(initialPage: getJidelnicekPageNum().pageNumber);
  final DateTime minimalDate = DateTime(2006, 5, 23);
  final CanteenData canteenData = getCanteenData();
  final CanteenData? customCanteenData;

  void refreshCanteenUser() async {
    try {
      final Uzivatel uzivatel = await (await initCanteen()).ziskejUzivatele();
      canteenData.uzivatel = uzivatel;
      setCanteenData(canteenData);
      canteenDataListener.value = canteenData.copyWith();
    } catch (e) {
      try {
        await Future.delayed(const Duration(milliseconds: 300));
        final Uzivatel uzivatel = await (await initCanteen()).ziskejUzivatele();
        canteenData.uzivatel = uzivatel;
        setCanteenData(canteenData);
        canteenDataListener.value = canteenData.copyWith();
      } catch (e) {
        //if it failed twice the server is either down or the user is spamming it so we don't want to spam it more
      }
    }
  }

  void changeDate({DateTime? newDate, int? daysChange, int? index}) {
    if (daysChange != null) {
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
      getJidelnicekPageNum().pageNumber = newDate.difference(minimalDate).inDays;
    } else if (newDate != null) {
      smartPreIndexing(newDate);
      dateListener.value = newDate;
      dateListener.value = newDate;
      getJidelnicekPageNum().pageNumber = newDate.difference(minimalDate).inDays;
      pageviewController.jumpToPage(newDate.difference(minimalDate).inDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    //bool isWeekend = dayOfWeek == 'Sobota' || dayOfWeek == 'Neděle'; //to be implemented...
    if (customCanteenData != null) {
      canteenDataListener.value = customCanteenData!;
    }
    return Scaffold(
      body: Padding(
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
                              lastDate: currentDate.add(const Duration(days: 365 * 2)),
                            );
                            if (datePicked == null) return;
                            changeDate(newDate: datePicked);
                          },
                          child: SizedBox(
                            //relative to the width of the viewport
                            width: MediaQuery.of(context).size.width * 0.4,
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
                  return JidelnicekWidget(
                    minimalDate: minimalDate,
                    widget: this,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JidelnicekWidget extends StatelessWidget {
  const JidelnicekWidget({super.key, required this.minimalDate, required this.widget, required this.index});

  final DateTime minimalDate;
  final JidelnicekDenWidget widget;
  final int index;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: getLunchesForDay(minimalDate.add(Duration(days: index))),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Nelze Připojit k internetu', widget.setHomeWidget));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return ListJidel(widget: this, errorWidget: Text(snapshot.error.toString()));
            }
            Jidelnicek jidelnicek = snapshot.data as Jidelnicek;
            return ListJidel(
              jidelnicek: jidelnicek,
              widget: this,
            );
          }),
    );
  }
}

class ListJidel extends StatelessWidget {
  final Jidelnicek? jidelnicek;
  final JidelnicekWidget widget;
  final Widget? errorWidget;
  final ValueNotifier<List<Jidlo>> jidlaListener = ValueNotifier<List<Jidlo>>([]);
  ListJidel({
    this.jidelnicek,
    super.key,
    required this.widget,
    this.errorWidget,
  });
  void refreshButtons() async {
    DateTime currentDate = widget.minimalDate.add(Duration(days: widget.index));
    jidlaListener.value = (await refreshLunches(currentDate)).jidla; //error handling please
  }

  @override
  Widget build(BuildContext context) {
    if (jidelnicek == null) {
      return const Center(child: CircularProgressIndicator());
    }
    jidlaListener.value = jidelnicek!.jidla;
    return Column(
      children: [
        Builder(builder: (_) {
          if (jidelnicek == null) {
            return RefreshIndicator(
              onRefresh: () async {
                if (refreshing) return;
                refreshing = true;
                try {
                  await initCanteen(hasToBeNew: true);
                } catch (e) {
                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  if (context.mounted && !snackbarshown.shown) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackbarFunction('Nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu', context))
                        .closed
                        .then((SnackBarClosedReason reason) {
                      snackbarshown.shown = false;
                    });
                  }
                }
                refreshing = false;
                widget.widget.setScaffoldBody(JidelnicekDenWidget(
                  customCanteenData: getCanteenData(),
                  setScaffoldBody: widget.widget.setScaffoldBody,
                  setHomeWidget: widget.widget.setHomeWidget,
                ));
                
              },
            child: SizedBox( 
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 2 - 100),
                  child: errorWidget!,
                ))));
          }
          if (jidelnicek!.jidla.isEmpty) {
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  if (refreshing) return;
                  refreshing = true;
                  try {
                    await initCanteen(hasToBeNew: true);
                  } catch (e) {
                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    if (context.mounted && !snackbarshown.shown) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackbarFunction('Nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu', context))
                          .closed
                          .then((SnackBarClosedReason reason) {
                        snackbarshown.shown = false;
                      });
                    }
                  }
                  refreshing = false;
                  widget.widget.setScaffoldBody(JidelnicekDenWidget(
                    customCanteenData: getCanteenData(),
                    setScaffoldBody: widget.widget.setScaffoldBody,
                    setHomeWidget: widget.widget.setHomeWidget,
                  ));
                  
                },
                child: SizedBox(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      //half of the screen height padding
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 2 - 100),
                      child: const Text('Žádná Jídla pro tento den'),
                    )),
                )),
            );
          }
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (refreshing) return;
                refreshing = true;
                try {
                  await initCanteen(hasToBeNew: true);
                } catch (e) {
                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  if (context.mounted && !snackbarshown.shown) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackbarFunction('Nastala chyba při aktualizaci dat, zkontrolujte připojení a zkuste to znovu', context))
                        .closed
                        .then((SnackBarClosedReason reason) {
                      snackbarshown.shown = false;
                    });
                  }
                }
                refreshing = false;
                widget.widget.setScaffoldBody(JidelnicekDenWidget(
                  customCanteenData: getCanteenData(),
                  setScaffoldBody: widget.widget.setScaffoldBody,
                  setHomeWidget: widget.widget.setHomeWidget,
                ));
              },
              child: ListView.builder(
                itemCount: jidelnicek!.jidla.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JidloDetail(
                            datumJidla: widget.widget.minimalDate.add(Duration(days: widget.index)),
                            indexDne: index,
                            widget: this,
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
                                  color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                      ? const Color.fromARGB(20, 255, 255, 255)
                                      : const Color.fromARGB(20, 0, 0, 0),
                                  offset: const Offset(0, 0),
                                )
                              ],
                              border: Border.all(color: const Color.fromARGB(255, 122, 122, 122), width: 2),
                              borderRadius: const BorderRadius.all(Radius.circular(16))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0.5, 4, 0.5, 0),
                                child: Builder(builder: (_) {
                                  String jidlo = parseJidlo(jidelnicek!.jidla[index].nazev, alergeny: jidelnicek!.jidla[index].alergeny.join(', '))
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
                                padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                                child: ObjednatJidloTlacitko(
                                  widget: this,
                                  jidlaListener: jidlaListener,
                                  index: index,
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
  const ObjednatJidloTlacitko({super.key, required this.widget, required this.index, required this.jidlaListener});
  final ValueNotifier jidlaListener;
  final ListJidel widget;
  final int index;

  @override
  State<ObjednatJidloTlacitko> createState() => _ObjednatJidloTlacitkoState();
}

class _ObjednatJidloTlacitkoState extends State<ObjednatJidloTlacitko> {
  Widget? icon;
  Jidlo? jidlo;
  //fix for api returning garbage when switching orders
  void cannotBeOrderedFix() async {
    try {
      if ((await getLunchesForDay(widget.widget.widget.minimalDate.add(Duration(days: widget.widget.widget.index)), requireNew: true))
              .jidla[widget.index]
              .lzeObjednat !=
          jidlo!.lzeObjednat) {
        icon = null;
        widget.widget.refreshButtons();
      }
    } catch (e) {
      icon = null;
      widget.widget.refreshButtons();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? buttonColor;
    late Jidelnicek jidelnicek;
    late StavJidla stavJidla;
    final int index = widget.index;
    String obedText;
    return ValueListenableBuilder(
        valueListenable: widget.jidlaListener,
        builder: (context, value, child) {
          jidelnicek = widget.widget
              .jidelnicek!; //this is a permanent referrence that doesn't need to change in the button scope (if refreshed it changes higher in the highearchy)
          try {
            jidlo = value[index]; //only set this so that we don't overwrite it after the button has been clicked
          }
          //if we went out of bounds that means that api returned not enough lunches so we need to try again (refresh). This doesn't fix the problem of api returning garbage
          catch (e) {
            widget.widget.refreshButtons();
            //giving a placeholder until the button refreshes
            return ElevatedButton(
              //rounding the button
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 34, 150, 243),
                      strokeWidth: 3.5,
                    ),
                  ),
                ],
              ),
            );
          }
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
          } else if (jeJidloNaBurze(jidlo!)) {
            stavJidla = StavJidla.dostupneNaBurze;
          } else if (!jidlo!.objednano && !jidlo!.lzeObjednat) {
            stavJidla = StavJidla.nedostupne;
          }
          switch (stavJidla) {
            //jednoduché operace
            case StavJidla.objednano:
              buttonColor = const Color.fromRGBO(17, 201, 11, 1);
              obedText = 'Zrušit ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            case StavJidla.neobjednano:
              buttonColor = const Color.fromARGB(255, 252, 144, 98);
              obedText = 'Objednat ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            //operace v minulosti
            case StavJidla.objednanoVyprsenaPlatnost:
              buttonColor = const Color.fromRGBO(17, 201, 11, 1);
              obedText = 'Nelze zrušit ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            case StavJidla.nedostupne:
              cannotBeOrderedFix();
              buttonColor = const Color.fromARGB(255, 247, 75, 75);
              obedText = 'Nelze objednat ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            //operace na burze
            case StavJidla.objednanoNelzeOdebrat:
              buttonColor = const Color.fromRGBO(17, 201, 11, 1);
              obedText = 'Vložit na burzu ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            case StavJidla.dostupneNaBurze:
              buttonColor = const Color.fromARGB(255, 180, 116, 6);
              obedText = 'Objednat z burzy ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
              break;
            case StavJidla.naBurze:
              buttonColor = const Color.fromARGB(255, 180, 116, 6);
              obedText = 'Odebrat z burzy ${jidlo!.varianta} za ${jidlo!.cena!.toInt()} Kč';
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
                  ScaffoldMessenger.of(context).showSnackBar(snackbarFunction(message, context)).closed.then((SnackBarClosedReason reason) {
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
                      for (int i = 0; i < 20 && canteenData.jidelnicky[jidelnicek.den] == null; i++) {
                        if (i >= 19) {
                          throw Exception('Nepovedl se načíst jídelníček, aktualizujte stránku');
                        }
                        await Future.delayed(const Duration(milliseconds: 100));
                      }
                      canteenData.jidelnicky[jidelnicek.den]!.jidla[index] = await canteen.objednat(jidlo!);
                      pridatStatistiku(TypStatistiky.objednavka);
                    } catch (e) {
                      snackBarMessage('Nastala chyba při objednávání jídla: $e');
                    }
                  }
                  break;
                case StavJidla.dostupneNaBurze:
                  {
                    String varianta = jidlo!.varianta;
                    DateTime den = jidlo!.den;
                    bool nalezenoJidloNaBurze = false;
                    for (var jidloNaBurze in canteenData.jidlaNaBurze) {
                      if (jidloNaBurze.den == den && jidloNaBurze.varianta == varianta) {
                        try {
                          await canteen.objednatZBurzy(jidloNaBurze);
                          pridatStatistiku(TypStatistiky.objednavka);
                        } catch (e) {
                          snackBarMessage('Nastala chyba při objednávání jídla z burzy: $e');
                        }
                      }
                    }
                    if (nalezenoJidloNaBurze == false) {
                      snackBarMessage('Nepodařilo se najít jídlo na burze, někdo vám ho pravděpodobně vyfouknul před nosem');
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
                    if (getCanteenData().uzivatel.kredit < jidlo!.cena!) {
                      snackBarMessage('Oběd nelze objednat - Nedostatečný kredit');
                      break;
                    }
                    snackBarMessage('Oběd nelze objednat. (pravděpodobně je toto oběd z minulosti nebo aktuálně není na burze)');
                  }
                  break;
                case StavJidla.objednano:
                  {
                    try {
                      for (int i = 0; i < 20 && canteenData.jidelnicky[jidelnicek.den] == null; i++) {
                        if (i >= 19) {
                          throw Exception('Nepovedlo načíst jídelníček, aktualizujte stránku');
                        }
                        await Future.delayed(const Duration(milliseconds: 100));
                      }
                      canteenData.jidelnicky[jidelnicek.den]!.jidla[index] = await canteen.objednat(jidlo!);
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
                      snackBarMessage('Nsastala chyba při dávání jídla na burzu: $e');
                    }
                  }
                  break;
              }
              widget.widget.widget.widget.refreshCanteenUser();
              widget.widget.refreshButtons();
              ordering.ordering = false;
              if (context.mounted) {
                setState(() {
                  icon = null;
                });
              }
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
