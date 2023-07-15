import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/cupertino.dart';

import '../methods/icanteen.dart';
import './all.dart';

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

class JidelnicekPageNum {
  JidelnicekPageNum({required this.pageNumber});
  int pageNumber;
}

final JidelnicekPageNum jidelnicekPageNum = JidelnicekPageNum(
    pageNumber: DateTime.now().difference(DateTime(2006, 5, 23)).inDays);

JidelnicekPageNum getJidelnicekPageNum() {
  return jidelnicekPageNum;
}

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
  Widget scaffoldBody = JidelnicekDenWidget();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Center(child: Text('Autojídelna Přihlášeno')),
          actions: [
            PopupMenuButtonInAppbar(
              widget: widget,
              setScaffoldBody: setScaffoldBody,
              loading: loading,
            ),
          ]),
      body: Stack(
        children: [
          scaffoldBody,
          if (loadingIndicator)
            Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator())),
        ],
      ),
      drawer: MainAppDrawer(
        setHomeWidget: widget.setHomeWidget,
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
          value: 'refresh',
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Aktualizovat'),
              Icon(Icons.refresh_rounded, color: Colors.black)
            ],
          ),
          onTap: () async {
            loading(true);
            await initCanteen(hasToBeNew: true);
            loading(false);
            setScaffoldBody(
                JidelnicekDenWidget(customCanteenData: getCanteenData()));
          },
        ),
        PopupMenuItem(
            value: 'logout',
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Odhlásit se'),
                Icon(Icons.logout_rounded, color: Colors.black)
              ],
            ),
            onTap: () {
              logout();
              widget.setHomeWidget(LoginScreen(
                setHomeWidget: widget.setHomeWidget,
              ));
              //to be implemented
            }),
      ];
    });
  }
}

class MainAppDrawer extends StatelessWidget {
  const MainAppDrawer({
    super.key,
    required this.setHomeWidget,
  });
  final Function setHomeWidget;

