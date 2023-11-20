//other imports from current project

import 'package:flutter/foundation.dart';
//import 'package:workmanager/workmanager.dart';
import "every_import.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

void main() async {
  //ensure that the app is initialized
  WidgetsFlutterBinding.ensureInitialized();

  //awesome notifications initialization
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String? lastVersion = await loggedInCanteen.readData('lastVersion');

  /// removing the already set notifications if we updated versions
  if (lastVersion != version) {
    //if not, set the new version as the last one
    loggedInCanteen.saveData('lastVersion', version);
    try {
      LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
      for (LoggedInUser uzivatel in loginData.users) {
        AwesomeNotifications().removeChannel('kredit_channel_${uzivatel.username}');
        await AwesomeNotifications().removeChannel('objednano_channel_${uzivatel.username}');
      }
    } catch (e) {
      //do nothing
    }
    await AwesomeNotifications().dispose();
  }
  initAwesome();

  //setting listeners for when the app is running
  AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod);

  // detecting if the app was opened from a notification and handling it if it was
  ReceivedAction? receivedAction = await AwesomeNotifications().getInitialNotificationAction(removeFromActionEvents: false);
  await handleNotificationAction(receivedAction);

  //initializing the background fetch
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  //check if user has opped out of analytics
  String? analyticsDisabled = await loggedInCanteen.readData('disableAnalytics');
  // know if this release is debug and disable analytics if it is
  if (kDebugMode) {
    analyticsDisabled = '1';
  }

  //initializing firebase if analytics are not disabled
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

  // setting important settings from prefs
  skipWeekends = await loggedInCanteen.readData('skipWeekends') == '1' ? true : false;
  if (skipWeekends) {
    DateTime initialDate = DateTime.now();
    while (initialDate.weekday == 6 || initialDate.weekday == 7) {
      initialDate = initialDate.add(const Duration(days: 1));
    }
    int index = initialDate.difference(minimalDate).inDays;
    pageviewController = PageController(initialPage: index);
    dateListener = ValueNotifier<DateTime>(convertIndexToDatetime(index));
  } else {
    pageviewController = PageController(initialPage: DateTime.now().difference(minimalDate).inDays);
    dateListener = ValueNotifier<DateTime>(convertIndexToDatetime(DateTime.now().difference(minimalDate).inDays));
  }

  runApp(const MyApp()); // Create an instance of MyApp and pass it to runApp.
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _myAppKey = GlobalKey<NavigatorState>();
  Future<bool> _backPressed(GlobalKey<NavigatorState> yourKey) async {
    if (SwitchAccountVisible().isVisible()) {
      SwitchAccountVisible().setVisible(false);
      return Future<bool>.value(false);
    }
    //Checks if current Navigator still has screens on the stack.
    if (yourKey.currentState!.canPop()) {
      // 'maybePop' method handles the decision of 'pop' to another WillPopScope if they exist.
      //If no other WillPopScope exists, it returns true
      yourKey.currentState!.maybePop();
      return Future<bool>.value(false);
    }
    canpop.value = true;
    Future.delayed(const Duration(seconds: 5), () => canpop.value = false);
    Fluttertoast.showToast(
        msg: "Zmáčkněte tlačítko zpět pro ukončení aplikace",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
    return Future<bool>.value(true);
  }

  void setHomeWidget(Widget widget) {
    Navigator.of(_myAppKey.currentContext!).popUntil((route) => route.isFirst);
    setState(() {
      homeWidget = widget;
    });
  }

  late Widget homeWidget;
  @override
  void initState() {
    getLatestRelease();
    setHomeWidgetPublic = setHomeWidget;
    // Only after at least the action method is set, the notification events are delivered
    homeWidget = LoggingInWidget(setHomeWidget: setHomeWidget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              navigatorKey: MyApp.navigatorKey,
              debugShowCheckedModeBanner: false,
              //debugShowMaterialGrid: true,
              theme: Themes.getTheme(ColorSchemes.light),
              darkTheme: Themes.getTheme(ColorSchemes.dark),
              themeMode: themeMode,
              home: child,
            );
          },
          child: _pop(),
        );
      },
    );
  }

  ValueNotifier<bool> canpop = ValueNotifier<bool>(false);

  ValueListenableBuilder _pop() {
    return ValueListenableBuilder(
        valueListenable: canpop,
        builder: (context, value, child) {
          return PopScope(
            canPop: value,
            onPopInvoked: (_) async {
              await _backPressed(_myAppKey);
            },
            child: child!,
          );
        },
        child: Navigator(
          key: _myAppKey,
          pages: [
            MaterialPage(child: homeWidget),
          ],
          onPopPage: (route, result) {
            return route.didPop(result);
          },
        ));
  }
}

class LoggingInWidget extends StatelessWidget {
  const LoggingInWidget({
    super.key,
    required this.setHomeWidget,
    this.index = -1,
  });
  final int index;

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
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data!.success == true) {
          if (index != -1) {
            try {
              Future.delayed(Duration.zero, () => changeDateTillSuccess(index));
            } catch (e) {
              //do nothing
            }
          } else {
            try {
              setCurrentDate();
            } catch (e) {
              //do nothing
            }
          }
          Future.delayed(Duration.zero, () => newUpdateDialog(context));
          return MainAppScreen(setHomeWidget: setHomeWidget);
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data?.success == false) {
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
