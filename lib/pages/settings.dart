// settings page. Can be called from account drawer or login screen
import 'package:awesome_notifications/awesome_notifications.dart';

// kDebugMode
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// used to make the links in text clickable
import 'package:flutter/gestures.dart';

import 'package:autojidelna/local_imports.dart';
import 'package:localization/localization.dart';

// used to get the version of the app
import 'package:package_info_plus/package_info_plus.dart';

// used to open links in browser
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key, this.onlyAnalytics = false});
  final bool onlyAnalytics;
  late final String username;

  final ValueNotifier<bool> disableAnalyticsNotifier = ValueNotifier<bool>(!analyticsEnabledGlobally);
  final ValueNotifier<bool> skipWeekendsNotifier = ValueNotifier<bool>(skipWeekends);
  final ValueNotifier<bool> jidloNotificationNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> lowCreditNotificationNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> nextWeekOrderNotificationNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<String> jidloNotificationTime = ValueNotifier<String>("11:00");
  final ValueNotifier<String> themeNotifier = ValueNotifier<String>("0");
  final ValueNotifier<bool> calendarBigMarkersNotifier = ValueNotifier<bool>(false);

  Future<void> resetAndDoNotifications() async {
    LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
    for (LoggedInUser uzivatel in loginData.users) {
      await loggedInCanteen.saveData(consts.prefs.lastJidloDneCheck + uzivatel.username, '');
      await loggedInCanteen.saveData(consts.prefs.lastNotificationCheck + uzivatel.username, '');
    }
    await doNotifications();
  }

  Future<void> setSettings() async {
    username = loggedInCanteen.uzivatel!.uzivatelskeJmeno!;
    // analytics
    bool analyticsDisabled = await loggedInCanteen.isPrefTrue(consts.prefs.disableAnalytics);
    if (kDebugMode) {
      analyticsDisabled = true;
    }
    disableAnalyticsNotifier.value = analyticsDisabled;

    String? themeString = await loggedInCanteen.readData(consts.prefs.theme);
    if (themeString == null || themeString == '') {
      themeNotifier.value = "0";
    } else {
      themeNotifier.value = themeString;
    }

    calendarBigMarkersNotifier.value = await loggedInCanteen.isPrefTrue(consts.prefs.calendarBigMarkers);

    skipWeekendsNotifier.value = await loggedInCanteen.isPrefTrue(consts.prefs.skipWeekends);
    skipWeekends = skipWeekendsNotifier.value;

    jidloNotificationNotifier.value = await loggedInCanteen.isPrefTrue(consts.prefs.dailyFoodInfo + username);

    String? jidloNotificationTimeString = await loggedInCanteen.readData(consts.prefs.foodNotifTime);
    if (jidloNotificationTimeString != null && jidloNotificationTimeString != '') {
      jidloNotificationTime.value = jidloNotificationTimeString;
    }

    String? lowCreditNotificationString = await loggedInCanteen.readData(consts.prefs.kreditNotifications + username);
    if (lowCreditNotificationString == '') {
      //notifications allowed
      lowCreditNotificationNotifier.value = true;
    } else if (lowCreditNotificationString == '1') {
      //notifications blocked
      lowCreditNotificationNotifier.value = false;
    } else if (lowCreditNotificationString != null) {
      // Notifications blocked till a date
      DateTime? ignoreDate = DateTime.tryParse(lowCreditNotificationString);
      if (ignoreDate != null && ignoreDate.isBefore(DateTime.now())) {
        lowCreditNotificationNotifier.value = true;
      } else {
        lowCreditNotificationNotifier.value = false;
      }
    }

    String? nextWeekOrderNotificationNotifierString = await loggedInCanteen.readData(consts.prefs.nemateObjednanoNotifications + username);
    if (nextWeekOrderNotificationNotifierString == '') {
      //notifications allowed
      nextWeekOrderNotificationNotifier.value = true;
    } else if (nextWeekOrderNotificationNotifierString == '1') {
      //notifications blocked
      nextWeekOrderNotificationNotifier.value = false;
    } else if (nextWeekOrderNotificationNotifierString != null) {
      // Notifications blocked till a date
      DateTime? ignoreDate = DateTime.tryParse(nextWeekOrderNotificationNotifierString);
      if (ignoreDate != null && ignoreDate.isBefore(DateTime.now())) {
        nextWeekOrderNotificationNotifier.value = true;
      } else {
        nextWeekOrderNotificationNotifier.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(consts.texts.settingsTitle)),
      body: FutureBuilder(
        future: setSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!onlyAnalytics) _graphics(),
                    if (!onlyAnalytics) _convenience(context),
                    if (!onlyAnalytics) _notifications(context),
                    _dataUsage(context),
                    if (kDebugMode && !onlyAnalytics) _debug(),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Padding _graphics() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(consts.texts.settingsAppearence.i18n()),
          ),
          const Divider(),
          ValueListenableBuilder(
            valueListenable: themeNotifier,
            builder: (context, value, child) {
              return ListTile(
                title: SegmentedButton<String>(
                  showSelectedIcon: false,
                  selected: <String>{value},
                  onSelectionChanged: (Set<String> newSelection) {
                    themeNotifier.value = newSelection.first;
                    if (newSelection.first == "2") {
                      loggedInCanteen.saveData(consts.prefs.theme, "2");
                      NotifyTheme().setTheme(ThemeMode.dark);
                    } else if (newSelection.first == "1") {
                      loggedInCanteen.saveData(consts.prefs.theme, "1");
                      NotifyTheme().setTheme(ThemeMode.light);
                    } else {
                      loggedInCanteen.saveData(consts.prefs.theme, "0");
                      NotifyTheme().setTheme(ThemeMode.system);
                    }
                  },
                  segments: [
                    ButtonSegment<String>(
                      value: "0",
                      label: Text(consts.texts.settingsLabelSystem.i18n()),
                      enabled: true,
                    ),
                    ButtonSegment<String>(
                      value: "1",
                      label: Text(consts.texts.settingsLabelLight.i18n()),
                    ),
                    ButtonSegment<String>(
                      value: "2",
                      label: Text(consts.texts.settingsLabelDark.i18n()),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text(consts.texts.settingsCalendarBigMarkers.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: calendarBigMarkersNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    calendarBigMarkersNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData(consts.prefs.calendarBigMarkers, '1');
                    } else {
                      loggedInCanteen.saveData(consts.prefs.calendarBigMarkers, '');
                    }
                    resetAndDoNotifications();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _convenience(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(consts.texts.settingsConvenienceTitle.i18n()),
          ),
          const Divider(),
          ListTile(
            title: Text(consts.texts.settingsSkipWeekends.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: skipWeekendsNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    skipWeekendsNotifier.value = value;
                    skipWeekends = value;
                    if (value) {
                      loggedInCanteen.saveData(consts.prefs.skipWeekends, '1');
                    } else {
                      loggedInCanteen.saveData(consts.prefs.skipWeekends, '');
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _notifications(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(consts.texts.settingsNotificationFor.i18n() + username),
          ),
          const Divider(),
          ExpansionTile(
            title: Text(consts.texts.settingsTitleTodaysFood.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: jidloNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    jidloNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData(consts.prefs.dailyFoodInfo + username, '1');
                    } else {
                      loggedInCanteen.saveData(consts.prefs.dailyFoodInfo + username, '');
                    }
                    resetAndDoNotifications();
                  },
                );
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(consts.texts.settingsNotificationTime.i18n()),
                    ValueListenableBuilder(
                      valueListenable: jidloNotificationTime,
                      builder: (context, value, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: int.parse(value.split(':')[0]), minute: int.parse(value.split(':')[1])));
                            if (timeOfDay != null && context.mounted) {
                              jidloNotificationTime.value = timeOfDay.format(context);
                              await loggedInCanteen.saveData(consts.prefs.foodNotifTime, timeOfDay.format(context));
                              resetAndDoNotifications();
                            }
                          },
                          child: Text(value),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(consts.texts.settingsTitleKredit.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: lowCreditNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    lowCreditNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData(consts.prefs.kreditNotifications + username, '');
                    } else {
                      loggedInCanteen.saveData(consts.prefs.kreditNotifications + username, '1');
                    }
                    resetAndDoNotifications();
                  },
                );
              },
            ),
          ),
          ListTile(
            title: Text(consts.texts.settingsNemateObjednano.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: nextWeekOrderNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    nextWeekOrderNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData(consts.prefs.nemateObjednanoNotifications + username, '');
                    } else {
                      loggedInCanteen.saveData(consts.prefs.nemateObjednanoNotifications + username, '1');
                    }
                    resetAndDoNotifications();
                  },
                );
              },
            ),
          ),
          ListTile(
            title: RichText(
              text: TextSpan(
                text: consts.texts.settingsAnotherOptions.i18n(),
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    AwesomeNotifications().showNotificationConfigPage();
                  },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _dataUsage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(consts.texts.settingsDataCollection),
          ),
          const Divider(),
          ExpansionTile(
            title: Text(consts.texts.settingsStopDataCollection),
            trailing: ValueListenableBuilder(
              valueListenable: disableAnalyticsNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    disableAnalyticsNotifier.value = value;
                    analyticsEnabledGlobally = !value;
                    if (value) {
                      loggedInCanteen.saveData('disableAnalytics', '1');
                    } else {
                      loggedInCanteen.saveData('disableAnalytics', '');
                    }
                  },
                );
              },
            ),
            children: [
              RichText(
                text: TextSpan(
                  text:
                      'Informace sbíráme pouze pro opravování chyb v aplikaci a udržování velmi základních statistik. Vzhledem k tomu, že nemůžeme vyzkoušet autojídelnu u jídelen, kde nemáme přístup musíme záviset na tomto. Více informací naleznete ve ',
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  children: [
                    TextSpan(
                      text: 'Zdrojovém kódu',
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          //get version of the app

                          PackageInfo packageInfo = await PackageInfo.fromPlatform();
                          String appVersion = packageInfo.version;
                          launchUrl(Uri.parse('https://github.com/tpkowastaken/autojidelna/blob/v$appVersion'), mode: LaunchMode.externalApplication);
                        },
                    ),
                    const TextSpan(
                      text: ' nebo na ',
                    ),
                    TextSpan(
                      text: 'seznamu sbíraných dat',
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          //get version of the app

                          PackageInfo packageInfo = await PackageInfo.fromPlatform();
                          String appVersion = packageInfo.version;
                          launchUrl(Uri.parse('https://github.com/tpkowastaken/autojidelna/blob/v$appVersion/listSbiranychDat.md'),
                              mode: LaunchMode.externalApplication);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding _debug() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Debug Options'),
          ),
          const Divider(),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                doNotifications(force: true);
              },
              child: const Text('Force send notifs'),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                resetAndDoNotifications();
              },
              child: const Text('Send notifs'),
            ),
          ),
        ],
      ),
    );
  }
}
