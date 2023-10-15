//other imports from current project

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import "every_import.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

FirebaseAnalytics? analytics;
bool analyticsEnabledGlobally = false;
@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "kredit-checker-je-jidlo-objednano-checker":
        try {
          LoginData loginData = await getLoginDataFromSecureStorage();
          for (int i = 0; i < loginData.users.length; i++) {
            Canteen canteenInstance = await initCanteen(
                hasToBeNew: true,
                username: loginData.users[i].username,
                password: loginData.users[i].password,
                url: loginData.users[i].url,
                doIndexing: false);
            Uzivatel uzivatel = await canteenInstance.ziskejUzivatele();
            //7 is limit for how many lunches we are gonna search for
            int objednano = 0;
            int cena = 0;
            for (int denIndex = 0; denIndex < 10; denIndex++) {
              Jidelnicek jidelnicek = await canteenInstance.jidelnicekDen(den: DateTime.now().add(Duration(days: denIndex)));
              //pokud nalezneme jídlo s cenou
              if (jidelnicek.jidla.isNotEmpty && !(jidelnicek.jidla[0].cena?.isNaN ?? true)) {
                cena += jidelnicek.jidla[0].cena!.toInt();
              }
              if (jidelnicek.jidla.isEmpty) {
                objednano++;
                continue;
              }
              for (int jidloIndex = 0; jidloIndex < jidelnicek.jidla.length; jidloIndex++) {
                if (jidelnicek.jidla[jidloIndex].objednano) {
                  objednano++;
                }
              }
            }
            if (cena != 0 && uzivatel.kredit < cena) {
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                id: 10,
                channelKey: 'kredit_channel',
                actionType: ActionType.Default,
                title: 'Dochází vám kredit!',
                body: 'Kredit pro ${uzivatel.jmeno} ${uzivatel.prijmeni}: ${uzivatel.kredit.toInt()} kč',
              ));
            }
            //pokud chybí aspoň 3 obědy z příštích 10 dní
            if (objednano <= 7) {
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                id: 10,
                channelKey: 'objednano_channel',
                actionType: ActionType.Default,
                title: 'Objednejte si na příští týden',
                body: 'Uživatel ${uzivatel.jmeno} ${uzivatel.prijmeni} si stále ještě neobjednal jídlo na příští týden',
              ));
            }
          }
          return Future.value(true);
        } catch (e) {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
            id: 10,
            channelKey: 'kredit_channel',
            actionType: ActionType.Default,
            title: 'Nastala Chyba',
            body: e.toString(),
          ));
        }
      default:
        return Future.value(true);
    }
    return Future.value(true);
  });
}

