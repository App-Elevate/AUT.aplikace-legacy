import 'package:autojidelna/every_import.dart';
import 'package:autojidelna/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

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
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'else_channel',
      actionType: ActionType.Default,
      title: 'Dismissed',
      body: 'hh',
    ));
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10000,
      channelKey: 'else_channel',
      actionType: ActionType.Default,
      title: 'ActionCreated',
      body: receivedAction.buttonKeyPressed,
    ));
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
  }
}