  @override
  Widget build(BuildContext context) {
    final String username = getCanteenData().username;
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Text('Autojídelna'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Jste přihlášen jako $username'),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ElevatedButton(
            child: const Text('Odhlásit se'),
            onPressed: () => {
              logout(),
              setHomeWidget(LoginScreen(
                setHomeWidget: setHomeWidget,
              ))
            },
          ),
        ),
      ),
    );
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
  });

  final DateTime currentDate = DateTime(2006, 5, 23)
      .add(Duration(days: getJidelnicekPageNum().pageNumber));
  final ValueNotifier<DateTime> dateListener = ValueNotifier<DateTime>(
      DateTime(2006, 5, 23)
          .add(Duration(days: getJidelnicekPageNum().pageNumber)));
  final ValueNotifier<CanteenData> canteenDataListener =
      ValueNotifier<CanteenData>(getCanteenData());
  final ValueNotifier<CanteenData> canteenDataRefreshListener =
      ValueNotifier<CanteenData>(getCanteenData());
  final PageController pageviewController =
      PageController(initialPage: getJidelnicekPageNum().pageNumber);
  final DateTime minimalDate = DateTime(2006, 5, 23);
  final CanteenData canteenData = getCanteenData();
  final CanteenData? customCanteenData;

  void restartCanteen() async {
    final Uzivatel uzivatel = await (await initCanteen()).ziskejUzivatele();
    canteenData.uzivatel = uzivatel;
    setCanteenData(canteenData);
    canteenDataListener.value = canteenData;
  }

  void changeDate({DateTime? newDate, int? daysChange, int? index}) {
    if (daysChange != null) {
      newDate = dateListener.value.add(Duration(days: daysChange));
      if (daysChange < 0) {
        preIndexLunches(newDate.subtract(const Duration(days: 7)), 7);
      } else {
        preIndexLunches(newDate, 7);
      }
      pageviewController.animateToPage(
        newDate.difference(minimalDate).inDays,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    } else if (index != null) {
      newDate = minimalDate.add(Duration(days: index));
      preIndexLunches(newDate, 7).then((_) =>
          preIndexLunches(newDate!.subtract(const Duration(days: 7)), 7));
      dateListener.value = newDate;
      getJidelnicekPageNum().pageNumber =
          newDate.difference(minimalDate).inDays;
    } else if (newDate != null) {
      preIndexLunches(newDate, 7).then((_) =>
          preIndexLunches(newDate!.subtract(const Duration(days: 7)), 7));
      dateListener.value = newDate;
      getJidelnicekPageNum().pageNumber =
          newDate.difference(minimalDate).inDays;
      pageviewController.jumpToPage(newDate.difference(minimalDate).inDays);
    }
  }

  void refresh() async {
    await initCanteen(hasToBeNew: true);
    canteenDataRefreshListener.value = getCanteenData();
    canteenDataListener.value = canteenDataRefreshListener.value;
  }

  @override
  Widget build(BuildContext context) {
    //bool isWeekend = dayOfWeek == 'Sobota' || dayOfWeek == 'Neděle'; //to be implemented...
    if (customCanteenData != null) {
      canteenDataListener.value = customCanteenData!;
      canteenDataRefreshListener.value = customCanteenData!;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Obědy'),
          ValueListenableBuilder(
              valueListenable: canteenDataListener,
              builder: (ctx, value, child) {
                return Text('Kredit: ${canteenData.uzivatel.kredit}');
              })
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: dateListener,
                builder: (ctx, value, child) {
                  DateTime currentDate = value;
                  String dayOfWeek = ziskatDenZData(currentDate.weekday);
                  return Row(
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
                  );
                }),
            Expanded(
              child: PageView.builder(
                physics: const ClampingScrollPhysics(),
                controller: pageviewController,
                onPageChanged: (value) {
                  changeDate(index: value);
                  getJidelnicekPageNum().pageNumber = value;
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                      valueListenable: canteenDataRefreshListener,
                      builder: (ctx, value, child) {
                        return JidelnicekWidget(
                          minimalDate: minimalDate,
                          widget: this,
                          index: index,
                        );
                      });
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
  const JidelnicekWidget(
      {super.key,
      required this.minimalDate,
      required this.widget,
      required this.index});

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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return ListJidel(
                  widget: this,
                  errorWidget: HtmlWidget(snapshot.error.toString()));
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
  const ListJidel({
    this.jidelnicek,
    super.key,
    required this.widget,
    this.errorWidget,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(builder: (_) {
          if (this.jidelnicek == null) {
            return errorWidget!;
          }
          Jidelnicek jidelnicek = this.jidelnicek!;

          if (jidelnicek.jidla.isEmpty) {
            return const Expanded(
                child: Center(child: Text('Žádná Jídla pro tento den')));
          }
          return Expanded(
            child: ListView.builder(
              itemCount: jidelnicek.jidla.length,
              itemBuilder: (context, index) {
                String jidlo = jidelnicek.jidla[index].nazev;
                return ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                          child: ObjednatJidloTlacitko(
                            widget: this,
                            index: index,
                          ),
                        ),
                        Builder(builder: (_) {
                          if (jidlo.contains('<span')) {
                            List<String> listJidel = jidlo.split('<span');
                            String cistyNazevJidla = listJidel[0];
                            listJidel.removeAt(0);
                            String alergeny = '<span${listJidel.join('<span')}';
                            String htmlString =
                                '$cistyNazevJidla<br> alergeny: $alergeny';
                            return HtmlWidget(htmlString);
                          } else if (jidelnicek
                              .jidla[index].alergeny.isNotEmpty) {
                            return HtmlWidget(
                                '$jidlo<br> alergeny: ${jidelnicek.jidla[index].alergeny}');
                          } else {
                            return HtmlWidget(jidlo);
                          }
                        })
                      ]),
                );
              },
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
    required this.widget,
    required this.index,
  });

  final ListJidel widget;
  final int index;

  @override
  State<ObjednatJidloTlacitko> createState() => _ObjednatJidloTlacitkoState();
}

class _ObjednatJidloTlacitkoState extends State<ObjednatJidloTlacitko> {
  bool snackBarShown = false;
  Color? buttonColor;
  Widget? icon;
  Jidlo? jidlo;
  late Jidelnicek jidelnicek;
  late StavJidla stavJidla;
  @override
  Widget build(BuildContext context) {
    String obedText;
    jidelnicek =
        widget.widget.jidelnicek!; //this is also a permanent referrence
    final int index = widget.index; //this doesn't change after pressing buttons
    jidlo ??= jidelnicek.jidla[
        index]; //only set this so that we don't overwrite it after the button has been clicked

    if (jidlo!.naBurze) {
      stavJidla = StavJidla.naBurze;
      obedText = 'Odebrat z burzy ${jidlo!.varianta} za ${jidlo!.cena} Kč';
    } else if (jidlo!.objednano) {
      stavJidla = StavJidla.objednano;
      obedText = 'Objednáno ${jidlo!.varianta} za ${jidlo!.cena} Kč';
      buttonColor = const Color.fromRGBO(17, 201, 11, 1);
      if (!jidlo!.lzeObjednat) {
        stavJidla = StavJidla.objednanoNelzeOdebrat;
        icon = const Icon(
          Icons.block,
          color: Color.fromRGBO(0, 0, 0, 1),
        );
      }
      if (jidlo!.burzaUrl == null || jidlo!.burzaUrl!.isEmpty) {
        stavJidla = StavJidla.objednanoVyprsenaPlatnost;
        icon = const Icon(
          Icons.block,
          color: Color.fromRGBO(0, 0, 0, 1),
        );
      }
    } else if (jidlo!.lzeObjednat) {
      stavJidla = StavJidla.neobjednano;
      obedText = 'Objednat ${jidlo!.varianta} za ${jidlo!.cena} Kč';
      buttonColor = const Color.fromRGBO(173, 165, 52, 1);
    } else if (jeJidloNaBurze(jidlo!)) {
      stavJidla = StavJidla.dostupneNaBurze;
      obedText = 'Objednat z burzy ${jidlo!.varianta} za ${jidlo!.cena} Kč';
      buttonColor = const Color.fromARGB(255, 180, 116, 6);
      icon = const Icon(
        Icons.shopping_bag,
        color: Color.fromRGBO(0, 0, 0, 1),
      );
    } else {
      stavJidla = StavJidla.nedostupne;
      obedText = 'nelze objednat ${jidlo!.varianta} za ${jidlo!.cena} Kč';
      buttonColor = const Color.fromARGB(255, 247, 75, 75);
      icon = const Icon(
        Icons.block,
        color: Color.fromRGBO(0, 0, 0, 1),
      );
    }

    SnackBar snackbarFunction(String snackBarText) {
      return SnackBar(
        content:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(snackBarText),
          )),
          Builder(builder: (context) {
            return ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 40, 40, 40)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Icon(Icons.close),
            );
          }),
        ]),
      );
    }

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () async {
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
        switch (stavJidla) {
          case StavJidla.neobjednano:
            {
              Canteen canteen = await initCanteen();
              try {
                canteenData.jidelnicky[jidelnicek.den]!.jidla[index] =
                    await canteen.objednat(jidlo!);
                widget.widget.widget.widget.restartCanteen();
              } catch (e) {
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                // toto je upozornění dole (Snackbar)
                // snackbarshown je aby se snackbar nezobrazil vícekrát
                if (context.mounted && snackBarShown == false) {
                  snackBarShown = true;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackbarFunction(
                          'nastala chyba při obejnávání jídla: $e'))
                      .closed
                      .then((SnackBarClosedReason reason) {
                    snackBarShown = false;
                  });
                }
              }
            }
            break;
          case StavJidla.dostupneNaBurze:
            {
              String varianta = jidlo!.varianta;
              DateTime den = jidlo!.den;
              for (var jidloNaBurze in canteenData.jidlaNaBurze) {
                if (jidloNaBurze.den == den &&
                    jidloNaBurze.varianta == varianta) {
                  try {
                    Canteen canteen = await initCanteen();
                    canteen.objednatZBurzy(jidloNaBurze);
                    widget.widget.widget.widget.restartCanteen();
                  } catch (e) {
                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    // toto je upozornění dole (Snackbar)
                    // snackbarshown je aby se snackbar nezobrazil vícekrát
                    if (context.mounted && snackBarShown == false) {
                      snackBarShown = true;
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackbarFunction(
                              'nastala chyba při obejnávání jídla z burzy: $e'))
                          .closed
                          .then((SnackBarClosedReason reason) {
                        snackBarShown = false;
                      });
                    }
                  }
                }
              }
            }
            break;
          case StavJidla.objednanoVyprsenaPlatnost:
            {
              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              // toto je upozornění dole (Snackbar)
              // snackbarshown je aby se snackbar nezobrazil vícekrát
              if (context.mounted && snackBarShown == false) {
                snackBarShown = true;
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackbarFunction(
                        'Oběd nelze zrušit. Platnost objednávky vypršela. (pravděpodobně je toto oběd z minulosti)'))
                    .closed
                    .then((SnackBarClosedReason reason) {
                  snackBarShown = false;
                });
              }
            }
            break;
          case StavJidla.objednanoNelzeOdebrat:
            {
              Canteen canteen = await initCanteen();
              try {
                canteen.doBurzy(jidlo!);
                //není potřeba restartCanteen, protože se nedějí změny kreditu
              } catch (e) {
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                // toto je upozornění dole (Snackbar)
                // snackbarshown je aby se snackbar nezobrazil vícekrát
                if (context.mounted && snackBarShown == false) {
                  snackBarShown = true;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackbarFunction(
                          'nastala chyba při dávání jídla na burzu: $e'))
                      .closed
                      .then((SnackBarClosedReason reason) {
                    snackBarShown = false;
                  });
                }
              }
            }
            break;
          case StavJidla.nedostupne:
            {
              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              // toto je upozornění dole (Snackbar)
              // snackbarshown je aby se snackbar nezobrazil vícekrát
              if (context.mounted && snackBarShown == false) {
                snackBarShown = true;
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackbarFunction(
                        'Oběd nelze objednat. (pravděpodobně je toto oběd z minulosti nebo aktuálně není na burze)'))
                    .closed
                    .then((SnackBarClosedReason reason) {
                  snackBarShown = false;
                });
              }
            }
            break;
          case StavJidla.objednano:
            {
              Canteen canteen = await initCanteen();
              try {
                canteen.objednat(jidlo!);
                widget.widget.widget.widget.restartCanteen();
              } catch (e) {
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                // toto je upozornění dole (Snackbar)
                // snackbarshown je aby se snackbar nezobrazil vícekrát
                if (context.mounted && snackBarShown == false) {
                  snackBarShown = true;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackbarFunction(
                          'nastala chyba při rušení objednávky: $e'))
                      .closed
                      .then((SnackBarClosedReason reason) {
                    snackBarShown = false;
                  });
                }
              }
            }
            break;
          case StavJidla.naBurze:
            {
              Canteen canteen = await initCanteen();
              try {
                canteen.doBurzy(jidlo!);
                //není potřeba restartCanteen, protože se nedějí změny kreditu
              } catch (e) {
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                // toto je upozornění dole (Snackbar)
                // snackbarshown je aby se snackbar nezobrazil vícekrát
                if (context.mounted && snackBarShown == false) {
                  snackBarShown = true;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackbarFunction(
                          'nastala chyba při dávání jídla na burzu: $e'))
                      .closed
                      .then((SnackBarClosedReason reason) {
                    snackBarShown = false;
                  });
                }
              }
            }
            break;
        }
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(obedText),
        icon == null ? const Icon(null) : icon!,
      ]),
    );
  }
}
