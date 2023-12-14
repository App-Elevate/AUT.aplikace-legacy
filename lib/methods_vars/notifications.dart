// File containing all code for notifications. This includes background fetch and awesome notifications.

import 'package:autojidelna/local_imports.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initPlatformState() async {
  // Configure BackgroundFetch.
  await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 120,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        startOnBoot: true,
        requiredNetworkType: NetworkType.ANY,
      ), (String taskId) async {
    // <-- Event handler
    // This is the fetch-event callback.
    if (kDebugMode) {
      print("[BackgroundFetch] Event received $taskId");
    }
    // IMPORTANT:  You must signal completion of your task or the OS can punish your app
    // for taking too long in the background.
    await doNotifications();
    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    // <-- Task timeout handler.
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    if (kDebugMode) {
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
    }
    BackgroundFetch.finish(taskId);
  });

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
}

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    if (kDebugMode) {
      print("[BackgroundFetch] Headless task timed-out: $taskId");
    }
    BackgroundFetch.finish(taskId);
    return;
  }
  if (kDebugMode) {
    print('[BackgroundFetch] Headless event received.');
  }
  await doNotifications();
  BackgroundFetch.finish(taskId);
}

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
        channelKey: 'jidlo_channel_${user.username}',
        channelName: 'Dnešní jídlo',
        channelShowBadge: true,
        channelDescription: 'Notifikace každý den o tom jaké je dnes jídlo pro ${user.username}',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    );
    notificationChannels.add(
      NotificationChannel(
        channelGroupKey: 'channel_group_${user.username}',
        channelKey: 'kredit_channel_${user.username}',
        channelName: 'Docházející kredit',
        channelShowBadge: true,
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
        channelShowBadge: true,
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
      importance: NotificationImportance.Min,
      playSound: false,
    ),
  );
  return await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,

    notificationChannels,

    channelGroups: notificationChannelGroups,
    // Channel groups are only visual and are not required
    debug: false,
  );
}

