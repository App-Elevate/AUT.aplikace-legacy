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
    if (receivedAction.buttonKeyPressed == '') return;
    //ztlumit notifikaci o neobjednaném jídle na příští týden
    if (receivedAction.buttonKeyPressed.substring(0, 16) == 'ignore_objednat_') {
      DateTime dateTillIgnore = DateTime.now().add(const Duration(days: 7));
      loggedInCanteen.saveData(receivedAction.buttonKeyPressed,
          '${dateTillIgnore.year}-${dateTillIgnore.month.toString().padLeft(2, '0')}-${dateTillIgnore.day.toString().padLeft(2, '0')}');
    } else if (receivedAction.buttonKeyPressed.substring(0, 14) == 'ignore_kredit_') {
      DateTime dateTillIgnore = DateTime.now().add(const Duration(days: 7));
      loggedInCanteen.saveData(receivedAction.buttonKeyPressed,
          '${dateTillIgnore.year}-${dateTillIgnore.month.toString().padLeft(2, '0')}-${dateTillIgnore.day.toString().padLeft(2, '0')}');
    } else if (receivedAction.buttonKeyPressed.substring(0, 9) == 'objednat_') {
      LoggedInCanteen tempLoggedInCanteen = LoggedInCanteen();
      tempLoggedInCanteen.quickOrder(receivedAction.buttonKeyPressed.substring(9));
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
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
