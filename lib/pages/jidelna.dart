// The main page. This is what user sees once he is logged in

import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/local_imports.dart';

import 'package:background_fetch/background_fetch.dart';

import 'package:canteenlib/canteenlib.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../shared_widgets/jidlo_widget.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(snackbarFunction(lang.errorsUpdatingData)).closed.then((SnackBarClosedReason reason) {
          snackbarshown.shown = false;
        });
      }
    }
    setScaffoldBody(MainAppScreenState().jidelnicekWidget());
  }

  @override
  initState() {
    loggedInCanteen.readData(Prefs.firstTime).then((value) {
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
      loggedInCanteen.saveData(Prefs.firstTime, '1');
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
    return SlidingUpPanel(
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
          title: Text(lang.appName),
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
                widget.setHomeWidget(LoggingInWidget(/*setHomeWidget: widget.setHomeWidget, */ pageIndex: pageviewController.page!.round().toInt()));
              },
            ),
          ],
        ),
        body: scaffoldBody,
        drawer: Builder(
          builder: (context) {
            return MainAccountDrawer(
              setHomeWidget: widget.setHomeWidget,
              page: NavigationDrawerItem.jidelnicek,
            );
          },
        ),
      ),
    );
  }

  ///widget for the Jidelnicek including the date picker with all the lunches
  Builder jidelnicekWidget() {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            //toolbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //open calendar button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(MediaQuery.sizeOf(context).width * .5, 45),
                      side: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant, width: 1.75),
                    ),
                    onPressed: () async => await CustomDatePicker().showDatePicker(context, dateListener.value),
                    icon: const Icon(Icons.calendar_today_rounded, size: 27.5),
                    label: ValueListenableBuilder(
                      valueListenable: dateListener,
                      builder: (ctx, value, child) {
                        DateTime currentDate = value;
                        String dayOfWeek = loggedInCanteen.ziskatDenZData(currentDate.weekday);
                        return Text("${currentDate.day}. ${currentDate.month} - $dayOfWeek");
                      },
                    ),
                  ),
                  /*MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 0,
                    textColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      DateTime currentDate = dateListener.value;
                      var datePicked = await CustomDatePicker().showDatePicker(context, currentDate);
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
                            //day before button
                            MaterialButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              minWidth: 0,
                              textColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              onPressed: () {
                                changeDate(daysChange: -1);
                              },
                              child: const Icon(Icons.arrow_left),
                            ),
                            TextButton(
                              style: Theme.of(context).textButtonTheme.style?.copyWith(
                                    foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                                  ),
                              onPressed: () async {
                                var datePicked = await CustomDatePicker().showDatePicker(context, currentDate);
                                if (datePicked == null) return;
                                changeDate(newDate: datePicked, animateToPage: true);
                              },
                              child: SizedBox(
                                //relative to the width of the viewport
                                width: MediaQuery.sizeOf(context).width * 0.35,
                                child: Center(child: Text("${currentDate.day}. ${currentDate.month}. - $dayOfWeek")),
                              ),
                            ),
                            //next day button
                            MaterialButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              minWidth: 0,
                              textColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                  */
                  //go to today button
                  MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 0,
                    height: 27.5,
                    textColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(12.5),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
        );
      },
    );
  }

  ///widget for the Jidelnicek for the day - mainly the getting lunches logic
  Builder jidelnicekDenWidget(int index) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: FutureBuilder(
            future: loggedInCanteen.getLunchesForDay(convertIndexToDatetime(index)),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await portableSoftRefresh(context);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                              lang.errorsLoadingData,
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
  final ValueNotifier<bool> ordering = ValueNotifier<bool>(false);
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
    Future.delayed(const Duration(milliseconds: 50)).then(
      (value) async {
        if (indexJidlaCoMaBytZobrazeno != null && indexJidlaCoMaBytZobrazeno == indexDne) {
          await MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => JidloDetail(
                ordering: ordering,
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
      },
    );
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
                  ScaffoldMessenger.of(context).showSnackBar(snackbarFunction(lang.errorsUpdatingData)).closed.then(
                    (SnackBarClosedReason reason) {
                      snackbarshown.shown = false;
                    },
                  );
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
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).height / 2 - 100),
                        child: Text(lang.noFood),
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
                    return JidloWidget(
                      ordering: ordering,
                      indexDne: indexDne,
                      portableSoftRefresh: portableSoftRefresh,
                      jidelnicekListener: jidelnicekListener,
                      index: index,
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