Future<void> doNotifications({bool force = false}) async {
  LoggedInCanteen loggedInCanteen = LoggedInCanteen();
  LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 588,
    locked: true,
    channelKey: 'else_channel',
    actionType: ActionType.Default,
    title: 'Získávám data pro notifikace...',
  ));
  // Don't send notifications before 9 and after 22
  for (int i = 0; i < loginData.users.length && !((DateTime.now().hour < 9 || DateTime.now().hour > 22) && !force); i++) {
    //ensuring we only send the notifications once a day
    bool jidloDne = true;
    bool kredit = true;
    bool objednavka = true;
    DateTime now = DateTime.now();
    String nowString = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    String? timeOfDayFoodNotification = await loggedInCanteen.readData('FoodNotificationTime');
    timeOfDayFoodNotification ??= '11:00';
    TimeOfDay timeOfDay =
        TimeOfDay(hour: int.parse(timeOfDayFoodNotification.split(':')[0]), minute: int.parse(timeOfDayFoodNotification.split(':')[1]));
    DateTime time = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    int difference = time.difference(now).inMinutes;
    //difference from time of day to now

    if ((await loggedInCanteen.readData('lastJidloDneCheck-${loginData.users[i].username}') == nowString ||
            await loggedInCanteen.readData('sendFoodInfo-${loginData.users[i].username}') != '1' ||
            difference > 120 ||
            difference < -120) &&
        !force) {
      jidloDne = false;
    } else {
      await loggedInCanteen.saveData('lastJidloDneCheck-${loginData.users[i].username}', nowString);
    }

    if (await loggedInCanteen.readData('lastCheck-${loginData.users[i].username}') == nowString && !force) {
      kredit = false;
    }

    if (await loggedInCanteen.readData('lastCheck-${loginData.users[i].username}') == nowString && !force) {
      objednavka = false;
    }
    if (kDebugMode) {
      /*
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: -1,
        channelKey: 'else_channel',
        actionType: ActionType.Default,
        title: 'Notifikace Info',
        body: 'jidloDne: $jidloDne, kredit: $kredit, objednavka: $objednavka',
      ));*/
    }
    if (!jidloDne && !kredit && !objednavka) {
      continue;
    }
    loggedInCanteen.saveData('lastCheck-${loginData.users[i].username}', nowString);

    try {
      await loggedInCanteen.changeAccount(i, saveToStorage: false);
      if (jidloDne || force) {
        Jidelnicek jidelnicek = await loggedInCanteen.getLunchesForDay(now);
        if (jidelnicek.jidla.isNotEmpty) {
          for (int k = 0; k < jidelnicek.jidla.length; k++) {
            if (!jidelnicek.jidla[k].objednano) {
              continue;
            }
            if (difference > 0) {
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 1024 - i,
                    channelKey: 'jidlo_channel_${loginData.users[i].username}',
                    actionType: ActionType.Default,
                    title: 'Dnešní jídlo',
                    payload: {
                      'user': loginData.users[i].username,
                      'index': k.toString(),
                      'indexDne': jidelnicek.den.difference(minimalDate).inDays.toString(),
                    },
                    body: jidelnicek.jidla[0].nazev,
                  ),
                  schedule: NotificationCalendar.fromDate(date: time));
              break;
            }
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: 1024 - i,
                channelKey: 'jidlo_channel_${loginData.users[i].username}',
                actionType: ActionType.Default,
                title: 'Dnešní jídlo',
                payload: {
                  'user': loginData.users[i].username,
                  'index': k.toString(),
                  'indexDne': jidelnicek.den.difference(minimalDate).inDays.toString(),
                },
                body: jidelnicek.jidla[0].nazev,
              ),
            );
            break;
          }
        } else if (kDebugMode) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1024,
              channelKey: 'jidlo_channel_${loginData.users[i].username}',
              actionType: ActionType.Default,
              title: 'Dnešní jídlo',
              payload: {
                'user': loginData.users[i].username,
              },
              body: 'Žádné jídlo není',
            ),
          );
        } else {
          AwesomeNotifications().cancel(1024);
        }
      }
      Uzivatel uzivatel = (await loggedInCanteen.canteenData).uzivatel;
      //7 is limit for how many lunches we are gonna search for
      int objednano = 0;
      int cena = 0;
      List<Future<Jidelnicek>> jidelnickyFuture = [];
      for (int i = 0; i < 10; i++) {
        jidelnickyFuture.add(loggedInCanteen.getLunchesForDay(DateTime.now().add(Duration(days: i))));
      }
      await Future.wait(jidelnickyFuture);
      for (int denIndex = 0; denIndex < 10; denIndex++) {
        Jidelnicek jidelnicek = await loggedInCanteen.getLunchesForDay(DateTime.now().add(Duration(days: denIndex)));
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
      //parse ignore date to DateTime
      String? ignoreDateStr = await loggedInCanteen.readData('ignore_kredit_${loginData.users[i].username}');
      DateTime ignoreDate;
      switch (ignoreDateStr) {
        //not ignored
        case '':
        case null:
          ignoreDate = DateTime.now().subtract(const Duration(days: 2));
          break;
        //ignored forewer
        case '1':
          ignoreDate = DateTime.now().add(const Duration(days: 1));
          break;
        //ignored for a week
        default:
          ignoreDate = DateTime.parse(ignoreDateStr);
          break;
      }
      if (force || (cena != 0 && uzivatel.kredit < cena && kredit && ignoreDate.isBefore(DateTime.now()))) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 512 - i,
            channelKey: 'kredit_channel_${loginData.users[i].username}',
            actionType: ActionType.Default,
            title: 'Dochází vám kredit!',
            payload: {'user': loginData.users[i].username},
            body: 'Kredit pro ${uzivatel.jmeno} ${uzivatel.prijmeni}: ${uzivatel.kredit.toInt()} kč',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'ignore_kredit_${loginData.users[i].username}',
              label: 'Ztlumit na týden',
              actionType: ActionType.Default,
              enabled: true,
            ),
          ],
        );
      }
      //pokud chybí aspoň 3 obědy z příštích 10 dní
      //parse ignore date to DateTime
      String? ignoreDateStrObjednano = await loggedInCanteen.readData('ignore_objednat_${loginData.users[i].username}');
      DateTime ignoreDateObjednano;
      switch (ignoreDateStrObjednano) {
        //not ignored
        case '':
        case null:
          ignoreDateObjednano = DateTime.now().subtract(const Duration(days: 2));
          break;
        //ignored forewer
        case '1':
          ignoreDateObjednano = DateTime.now().add(const Duration(days: 1));
          break;
        //ignored for a week
        default:
          ignoreDateObjednano = DateTime.parse(ignoreDateStrObjednano);
          break;
      }
      if (force || (objednano <= 7 && objednavka && ignoreDateObjednano.isBefore(DateTime.now()))) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: i,
            channelKey: 'objednano_channel_${loginData.users[i].username}',
            actionType: ActionType.Default,
            title: 'Objednejte si na příští týden',
            payload: {'user': loginData.users[i].username},
            body: 'Uživatel ${uzivatel.jmeno} ${uzivatel.prijmeni} si stále ještě neobjednal jídlo na příští týden',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'objednat_${loginData.users[i].username}',
              label: 'Objednat vždy 1.',
              isDangerousOption: true,
              actionType: ActionType.Default,
              enabled: true,
            ),
            NotificationActionButton(
              key: 'ignore_objednat_${loginData.users[i].username}',
              label: 'Ztlumit na týden',
              actionType: ActionType.Default,
              enabled: true,
            ),
          ],
        );
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      AwesomeNotifications().cancel(588);
      if (kDebugMode) {
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
  }
  await Future.delayed(const Duration(seconds: 5));
  AwesomeNotifications().cancel(588);
  return;
}

