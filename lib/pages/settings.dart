// settings page. Can be called from account drawer or login screen
import 'package:awesome_notifications/awesome_notifications.dart';

// kDebugMode
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// used to make the links in text clickable
import 'package:flutter/gestures.dart';

import 'package:autojidelna/local_imports.dart';

// used to get the version of the app
import 'package:package_info_plus/package_info_plus.dart';

// used to open links in browser
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key, this.onlyAnalytics = false});
  final bool onlyAnalytics;
  late final String username;

  final ValueNotifier<bool> collectData = ValueNotifier<bool>(!analyticsEnabledGlobally);
  final ValueNotifier<bool> skipWeekendsNotifier = ValueNotifier<bool>(skipWeekends);
  final ValueNotifier<bool> jidloNotificationNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> lowCreditNotificationNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> nextWeekOrderNotificationNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<String> jidloNotificationTime = ValueNotifier<String>("11:00");
  final ValueNotifier<String> themeModeNotifier = ValueNotifier<String>("0");
  final ValueNotifier<bool> isPureBlackNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> calendarBigMarkersNotifier = ValueNotifier<bool>(false);

  Future<void> setSettings() async {
    username = loggedInCanteen.uzivatel!.uzivatelskeJmeno!;
    String? analyticsDisabled = await loggedInCanteen.readData('disableAnalytics');
    if (kDebugMode) {
      analyticsDisabled = '1';
    }

    if (analyticsDisabled == '1') {
      collectData.value = true;
      analyticsEnabledGlobally = false;
    } else {
      collectData.value = false;
      analyticsEnabledGlobally = true;
    }

    List<String>? themeSettingsList = await loggedInCanteen.readListData(consts.prefs.themeMode);
    if (themeSettingsList != null) {
      if (themeSettingsList[0] != "") {
        themeModeNotifier.value = themeSettingsList[0];
      }
      if (themeSettingsList[2] != "") {
        isPureBlackNotifier.value = themeSettingsList[2] == "1";
      }
    }

    String? bigMarkersString = await loggedInCanteen.readData('calendar_big_markers');
    if (bigMarkersString == "1") {
      calendarBigMarkersNotifier.value = true;
    } else {
      calendarBigMarkersNotifier.value = false;
    }

    String? skipWeekendsString = await loggedInCanteen.readData('skipWeekends');
    if (skipWeekendsString == '1') {
      skipWeekendsNotifier.value = true;
      skipWeekends = true;
    } else {
      skipWeekendsNotifier.value = false;
      skipWeekends = false;
    }

    String? jidloNotificationString = await loggedInCanteen.readData('sendFoodInfo-$username');
    if (jidloNotificationString == '1') {
      jidloNotificationNotifier.value = true;
    } else {
      jidloNotificationNotifier.value = false;
    }

    String? jidloNotificationTimeString = await loggedInCanteen.readData('FoodNotificationTime');
    if (jidloNotificationTimeString == null || jidloNotificationTimeString == '') {
      jidloNotificationTime.value = "11:00";
    } else {
      jidloNotificationTime.value = jidloNotificationTimeString;
    }

    String? lowCreditNotificationString = await loggedInCanteen.readData('ignore_kredit_$username');
    if (lowCreditNotificationString == '') {
      lowCreditNotificationNotifier.value = true;
    } else if (lowCreditNotificationString == '1') {
      lowCreditNotificationNotifier.value = false;
    } else if (lowCreditNotificationString != null) {
      DateTime? ignoreDate = DateTime.tryParse(lowCreditNotificationString);
      if (ignoreDate != null && ignoreDate.isBefore(DateTime.now())) {
        lowCreditNotificationNotifier.value = true;
      } else {
        lowCreditNotificationNotifier.value = false;
      }
    }

    String? nextWeekOrderNotificationNotifierString = await loggedInCanteen.readData('ignore_objednat_$username');
    if (nextWeekOrderNotificationNotifierString == '') {
      nextWeekOrderNotificationNotifier.value = true;
    } else if (nextWeekOrderNotificationNotifierString == '1') {
      nextWeekOrderNotificationNotifier.value = false;
    } else if (nextWeekOrderNotificationNotifierString != null) {
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
      appBar: AppBar(title: const Text("Nastavení")),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Vzhled'),
          ),
          const Divider(),
          ValueListenableBuilder(
            valueListenable: themeModeNotifier,
            builder: (context, value, child) {
              return ListTile(
                title: SegmentedButton<String>(
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
                  segments: const [
                    ButtonSegment<String>(
                      value: "0",
                      label: Text("Systém"),
                      enabled: true,
                    ),
                    ButtonSegment<String>(
                      value: "1",
                      label: Text("Světlý"),
                    ),
                    ButtonSegment<String>(
                      value: "2",
                      label: Text("Tmavý"),
                    ),
                  ],
                ),
              );
            },
          ),
          if (themeModeNotifier.value != "1")
            ListTile(
              title: const Text("Pure black"),
              trailing: ValueListenableBuilder(
                valueListenable: isPureBlackNotifier,
                builder: (context, value, child) {
                  return Switch.adaptive(
                    value: value,
                    onChanged: (value) async {
                      isPureBlackNotifier.value = value;
                      if (value) {
                        NotifyTheme().setTheme(NotifyTheme().themeNotifier.value.copyWith(pureBlack: true));
                      } else {
                        NotifyTheme().setTheme(NotifyTheme().themeNotifier.value.copyWith(pureBlack: false));
                      }
                    },
                  );
                },
              ),
            ),
          ListTile(
            title: const Text("Velké ukazatele v kalendáři"),
            trailing: ValueListenableBuilder(
              valueListenable: calendarBigMarkersNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    calendarBigMarkersNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData('calendar_big_markers', '1');
                    } else {
                      loggedInCanteen.saveData('calendar_big_markers', '');
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Jídelníček'),
          ),
          const Divider(),
          ListTile(
            title: const Text("Přeskakovat víkendy při procházení jídelníčku"),
            trailing: ValueListenableBuilder(
              valueListenable: skipWeekendsNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    skipWeekendsNotifier.value = value;
                    skipWeekends = value;
                    if (value) {
                      loggedInCanteen.saveData('skipWeekends', '1');
                    } else {
                      loggedInCanteen.saveData('skipWeekends', '');
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
            child: Text('Oznámení pro $username'),
          ),
          const Divider(),
          ExpansionTile(
            title: const Text("Dnešní jídlo"),
            trailing: ValueListenableBuilder(
              valueListenable: jidloNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    jidloNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData('sendFoodInfo-$username', '1');
                    } else {
                      loggedInCanteen.saveData('sendFoodInfo-$username', '');
                    }
                    doNotifications();
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
                    const Text("Čas oznámení: "),
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
                              loggedInCanteen.saveData("FoodNotificationTime", timeOfDay.format(context));
                              LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
                              for (LoggedInUser uzivatel in loginData.users) {
                                await loggedInCanteen.saveData("lastJidloDneCheck-${uzivatel.username}", '');
                              }
                              doNotifications();
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
            title: const Text("Nízký credit"),
            trailing: ValueListenableBuilder(
              valueListenable: lowCreditNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    lowCreditNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData('ignore_kredit_$username', '');
                    } else {
                      loggedInCanteen.saveData('ignore_kredit_$username', '1');
                    }
                    doNotifications();
                  },
                );
              },
            ),
          ),
          ListTile(
            title: const Text("Nemáte objednáno na příští týden"),
            trailing: ValueListenableBuilder(
              valueListenable: nextWeekOrderNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    nextWeekOrderNotificationNotifier.value = value;
                    if (value) {
                      loggedInCanteen.saveData('ignore_objednat_$username', '');
                    } else {
                      loggedInCanteen.saveData('ignore_objednat_$username', '1');
                    }
                    doNotifications();
                  },
                );
              },
            ),
          ),
          ListTile(
            title: RichText(
              text: TextSpan(
                text: 'Další možnosti v nastavení systému...',
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Shromažďování údajů'),
          ),
          const Divider(),
          ExpansionTile(
            title: const Text("Zastavit sledování analytických služeb"),
            trailing: ValueListenableBuilder(
              valueListenable: collectData,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {
                    collectData.value = value;
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
                await loggedInCanteen.saveData('lastJidloDneCheck-$username', '2000-00-00');
                await loggedInCanteen.saveData('lastCheck-$username', '2000-00-00');
                doNotifications();
              },
              child: const Text('Send notifs'),
            ),
          ),
        ],
      ),
    );
  }
}
