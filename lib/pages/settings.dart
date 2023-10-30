import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import './../every_import.dart';

class AnalyticSettingsPage extends StatelessWidget {
  AnalyticSettingsPage({super.key});
  late final String username;

  final ValueNotifier<bool> collectData = ValueNotifier<bool>(!analyticsEnabledGlobally);
  final ValueNotifier<bool> skipWeekendsNotifier = ValueNotifier<bool>(skipWeekends);
  final ValueNotifier<bool> jidloNotificationNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> lowCreditNotificationNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> nextWeekOrderNotificationNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<String> jidloNotificationTime = ValueNotifier<String>("11:00");
  final ValueNotifier<String> themeNotifier = ValueNotifier<String>("0");

  Future<void> setSettings() async {
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
    String? skipWeekendsString = await loggedInCanteen.readData('skipWeekends');
    if (skipWeekendsString == '1') {
      skipWeekendsNotifier.value = true;
      skipWeekends = true;
    } else {
      skipWeekendsNotifier.value = false;
      skipWeekends = false;
    }
    String? jidloNotificationString = await loggedInCanteen.readData('sendFoodInfo');
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
    String? themeString = await loggedInCanteen.readData('ThemeMode');
    if (themeString == null || themeString == '') {
      themeNotifier.value = "0";
    } else {
      themeNotifier.value = themeString;
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
                    _graphics(),
                    _dataUsage(context),
                    _convenience(context),
                    _notifications(context),
                    if (kDebugMode) _debug(),
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
              child: const Text('Násilím zobrazit všechna oznámení'),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                await loggedInCanteen.saveData('lastJidloDneCheck-$username', '2000-00-00');
                await loggedInCanteen.saveData('lastCheck-$username', '2000-00-00');
                doNotifications();
              },
              child: const Text('Zobrazit všechna oznámení'),
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
                      loggedInCanteen.saveData('sendFoodInfo', '1');
                    } else {
                      loggedInCanteen.saveData('sendFoodInfo', '');
                    }
                  },
                );
              },
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Čas oznámení: "),
                  ValueListenableBuilder(
                    valueListenable: jidloNotificationTime,
                    builder: (context, value, child) {
                      return ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context, initialTime: TimeOfDay(hour: int.parse(value.split(':')[0]), minute: int.parse(value.split(':')[1])));
                          if (timeOfDay != null && context.mounted) {
                            jidloNotificationTime.value = timeOfDay.format(context);
                            loggedInCanteen.saveData("FoodNotificationTime", timeOfDay.format(context));
                          }
                        },
                        child: Text(value),
                      );
                    },
                  ),
                ],
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
                  onChanged: (value) async {},
                );
              },
            ),
          ),
          ListTile(
            title: const Text("Objednat jídla na příští týden"),
            trailing: ValueListenableBuilder(
              valueListenable: nextWeekOrderNotificationNotifier,
              builder: (context, value, child) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (value) async {},
                );
              },
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                AwesomeNotifications().showNotificationConfigPage();
              },
              child: const Text('Zobrazit nastavení oznámení'),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
                for (LoggedInUser uzivatel in loginData.users) {
                  loggedInCanteen.saveData('ignore_objednat_${uzivatel.username}', '');
                  loggedInCanteen.saveData('ignore_kredit_${uzivatel.username}', '');
                }
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                if (context.mounted && !snackbarshown.shown) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackbarFunction('Nyní se zase budou zobrazovat všechna oznámení 👍'))
                      .closed
                      .then((SnackBarClosedReason reason) {
                    snackbarshown.shown = false;
                  });
                }
              },
              child: const Text('Zrušit všechna ztlumení'),
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
            valueListenable: themeNotifier,
            builder: (context, value, child) {
              return ListTile(
                title: SegmentedButton<String>(
                  showSelectedIcon: false,
                  selected: <String>{value},
                  onSelectionChanged: (Set<String> newSelection) {
                    themeNotifier.value = newSelection.first;
                    if (newSelection.first == "2") {
                      loggedInCanteen.saveData('ThemeMode', "2");
                      NotifyTheme().setTheme(ThemeMode.dark);
                    } else if (newSelection.first == "1") {
                      loggedInCanteen.saveData("ThemeMode", "1");
                      NotifyTheme().setTheme(ThemeMode.light);
                    } else {
                      loggedInCanteen.saveData("ThemeMode", "0");
                      NotifyTheme().setTheme(ThemeMode.system);
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
        ],
      ),
    );
  }
}
