/*zde jsou nastavení:
přeskočit víkendy při browsdání (při mačkání tlačítek)
notifikace:
dnešní jídlo (v kolik hodin zaslat)
dochází kredit
burzaCatcher notifikace
nemáte objednáno na příští týden
autoObjednávky případné zeptání se na objednání
 */

//TODO: skip weekends while browsing
//TODO: Notifications: todays food, credit is low, burzacatcher, didnt order for next week, autoBojednavky,

import 'package:autojidelna/main.dart';
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
              appBar: AppBar(
                title: const Text("Nastavení"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  }),
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
                                      })
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
        });
  }
}
