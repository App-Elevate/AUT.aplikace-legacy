//TODO: skip weekends while browsing

import 'package:autojidelna/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/gestures.dart';

import './../every_import.dart';

class AnalyticSettingsPage extends StatelessWidget {
  AnalyticSettingsPage({super.key});

  final ValueNotifier<bool> collectData = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readData('disableAnalytics'),
      builder: (context, snaphot) {
        if (snaphot.connectionState == ConnectionState.done) {
          if (snaphot.data == '1') {
            collectData.value = true;
          } else {
            collectData.value = false;
          }
          return Scaffold(
            appBar: AppBar(title: const Text("Nastavení")),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Graphics(),
                    _dataUsage(context),
                    _notifications(),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Padding _notifications() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Oznámení'),
          ),
          const Divider(),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                AwesomeNotifications().showNotificationConfigPage();
              },
              child: const Text('Zobrazit nastavení oznámení'),
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
            padding: EdgeInsets.only(top: 8.0),
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
                      saveData('disableAnalytics', '1');
                    } else {
                      saveData('disableAnalytics', '');
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
}

class _Graphics extends StatefulWidget {
  @override
  State<_Graphics> createState() => _GraphicsState();
}

class _GraphicsState extends State<_Graphics> {
  String selectedMode = "0";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Vzhled'),
          ),
          const Divider(),
          FutureBuilder(
            future: readData("ThemeMode"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                selectedMode = snapshot.data!;
              } else {
                selectedMode = "system";
              }
              return ListTile(
                title: SegmentedButton<String>(
                  showSelectedIcon: false,
                  selected: <String>{selectedMode},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      selectedMode = newSelection.first;
                    });
                    if (selectedMode == "2") {
                      saveData('ThemeMode', "2");
                      NotifyTheme().setTheme(ThemeMode.dark);
                    } else if (selectedMode == "1") {
                      saveData("ThemeMode", "1");
                      NotifyTheme().setTheme(ThemeMode.light);
                    } else {
                      saveData("ThemeMode", "0");
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
