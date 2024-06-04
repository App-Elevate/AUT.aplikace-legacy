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
  late final String url;

  final ValueNotifier<bool> disableAnalyticsNotifier = ValueNotifier<bool>(!analyticsEnabledGlobally);
  final ValueNotifier<bool> skipWeekendsNotifier = ValueNotifier<bool>(skipWeekends);
  final ValueNotifier<bool> jidloNotificationNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> lowCreditNotificationNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> nextWeekOrderNotificationNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<String> jidloNotificationTime = ValueNotifier<String>("11:00");
  final ValueNotifier<String> themeModeNotifier = ValueNotifier<String>("0");
  final ValueNotifier<String> themeStyleNotifier = ValueNotifier<String>("0");
  final ValueNotifier<bool> isPureBlackNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> calendarBigMarkersNotifier = ValueNotifier<bool>(false);

  Future<void> resetAndDoNotifications() async {
    LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
    for (LoggedInUser uzivatel in loginData.users) {
      await loggedInCanteen.removeData('${Prefs.lastJidloDneCheck}${uzivatel.username}_${uzivatel.url}');
      await loggedInCanteen.removeData('${Prefs.lastNotificationCheck}${uzivatel.username}_${uzivatel.url}');
    }
    await doNotifications();
  }

  Future<void> setSettings() async {
    username = loggedInCanteen.uzivatel!.uzivatelskeJmeno!;
    url = loggedInCanteen.canteenDataUnsafe!.url;
    // analytics
    bool analyticsDisabled = await loggedInCanteen.isPrefTrue(Prefs.disableAnalytics);
    if (kDebugMode) {
      analyticsDisabled = true;
    }
    disableAnalyticsNotifier.value = analyticsDisabled;
    analyticsEnabledGlobally = !analyticsDisabled;

    List<String>? themeSettingsList = await loggedInCanteen.readListData(Prefs.theme);
    if (themeSettingsList != null) {
      if (themeSettingsList[0] != "") {
        themeModeNotifier.value = themeSettingsList[0];
      }
      if (themeSettingsList[1] != "") {
        themeStyleNotifier.value = themeSettingsList[1];
      }
      if (themeSettingsList[2] != "") {
        isPureBlackNotifier.value = themeSettingsList[2] == "1";
      }
    }

    calendarBigMarkersNotifier.value = await loggedInCanteen.isPrefTrue(Prefs.calendarBigMarkers);

    skipWeekendsNotifier.value = await loggedInCanteen.isPrefTrue(Prefs.skipWeekends);
    skipWeekends = skipWeekendsNotifier.value;

    jidloNotificationNotifier.value = await loggedInCanteen.isPrefTrue('${Prefs.dailyFoodInfo}${username}_$url');

    String? jidloNotificationTimeString = await loggedInCanteen.readData(Prefs.foodNotifTime);
    if (jidloNotificationTimeString != null && jidloNotificationTimeString != '') {
      jidloNotificationTime.value = jidloNotificationTimeString;
    }

    String? lowCreditNotificationString = await loggedInCanteen.readData('${Prefs.kreditNotifications}${username}_$url');
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

    String? nextWeekOrderNotificationNotifierString = await loggedInCanteen.readData('${Prefs.nemateObjednanoNotifications}${username}_$url');
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
      appBar: AppBar(title: Text(Texts.settingsTitle.i18n())),
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
                    if (!onlyAnalytics) _graphics(context),
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

  Padding _graphics(context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(Texts.settingsAppearence.i18n()),
          ),
          const Divider(),
          ListTile(
            title: ValueListenableBuilder(
              valueListenable: themeModeNotifier,
              builder: (context, value, child) {
                return SegmentedButton<String>(
                  showSelectedIcon: false,
                  selected: <String>{value},
                  onSelectionChanged: (Set<String> newSelection) {
                    themeModeNotifier.value = newSelection.first;
                    switch (newSelection.first) {
                      case "2":
                        NotifyTheme().setTheme(NotifyTheme().themeNotifier.value.copyWith(themeMode: ThemeMode.dark));
                        break;
                      case "1":
                        NotifyTheme().setTheme(NotifyTheme().themeNotifier.value.copyWith(themeMode: ThemeMode.light));
                        break;
                      default:
                        NotifyTheme().setTheme(NotifyTheme().themeNotifier.value.copyWith(themeMode: ThemeMode.system));
                    }
                  },
                  segments: [
                    ButtonSegment<String>(
                      value: "0",
                      label: Text(Texts.settingsLabelSystem.i18n()),
                      enabled: true,
                    ),
                    ButtonSegment<String>(
                      value: "1",
                      label: Text(Texts.settingsLabelLight.i18n()),
                    ),
                    ButtonSegment<String>(
                      value: "2",
                      label: Text(Texts.settingsLabelDark.i18n()),
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            title: SizedBox(
              height: 225,
              child: ValueListenableBuilder(
                valueListenable: themeStyleNotifier,
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: ThemeStyle.values.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Map<ThemeStyle, List<Color>> colorStyleList = ColorSchemes.colorStyles;
                      ThemeStyle currentTheme = colorStyleList.keys.toList()[index];
                      List<Color> currentColors = colorStyleList[currentTheme]!;

                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () {
                            themeStyleNotifier.value = index.toString();
                            NotifyTheme().setTheme(NotifyTheme().themeNotifier.value.copyWith(themeStyle: currentTheme));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 3,
                                  color: themeStyleNotifier.value == index.toString()
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                color: Theme.of(context).colorScheme.surface),
                            height: 250,
                            width: 125,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                  child: AppBar(
                                    automaticallyImplyLeading: false,
                                    backgroundColor: Theme.of(context).brightness == Brightness.light
                                        ? currentColors[0]
                                        : Theme.of(context).appBarTheme.backgroundColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(13.0),
                                        topRight: Radius.circular(13.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.transparent,
                                ),
                                ListTile(
                                  dense: true,
                                  enabled: false,
                                  minVerticalPadding: 0,
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  title: Card(
                                    margin: EdgeInsets.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 30, 5, 2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).brightness == Brightness.light ? currentColors[0] : currentColors[2],
                                          borderRadius: BorderRadius.circular(12.5),
                                        ),
                                        height: 20,
                                        width: 100,
                                        margin: const EdgeInsets.only(bottom: 5),
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  enabled: false,
                                  minVerticalPadding: 0,
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  title: Card(
                                    margin: EdgeInsets.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 40, 5, 2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).brightness == Brightness.light ? currentColors[1] : currentColors[3],
                                          borderRadius: BorderRadius.circular(12.5),
                                        ),
                                        height: 20,
                                        width: 100,
                                        margin: const EdgeInsets.only(bottom: 5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          ListTile(
            enabled: Theme.of(context).brightness == Brightness.dark,
            title: const Text("Pure black"),
            trailing: ValueListenableBuilder(
              valueListenable: isPureBlackNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: Theme.of(context).brightness == Brightness.dark
                      ? (value) async {
                          isPureBlackNotifier.value = value;
                          if (value) {
                            NotifyTheme().setTheme(NotifyTheme().themeNotifier.value.copyWith(pureBlack: true));
                          } else {
                            NotifyTheme().setTheme(NotifyTheme().themeNotifier.value.copyWith(pureBlack: false));
                          }
                        }
                      : null,
                );
              },
            ),
          ),
          ListTile(
            title: Text(Texts.settingsCalendarBigMarkers.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: calendarBigMarkersNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    calendarBigMarkersNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData(Prefs.calendarBigMarkers, '1');
                    } else {
                      loggedInCanteen.saveData(Prefs.calendarBigMarkers, '');
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

  Padding _convenience(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(Texts.settingsConvenienceTitle.i18n()),
          ),
          const Divider(),
          ListTile(
            title: Text(Texts.settingsSkipWeekends.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: skipWeekendsNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    skipWeekendsNotifier.value = value;
                    skipWeekends = value;
                    if (value) {
                      loggedInCanteen.saveData(Prefs.skipWeekends, '1');
                    } else {
                      loggedInCanteen.saveData(Prefs.skipWeekends, '');
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
            child: Text(Texts.settingsNotificationFor.i18n() + username),
          ),
          const Divider(),
          ExpansionTile(
            title: Text(Texts.settingsTitleTodaysFood.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: jidloNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    jidloNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData('${Prefs.dailyFoodInfo}${username}_$url', '1');
                    } else {
                      loggedInCanteen.saveData('${Prefs.dailyFoodInfo}${username}_$url', '');
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
                    Text(Texts.settingsNotificationTime.i18n()),
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
                              await loggedInCanteen.saveData(Prefs.foodNotifTime, timeOfDay.format(context));
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
            title: Text(Texts.settingsTitleKredit.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: lowCreditNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    lowCreditNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData('${Prefs.kreditNotifications}${username}_$url', '');
                    } else {
                      loggedInCanteen.saveData('${Prefs.kreditNotifications}${username}_$url', '1');
                    }
                    resetAndDoNotifications();
                  },
                );
              },
            ),
          ),
          ListTile(
            title: Text(Texts.settingsNemateObjednano.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: nextWeekOrderNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    nextWeekOrderNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData('${Prefs.nemateObjednanoNotifications}${username}_$url', '');
                    } else {
                      loggedInCanteen.saveData('${Prefs.nemateObjednanoNotifications}${username}_$url', '1');
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
                text: Texts.settingsAnotherOptions.i18n(),
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
            child: Text(Texts.settingsDataCollection.i18n()),
          ),
          const Divider(),
          ExpansionTile(
            title: Text(Texts.settingsStopDataCollection.i18n()),
            trailing: ValueListenableBuilder(
              valueListenable: disableAnalyticsNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    disableAnalyticsNotifier.value = value;
                    analyticsEnabledGlobally = !value;
                    if (value) {
                      loggedInCanteen.saveData(Prefs.disableAnalytics, '1');
                    } else {
                      loggedInCanteen.saveData(Prefs.disableAnalytics, '');
                    }
                  },
                );
              },
            ),
            children: [
              RichText(
                text: TextSpan(
                  text: Texts.settingsDataCollectionDescription1.i18n(),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  children: [
                    TextSpan(
                      text: Texts.settingsDataCollectionDescription2.i18n(),
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          //get version of the app

                          PackageInfo packageInfo = await PackageInfo.fromPlatform();
                          String appVersion = packageInfo.version;
                          launchUrl(Uri.parse(Links.currentVersionCode(appVersion)), mode: LaunchMode.externalApplication);
                        },
                    ),
                    TextSpan(
                      text: Texts.settingsDataCollectionDescription3.i18n(),
                    ),
                    TextSpan(
                      text: Texts.settingsDataCollectionDescription4.i18n(),
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          //get version of the app

                          PackageInfo packageInfo = await PackageInfo.fromPlatform();
                          String appVersion = packageInfo.version;
                          launchUrl(Uri.parse(Links.listSbiranychDat(appVersion)), mode: LaunchMode.externalApplication);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(Texts.settingsDebugOptions.i18n()),
          ),
          const Divider(),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                doNotifications(force: true);
              },
              child: Text(Texts.settingsDebugForceNotifications.i18n()),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                resetAndDoNotifications();
              },
              child: Text(Texts.settingsDebugNotifications.i18n()),
            ),
          ),
        ],
      ),
    );
  }
}
