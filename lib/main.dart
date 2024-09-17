// Purpose: Main file of the app, contains the main function and the main widget of the app as well as the loading screen on startup

import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/lang/output/texts.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/methods_vars/app.dart';
import 'package:autojidelna/pages_new/login.dart';
import 'package:autojidelna/pages_new/navigation.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_prefs.dart';

// Foundation for kDebugMode
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Toast for exiting the app
import 'package:fluttertoast/fluttertoast.dart';

import 'package:package_info_plus/package_info_plus.dart';

// Notifications
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

void main() async {
  // Ensure that the app is initialized
  WidgetsFlutterBinding.ensureInitialized();

  await App.initHive();

  // Awesome notifications initialization
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String? lastVersion = await readStringFromSharedPreferences(Prefs.lastVersion);

  // Removing the already set notifications if we updated versions
  if (lastVersion != version) {
    // Set the new version
    saveStringToSharedPreferences(Prefs.lastVersion, version);

    try {
      LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
      for (LoggedInUser uzivatel in loginData.users) {
        List<String> prefs = [
          Prefs.dailyFoodInfo,
          Prefs.foodNotifTime,
          Prefs.kreditNotifications,
          Prefs.lastJidloDneCheck,
          Prefs.lastNotificationCheck,
          Prefs.nemateObjednanoNotifications
        ];
        for (String pref in prefs) {
          await readStringFromSharedPreferences(pref + uzivatel.username).then((value) {
            if (value != null) {
              saveStringToSharedPreferences('$pref${uzivatel.username}_${uzivatel.url}', value);
              removeFromSharedPreferences(pref + uzivatel.username);
            }
          });
        }
        AwesomeNotifications().removeChannel('${NotificationIds.kreditChannel}${uzivatel.username}_${uzivatel.url}');
        await AwesomeNotifications().removeChannel('${NotificationIds.objednanoChannel}${uzivatel.username}_${uzivatel.url}');
      }
    } catch (e) {
      //do nothing
    }
    await AwesomeNotifications().dispose();
  }

  // Initialize the notifications
  initAwesome();

  // Setting listeners for when the app is running and notification button is clicked
  AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod);

  // Detecting if the app was opened from a notification and handling it if it was
  ReceivedAction? receivedAction = await AwesomeNotifications().getInitialNotificationAction(removeFromActionEvents: false);
  await NotificationController.handleNotificationAction(receivedAction);

  // Initializing the background fetch
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  // Check if user has opped out of analytics

  bool? analyticsDisabled = Settings().disableAnalytics;

  // Initializing firebase if analytics are not disabled
  if (analyticsDisabled != true || !kDebugMode) {
    analyticsEnabledGlobally = true;
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Setting up crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    analytics = FirebaseAnalytics.instance;
  }

  // Loading settings from preferences
  skipWeekends = Settings().getSkipWeekends;

  hideBurzaAlertDialog = await readBoolFromSharedPreferences(SharedPrefsKeys.hideBurzaAlertDialog) ?? false;

  // Skipping to next monday if we are currently on saturday or sunday
  // If not initializing normally
  if (skipWeekends) {
    DateTime initialDate = DateTime.now();
    while (initialDate.isWeekend) {
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
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

// ValueNotifier for the back button

class _MyAppState extends State<MyApp> {
  // Key for the navigator
  final GlobalKey<NavigatorState> _myAppKey = GlobalKey<NavigatorState>();

  ValueNotifier<bool> canExit = ValueNotifier<bool>(false);

  // Handling the back button on android being pressed.
  Future<bool> _backPressed(GlobalKey<NavigatorState> yourKey) async {
    // Checks if current Navigator still has screens on the stack.
    // And doesn't exit the app if it does
    if (yourKey.currentState!.canPop()) {
      yourKey.currentState!.pop();
      // 'maybePop' method handles the decision of 'pop' to another WillPopScope if they exist.
      // If no other WillPopScope exists, it returns true
      return Future<bool>.value(false);
    }
    // If the current Navigator doesn't have any screens on the stack, it exits the app or shows a toast
    // setting the value to true so that the user can press the back button again and it exits this time
    canExit.value = true;
    // 5 second timer for the user to press the back button again.
    // After it expires the timer resets and user has to press back button twice again
    Future.delayed(const Duration(seconds: 5), () => canExit.value = false);
    Fluttertoast.showToast(
        msg: lang.toastExit,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // Setting up providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Settings>(create: (_) => Settings()),
        ChangeNotifierProvider<NotificationPreferences>(create: (_) => NotificationPreferences()),
        ChangeNotifierProvider<Ordering>(create: (_) => Ordering()),
        ChangeNotifierProvider<DishesOfTheDay>(create: (_) => DishesOfTheDay())
      ],
      builder: (context, __) {
        // Rebuilds when themeMode, themeStyle or isPureBlack is changed
        return Selector<Settings, ({ThemeMode mode, ThemeStyle style, bool isPureBlack})>(
          selector: (_, userPrefs) => (mode: userPrefs.themeMode, style: userPrefs.themeStyle, isPureBlack: userPrefs.isPureBlack),
          builder: (context, theme, ___) {
            return MaterialApp(
              localizationsDelegates: Texts.localizationsDelegates,
              supportedLocales: Texts.supportedLocales,
              localeResolutionCallback: (locale, supportedLocales) {
                if (supportedLocales.contains(locale)) return locale;
                // default language
                return const Locale('cs', 'CZ');
              },
              navigatorKey: MyApp.navigatorKey,
              debugShowCheckedModeBanner: false,
              //debugShowMaterialGrid: true,
              theme: Themes.getTheme(theme.style),
              darkTheme: Themes.getTheme(theme.style, isPureBlack: theme.isPureBlack),
              themeMode: theme.mode,
              home: const LoggingInWidget(),
              title: "Autojídelna",
            );
          },
        );
      },
      child: _pop(),
    );
  }

  ValueListenableBuilder _pop() {
    return ValueListenableBuilder(
      valueListenable: canExit,
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
        pages: const [MaterialPage(child: LoggingInWidget())],
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      ),
    );
  }
}

class LoggingInWidget extends StatelessWidget {
  const LoggingInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
    context.read<DishesOfTheDay>().resetMenu();

    // získání dat z secure storage a následné přihlášení
    return FutureBuilder(
      future: loggedInCanteen.runWithSafety(loggedInCanteen.loginFromStorage()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error == ConnectionErrors.noLogin) return LoginScreen();
        } else if (snapshot.connectionState == ConnectionState.done) {
          // routing to main app screen (jidelnicek)
          return const NavigationScreen();
        }
        return Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