@pragma('vm:entry-point')
void doVerification() async {
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
          channelGroupKey: 'kredit_channel_group',
          channelKey: 'kredit_channel',
          channelName: 'Kredit',
          channelDescription: 'Notifikace označující docházející kredit',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white),
      NotificationChannel(
          channelGroupKey: 'objednano_channel_group',
          channelKey: 'objednano_channel',
          channelName: 'Objednáno?',
          channelDescription: 'Notifikace upozorňující na to, abyste si objednal jídlo na příští týden',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white),
    ],
    // Channel groups are only visual and are not required
    debug: kDebugMode,
  );
  try {
    LoginData loginData = await getLoginDataFromSecureStorage();
    for (int i = 0; i < loginData.users.length; i++) {
      Canteen canteenInstance = await initCanteen(
          hasToBeNew: true,
          username: loginData.users[i].username,
          password: loginData.users[i].password,
          url: loginData.users[i].url,
          doIndexing: false);
      Uzivatel uzivatel = await canteenInstance.ziskejUzivatele();
      //7 is limit for how many lunches we are gonna search for
      int objednano = 0;
      int cena = 0;
      for (int denIndex = 0; denIndex < 10; denIndex++) {
        Jidelnicek jidelnicek = await canteenInstance.jidelnicekDen(den: DateTime.now().add(Duration(days: denIndex)));
        //pokud nalezneme jídlo s cenou
        if (jidelnicek.jidla.isNotEmpty && !(jidelnicek.jidla[0].cena?.isNaN ?? true)) {
          cena += jidelnicek.jidla[0].cena!.toInt();
        }
        if (jidelnicek.jidla.isEmpty) {
          objednano++;
          continue;
        }
        for (int jidloIndex = 0; jidloIndex < jidelnicek.jidla.length; jidloIndex++) {
          if (jidelnicek.jidla[jidloIndex].objednano) {
            objednano++;
          }
        }
      }
      if (cena != 0 && uzivatel.kredit < cena) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: 10,
          channelKey: 'kredit_channel',
          actionType: ActionType.Default,
          title: 'Dochází vám kredit!',
          body: 'Kredit pro ${uzivatel.jmeno} ${uzivatel.prijmeni}: ${uzivatel.kredit.toInt()} kč',
        ));
      }
      //pokud chybí aspoň 3 obědy z příštích 10 dní
      if (objednano <= 7) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: 10,
          channelKey: 'objednano_channel',
          actionType: ActionType.Default,
          title: 'Objednejte si na příští týden',
          body: 'Uživatel ${uzivatel.jmeno} ${uzivatel.prijmeni} si stále ještě neobjednal jídlo na příští týden',
        ));
      }
    }
  } catch (e) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'kredit_channel',
      actionType: ActionType.Default,
      title: 'Nastala Chyba',
      body: e.toString(),
    ));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
          channelGroupKey: 'kredit_channel_group',
          channelKey: 'kredit_channel',
          channelName: 'Kredit',
          channelDescription: 'Notifikace označující docházející kredit',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white),
      NotificationChannel(
          channelGroupKey: 'objednano_channel_group',
          channelKey: 'objednano_channel',
          channelName: 'Objednáno?',
          channelDescription: 'Notifikace upozorňující na to, abyste si objednal jídlo na příští týden',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white),
    ],
    // Channel groups are only visual and are not required
    debug: kDebugMode,
  );
  String? analyticsDisabled = await readData('disableAnalytics');
  // know if this release is debug
  if (kDebugMode) {
    analyticsDisabled = '1';
  }

  if (analyticsDisabled != '1') {
    analyticsEnabledGlobally = true;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    analytics = FirebaseAnalytics.instance;
  }
  runApp(const MyApp()); // Create an instance of MyApp and pass it to runApp.
  const int helloAlarmID = 0;
  if (Platform.isAndroid) {
    // TODO: implement background_fetch - https://pub.dev/packages/background_fetch package instead
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(const Duration(days: 1), helloAlarmID, doVerification);
  } else if (Platform.isIOS) {
    Workmanager().initialize(callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode: kDebugMode // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );

    Workmanager().registerOneOffTask("task-identifier", "kredit-checker-je-jidlo-objednano-checker",
        initialDelay: const Duration(days: 7), //duration before showing the notification
        constraints: Constraints(
          networkType: NetworkType.connected,
        ));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _myAppKey = GlobalKey<NavigatorState>();
  Future<bool> _backPressed(GlobalKey<NavigatorState> yourKey) async {
    //Checks if current Navigator still has screens on the stack.
    if (yourKey.currentState!.canPop()) {
      // 'maybePop' method handles the decision of 'pop' to another WillPopScope if they exist.
      //If no other WillPopScope exists, it returns true
      yourKey.currentState!.maybePop();
      return Future<bool>.value(false);
    }
    //if nothing remains in the stack, it simply pops
    return Future<bool>.value(true);
  }

  void setHomeWidget(Widget widget) {
    setState(() {
      homeWidget = widget;
    });
  }

  late Widget homeWidget;
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod);
    homeWidget = LoggingInWidget(setHomeWidget: setHomeWidget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getLatestRelease();
    var pop = WillPopScope(
      onWillPop: () => _backPressed(_myAppKey),
      child: Navigator(
        key: _myAppKey,
        pages: [
          MaterialPage(child: homeWidget),
        ],
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      ),
    );
    return FutureBuilder(
      future: readData("ThemeMode"),
      initialData: ThemeMode.system,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == "2") {
            NotifyTheme().setTheme(ThemeMode.dark);
          } else if (snapshot.data == "1") {
            NotifyTheme().setTheme(ThemeMode.light);
          } else {
            NotifyTheme().setTheme(ThemeMode.system);
          }
        }
        return ValueListenableBuilder(
          valueListenable: NotifyTheme().themeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Themes.getTheme(ColorSchemes.light),
              darkTheme: Themes.getTheme(ColorSchemes.dark),
              themeMode: themeMode,
              home: child,
            );
          },
          child: pop,
        );
      },
    );
  }
}

class LoggingInWidget extends StatelessWidget {
  const LoggingInWidget({
    super.key,
    required this.setHomeWidget,
  });

  final Function(Widget widget) setHomeWidget;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLoginDataFromSecureStorage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final loginData = snapshot.data as LoginData;
          final isLoggedIn = loginData.currentlyLoggedIn;
          if (isLoggedIn) {
            return FutureBuilder(
              future: initCanteen(hasToBeNew: true),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  if (snapshot.error == 'no internet') {
                    Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Nemáte připojení k internetu', setHomeWidget));
                  } else if (snapshot.error == 'login failed') {
                    Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Přihlášení selhalo', setHomeWidget));
                  } else if (snapshot.error == 'bad url') {
                    Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Nemáte připojení k internetu', setHomeWidget));
                  } else {
                    return LoginScreen(setHomeWidget: setHomeWidget);
                  }
                  return const LoadingLoginPage(textWidget: Text('Přihlašování'));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  Future.delayed(Duration.zero, () => newUpdateDialog(context));
                  return MainAppScreen(setHomeWidget: setHomeWidget);
                } else {
                  return const LoadingLoginPage(textWidget: Text('Přihlašování'));
                }
              },
            );
          } else {
            return LoginScreen(
              setHomeWidget: setHomeWidget,
            );
          }
        } else {
          return const LoadingLoginPage(textWidget: null);
        }
      },
    );
  }
}

class LoadingLoginPage extends StatelessWidget {
  const LoadingLoginPage({
    super.key,
    required this.textWidget,
  });
  final Widget? textWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
