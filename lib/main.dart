//other imports from current project

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
Future<bool> initAwesome() async {
  LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
  List<NotificationChannelGroup> notificationChannelGroups = [];
  List<NotificationChannel> notificationChannels = [];
  for (int i = 0; i < loginData.users.length; i++) {
    LoggedInUser user = loginData.users[i];
    notificationChannelGroups.add(
      NotificationChannelGroup(
        channelGroupKey: 'channel_group_${user.username}',
        channelGroupName: 'Notifikace pro ${user.username}',
      ),
    );
    notificationChannels.add(
      NotificationChannel(
        channelGroupKey: 'channel_group_${user.username}',
        channelKey: 'kredit_channel_${user.username}',
        channelName: 'Docházející kredit',
        channelDescription: 'Notifikace o tom, zda vám dochází kredit týden dopředu pro ${user.username}',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    );
    notificationChannels.add(
      NotificationChannel(
        channelGroupKey: 'channel_group_${user.username}',
        channelKey: 'objednano_channel_${user.username}',
        channelName: 'Objednáno?',
        channelDescription: 'Notifikace týden dopředu o tom, zda jste si objednal jídlo na příští týden pro ${user.username}',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    );
  }
  notificationChannelGroups.add(
    NotificationChannelGroup(
      channelGroupKey: 'channel_group_else',
      channelGroupName: 'Ostatní',
    ),
  );
  notificationChannels.add(
    NotificationChannel(
      channelKey: 'else_channel',
      channelName: 'Ostatní',
      channelDescription: 'Ostatní notifikace, např. chybové hlášky...',
      defaultColor: const Color(0xFF9D50DD),
      ledColor: Colors.red,
    ),
  );
  return await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    notificationChannels,
    channelGroups: notificationChannelGroups,
    // Channel groups are only visual and are not required
    debug: kDebugMode,
  );
}

Future<void> doNotifications() async {
  LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
  for (int i = 0; i < loginData.users.length; i++) {
    try {
      loggedInCanteen.changeAccount(i);
      Uzivatel uzivatel = (await loggedInCanteen.canteenData).uzivatel;
      //7 is limit for how many lunches we are gonna search for
      int objednano = 0;
      int cena = 0;
      for (int denIndex = 0; denIndex < 10; denIndex++) {
        Jidelnicek jidelnicek = await (await loggedInCanteen.canteenInstance).jidelnicekDen(den: DateTime.now().add(Duration(days: denIndex)));
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
          id: 255 - i,
          channelKey: 'kredit_channel_${loginData.users[i].username}',
          actionType: ActionType.Default,
          title: 'Dochází vám kredit!',
          body: 'Kredit pro ${uzivatel.jmeno} ${uzivatel.prijmeni}: ${uzivatel.kredit.toInt()} kč',
        ));
      }
      //pokud chybí aspoň 3 obědy z příštích 10 dní
      if (objednano <= 7) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: i,
          channelKey: 'objednano_channel_${loginData.users[i].username}',
          actionType: ActionType.Default,
          title: 'Objednejte si na příští týden',
          body: 'Uživatel ${uzivatel.jmeno} ${uzivatel.prijmeni} si stále ještě neobjednal jídlo na příští týden',
        ));
      }
    } catch (e) {
      //do nothing
    }
  }
}

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "kredit-checker-je-jidlo-objednano-checker":
        try {
          await doNotifications();
          return Future.value(true);
        } catch (e) {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
            id: 10,
            channelKey: 'else_channel',
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
  try {
    doNotifications();
  } catch (e) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'else_channel',
      actionType: ActionType.Default,
      title: 'Nastala Chyba',
      body: e.toString(),
    ));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAwesome();
  String? analyticsDisabled = await loggedInCanteen.readData('disableAnalytics');
  //get the version of the app
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  //check if the version is the same as the last one
  String? lastVersion = await loggedInCanteen.readData('lastVersion');
  if (lastVersion != version) {
    //if not, set the new version as the last one
    loggedInCanteen.saveData('lastVersion', version);
    await AwesomeNotifications().dispose();
    initAwesome();
  }
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
    AndroidAlarmManager.cancel(helloAlarmID);
    await AndroidAlarmManager.periodic(const Duration(days: 1), helloAlarmID, doVerification);
  } else if (Platform.isIOS) {
    Workmanager().initialize(callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode: kDebugMode // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().cancelAll();
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
      future: loggedInCanteen.readData("ThemeMode"),
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
      future: loggedInCanteen.loginFromStorage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error == 'no login') {
            return LoginScreen(setHomeWidget: setHomeWidget);
          }
          if (snapshot.error == 'bad url or connection') {
            Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Nemáte připojení k internetu', setHomeWidget));
          } else if (snapshot.error == 'Špatné heslo') {
            Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Špatné přihlašovací údaje', setHomeWidget));
          } else {
            Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Nemáte připojení k internetu', setHomeWidget));
          }
          return const LoadingLoginPage(textWidget: Text('Přihlašování'));
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
          try {
            changeDate(newDate: DateTime.now());
          } catch (e) {
            //do nothing
          }
          Future.delayed(Duration.zero, () => newUpdateDialog(context));
          return MainAppScreen(setHomeWidget: setHomeWidget);
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == false) {
          //test internet connection
          InternetConnectionChecker().hasConnection.then((value) {
            if (value) {
              Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Špatné přihlašovací údaje', setHomeWidget));
              return;
            }
            Future.delayed(Duration.zero, () => failedLoginDialog(context, 'Nemáte připojení k internetu', setHomeWidget));
          });
          return const LoadingLoginPage(textWidget: Text('Přihlašování'));
        } else {
          return const LoadingLoginPage(textWidget: Text('Přihlašování'));
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
