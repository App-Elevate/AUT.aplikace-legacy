import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/cupertino.dart';

import '../methods/icanteen.dart';
import './all.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({
    super.key,
    required this.setHomeWidget,
  });
  final Function setHomeWidget;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Center(child: Text('Autojídelna Přihlášeno')),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                    value: 'logout',
                    child: const Text('Odhlásit se'),
                    onTap: () {
                      logout();
                      setHomeWidget(LoginScreen(
                        setHomeWidget: setHomeWidget,
                      ));
                      //to be implemented
                    }),
              ];
            }),
          ]),
      body: JidelnicekDenWidget(),
      drawer: MainAppDrawer(
        setHomeWidget: setHomeWidget,
      ),
    );
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
  });

  final DateTime currentDate = DateTime.now();
  final ValueNotifier<DateTime> dateListener =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<CanteenData> canteenDataListener =
      ValueNotifier<CanteenData>(getCanteenData());
  final PageController pageviewController = PageController(
      initialPage: DateTime.now().difference(DateTime(2006, 5, 23)).inDays);
  final DateTime minimalDate = DateTime(2006, 5, 23);
  final CanteenData canteenData = getCanteenData();

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
    } else if (newDate != null) {
      preIndexLunches(newDate, 7).then((_) =>
          preIndexLunches(newDate!.subtract(const Duration(days: 7)), 7));
      dateListener.value = newDate;
      pageviewController.jumpToPage(newDate.difference(minimalDate).inDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    //bool isWeekend = dayOfWeek == 'Sobota' || dayOfWeek == 'Neděle'; //to be implemented...

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
                  widget: widget,
                  errorWidget: HtmlWidget(snapshot.error.toString()));
            }
            Jidelnicek jidelnicek = snapshot.data as Jidelnicek;
            return ListJidel(
              jidelnicek: jidelnicek,
              widget: widget,
            );
          }),
    );
  }
}

class ListJidel extends StatelessWidget {
  final Jidelnicek? jidelnicek;
  final JidelnicekDenWidget widget;
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
  @override
  Widget build(BuildContext context) {
    String obedText;
    final index = widget.index;
    Jidelnicek jidelnicek = widget.widget.jidelnicek!;
    jidlo ??= jidelnicek.jidla[index];
    if (jidelnicek.jidla[index].objednano) {
      obedText =
          'Objednáno ${jidelnicek.jidla[index].varianta} za ${jidelnicek.jidla[index].cena} Kč';
    }
    if (!widget.widget.jidelnicek!.jidla[widget.index].lzeObjednat) {
      obedText =
          'nelze objednat ${jidelnicek.jidla[index].varianta} za ${jidelnicek.jidla[index].cena} Kč';
    } else {
      obedText =
          'Objednat ${jidelnicek.jidla[index].varianta} za ${jidelnicek.jidla[index].cena} Kč';
    }

    SnackBar snackbarFunction(String snackBarText) {
      return SnackBar(
        content:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(snackBarText),
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

    if (jidlo!.objednano) {
      buttonColor ??= const Color.fromRGBO(17, 201, 11, 1);
      if (!jidlo!.lzeObjednat) {
        icon ??= const Icon(
          Icons.block,
          color: Color.fromRGBO(0, 0, 0, 1),
        );
      }
    } else if (jidlo!.lzeObjednat) {
      buttonColor ??= const Color.fromRGBO(173, 165, 52, 1);
    } else {
      //pokud jidlo nelze objednat
      buttonColor ??= const Color.fromARGB(255, 247, 75, 75);
      icon ??= const Icon(
        Icons.block,
        color: Color.fromRGBO(0, 0, 0, 1),
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
        Canteen canteen = await initCanteen();
        if (!jidlo!.lzeObjednat) {
          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          // toto je upozornění dole a zároveň proto aby se snackbar nezobrazil vícekrát
          if (context.mounted && snackBarShown == false) {
            snackBarShown = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(snackbarFunction(jidlo!.objednano
                    ? 'Jídlo nelze zrušit'
                    : 'Jídlo nelze objednat'))
                .closed
                .then((SnackBarClosedReason reason) {
              snackBarShown = false;
            });
          }
          setState(() {
            icon = const Icon(
              Icons.block,
              color: Color.fromRGBO(0, 0, 0, 1),
            );
          });
          return;
        }
        try {
          canteenData.jidelnicky[jidelnicek.den]!.jidla[index] =
              await canteen.objednat(jidelnicek.jidla[index]);
          widget.widget.widget.restartCanteen();
        } catch (e) {
          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          // toto je upozornění dole a zároveň proto aby se snackbar nezobrazil vícekrát
          if (context.mounted && snackBarShown == false) {
            snackBarShown = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(
                    snackbarFunction('nastala chyba při obejnávání jídla: $e'))
                .closed
                .then((SnackBarClosedReason reason) {
              snackBarShown = false;
            });
          }
          setState(() {
            icon = const Icon(
              Icons.block,
              color: Color.fromRGBO(0, 0, 0, 1),
            );
          });
          return;
        }
        widget.widget.widget.restartCanteen();
        setState(() {
          buttonColor = null;
          icon = null;
          jidlo = canteenData.jidelnicky[jidelnicek.den]!.jidla[index];
        });
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(obedText),
        icon == null ? const Icon(null) : icon!,
      ]),
    );
  }
}