Future<void> handleNotificationAction(ReceivedAction? receivedAction) async {
  //tlačítka ztlumení a objednání prvního oběda
  if (receivedAction?.buttonKeyPressed != null && receivedAction?.buttonKeyPressed != '') {
    if (receivedAction!.buttonKeyPressed.substring(0, 16) == 'ignore_objednat_') {
      DateTime dateTillIgnore = DateTime.now().add(const Duration(days: 7));
      await loggedInCanteen.saveData(receivedAction.buttonKeyPressed,
          '${dateTillIgnore.year}-${dateTillIgnore.month.toString().padLeft(2, '0')}-${dateTillIgnore.day.toString().padLeft(2, '0')}');
    } else if (receivedAction.buttonKeyPressed.substring(0, 14) == 'ignore_kredit_') {
      DateTime dateTillIgnore = DateTime.now().add(const Duration(days: 7));
      await loggedInCanteen.saveData(receivedAction.buttonKeyPressed,
          '${dateTillIgnore.year}-${dateTillIgnore.month.toString().padLeft(2, '0')}-${dateTillIgnore.day.toString().padLeft(2, '0')}');
    } else if (receivedAction.buttonKeyPressed.substring(0, 9) == 'objednat_') {
      LoggedInCanteen tempLoggedInCanteen = LoggedInCanteen();
      await tempLoggedInCanteen.quickOrder(receivedAction.buttonKeyPressed.substring(9));
    }
  }
  //přepnutí účtu, když uživatel klikne na notifikaci
  if (receivedAction?.payload?['user'] != null) {
    LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
    for (LoggedInUser uzivatel in loginData.users) {
      if (uzivatel.username == receivedAction?.payload?['user']) {
        await loggedInCanteen.switchAccount(loginData.users.indexOf(uzivatel));
        break;
      }
    }
  }
  if (receivedAction?.payload?['index'] != null) {
    indexJidlaKtereMaBytZobrazeno = int.parse(receivedAction!.payload!['index']!);
    indexJidlaCoMaBytZobrazeno = int.parse(receivedAction.payload!['indexDne']!);
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    /*
    if (receivedAction.buttonKeyPressed != '') {
      if (receivedAction.buttonKeyPressed.substring(0, 16) == 'ignore_objednat_') {
        DateTime dateTillIgnore = DateTime.now().add(const Duration(days: 7));
        await loggedInCanteen.saveData(receivedAction.buttonKeyPressed,
            '${dateTillIgnore.year}-${dateTillIgnore.month.toString().padLeft(2, '0')}-${dateTillIgnore.day.toString().padLeft(2, '0')}');
      } else if (receivedAction.buttonKeyPressed.substring(0, 14) == 'ignore_kredit_') {
        DateTime dateTillIgnore = DateTime.now().add(const Duration(days: 7));
        await loggedInCanteen.saveData(receivedAction.buttonKeyPressed,
            '${dateTillIgnore.year}-${dateTillIgnore.month.toString().padLeft(2, '0')}-${dateTillIgnore.day.toString().padLeft(2, '0')}');
      } else if (receivedAction.buttonKeyPressed.substring(0, 9) == 'objednat_') {
        LoggedInCanteen tempLoggedInCanteen = LoggedInCanteen();
        await tempLoggedInCanteen.quickOrder(receivedAction.buttonKeyPressed.substring(9));
      }
    }*/
  }

  /// This method is used to detect when an action button or notification is pressed when the application is open.
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed != '') {
      if (receivedAction.buttonKeyPressed.substring(0, 16) == 'ignore_objednat_') {
        DateTime dateTillIgnore = DateTime.now().add(const Duration(days: 7));
        await loggedInCanteen.saveData(receivedAction.buttonKeyPressed,
            '${dateTillIgnore.year}-${dateTillIgnore.month.toString().padLeft(2, '0')}-${dateTillIgnore.day.toString().padLeft(2, '0')}');
      } else if (receivedAction.buttonKeyPressed.substring(0, 14) == 'ignore_kredit_') {
        DateTime dateTillIgnore = DateTime.now().add(const Duration(days: 7));
        await loggedInCanteen.saveData(receivedAction.buttonKeyPressed,
            '${dateTillIgnore.year}-${dateTillIgnore.month.toString().padLeft(2, '0')}-${dateTillIgnore.day.toString().padLeft(2, '0')}');
      } else if (receivedAction.buttonKeyPressed.substring(0, 9) == 'objednat_') {
        LoggedInCanteen tempLoggedInCanteen = LoggedInCanteen();
        await tempLoggedInCanteen.quickOrder(receivedAction.buttonKeyPressed.substring(9));
      }
    }
    if (receivedAction.payload != {} && receivedAction.payload != null && receivedAction.payload!['user'] != null) {
      LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
      for (LoggedInUser uzivatel in loginData.users) {
        if (uzivatel.username == receivedAction.payload!['user']) {
          await loggedInCanteen.switchAccount(loginData.users.indexOf(uzivatel));
          try {
            setHomeWidgetPublic(LoggingInWidget(setHomeWidget: setHomeWidgetPublic));
          } catch (e) {
            //nothing
          }
          break;
        }
      }
    }
    if (receivedAction.payload?['index'] != null) {
      indexJidlaKtereMaBytZobrazeno = int.parse(receivedAction.payload!['index']!);
      indexJidlaCoMaBytZobrazeno = int.parse(receivedAction.payload!['indexDne']!);
    }
  }
}
