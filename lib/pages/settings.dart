//TODO: skip weekends while browsing
//TODO: Notifications: todays food, credit is low, didnt order for next week

import 'package:autojidelna/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import './../every_import.dart';

class AnalyticSettingsPage extends StatelessWidget {
  AnalyticSettingsPage({super.key});
  final ValueNotifier<bool> collectData = ValueNotifier<bool>(false);

  List<Setting> get settings => [
        Setting(
          title: 'Nízký kredit',
          valueListenable: collectData,
          onChanged: (value) async {
            collectData.value = value;
            analyticsEnabledGlobally = !value;
            if (value) {
              saveData('disableAnalytics', '1');
            } else {
              saveData('disableAnalytics', '');
            }
          },
        ),
        Setting(
          title: 'Dochází kredit',
          valueListenable: collectData,
          onChanged: (value) async {
            collectData.value = value;
            analyticsEnabledGlobally = !value;
            if (value) {
              saveData('disableAnalytics', '1');
            } else {
              saveData('disableAnalytics', '');
            }
          },
        ),
        Setting(
          title: 'Dnešní oběd',
          valueListenable: collectData,
          onChanged: (value) async {
            collectData.value = value;
            analyticsEnabledGlobally = !value;
            if (value) {
              saveData('disableAnalytics', '1');
            } else {
              saveData('disableAnalytics', '');
            }
          },
        ),
        Setting(
          title: 'Neobjednáno',
          valueListenable: collectData,
          onChanged: (value) async {
            collectData.value = value;
            analyticsEnabledGlobally = !value;
            if (value) {
              saveData('disableAnalytics', '1');
            } else {
              saveData('disableAnalytics', '');
            }
          },
        ),
        Setting(
          title: 'Přeskočit víkendové dny',
          valueListenable: collectData,
          onChanged: (value) async {
            collectData.value = value;
            analyticsEnabledGlobally = !value;
            if (value) {
              saveData('skipWeekends', '1');
            } else {
              saveData('skipWeekends', '');
            }
          },
        ),
        // Add more settings as needed
      ];

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
            appBar: AppBar(
              title: const Text("Nastavení"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Upozornění',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: settings.length,
                          itemBuilder: (context, index) {
                            final setting = settings[index];

                            return generateSettingButtons(
                              title: setting.title,
                              valueListenable: setting.valueListenable,
                              onChanged: setting.onChanged,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Shromažďování údajů',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: ListTile(
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            title: const Text(
                              'Zastavit sledování analytických služeb',
                              style: TextStyle(fontSize: 20),
                            ),
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
                                  splashRadius: 0,
                                  activeColor: const Color.fromARGB(255, 148, 18, 148),
                                );
                              },
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text:
                                'Informace sbíráme pouze pro opravování chyb v aplikaci a udržování velmi základních statistik. Vzhledem k tomu, že nemůžeme vyzkoušet autojídelnu u jídelen, kde nemáme přístup musíme záviset na tomto... Více informací naleznete ve ',
                            children: [
                              TextSpan(
                                  text: 'Zdrojovém kódu',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      //get version of the app

                                      PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                      String appVersion = packageInfo.version;
                                      launchUrl(Uri.parse('https://github.com/tpkowastaken/autojidelna/blob/v$appVersion'),
                                          mode: LaunchMode.externalApplication);
                                    }),
                              const TextSpan(
                                text: ' nebo na ',
                              ),
                              TextSpan(
                                text: 'seznamu sbíraných dat',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    //get version of the app

                                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                    String appVersion = packageInfo.version;
                                    launchUrl(Uri.parse('https://github.com/tpkowastaken/autojidelna/blob/v$appVersion/listSbiranychDat.md'),
                                        mode: LaunchMode.externalApplication);
                                  },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget generateSettingButtons({
    required String title,
    required ValueListenable<bool> valueListenable,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ListTile(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          trailing: ValueListenableBuilder(
            valueListenable: valueListenable,
            builder: (context, value, child) {
              return Switch.adaptive(
                value: value,
                onChanged: onChanged,
                splashRadius: 0,
                activeColor: const Color.fromARGB(255, 148, 18, 148),
              );
            },
          ),
        ),
      ),
    );
  }
}
