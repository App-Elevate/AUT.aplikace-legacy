// account drawer that is called from the main page (top left)

// kDebugMode
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:autojidelna/local_imports.dart';
import 'package:localization/localization.dart';

// Getting current version
import 'package:package_info_plus/package_info_plus.dart';

// Sharing app using the share button
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Opening links in browser
import 'package:url_launcher/url_launcher.dart';

class MainAccountDrawer extends StatelessWidget {
  MainAccountDrawer({
    super.key,
    required this.setHomeWidget,
    required this.page,
  });
  final Function(Widget widget) setHomeWidget;
  final NavigationDrawerItem page;
  final ValueNotifier<int> pickedLocationNotifier = ValueNotifier<int>(1);
  final Map<int, String> locations = {};

  @override
  Widget build(BuildContext context) {
    locations.addAll(loggedInCanteen.canteenDataUnsafe?.vydejny ?? {});
    final String username = loggedInCanteen.uzivatel?.uzivatelskeJmeno ?? '';
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Column(
            children: [
              //main account stuff
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Icon(
                        Icons.account_circle,
                        size: 75,
                      ),
                    ),
                    //switch account button
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextButton(
                          style: Theme.of(context).textButtonTheme.style?.copyWith(
                                textStyle: const WidgetStatePropertyAll(
                                  TextStyle(
                                    inherit: true,
                                    fontSize: 20,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                          onPressed: () {
                            SwitchAccountVisible().setVisible(true);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text(username), const Icon(Icons.expand_more)],
                          ),
                        ),
                      ),
                    ),
                    //stats under switch account
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //credit
                          SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.account_balance_wallet),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loggedInCanteen.uzivatel!.kredit.toInt().toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(Texts.accountDrawercurrency.i18n()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const VerticalDivider(),
                          //location
                          if (locations.isNotEmpty)
                            FutureBuilder(
                                future: loggedInCanteen.readIntData('${Prefs.location}${username}_${loggedInCanteen.canteenDataUnsafe!.url}'),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    pickedLocationNotifier.value = snapshot.data as int;
                                  }
                                  return locationPicker(context);
                                })
                          else if (locations.isEmpty)
                            const SizedBox(width: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              //navigation buttons
              //profile
              ListTile(
                title: Text(Texts.accountDrawerprofile.i18n()),
                leading: const Icon(Icons.account_circle),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        setHomeWidget: setHomeWidget,
                      ),
                    ),
                  );
                },
              ),
              //settings
              ListTile(
                title: Text(Texts.accountDrawerSettings.i18n()),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),
              //about app
              ListTile(
                title: Text(Texts.about.i18n()),
                leading: const Icon(Icons.info_rounded),
                onTap: () async {
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  var packageInfo = await PackageInfo.fromPlatform();
                  // why: it says this is the use case we should use in the docs
                  // ignore: use_build_context_synchronously
                  if (!context.mounted) return;
                  showAboutDialog(
                    context: context,
                    applicationName: Texts.aboutAppName.i18n(),
                    applicationLegalese: Texts.aboutCopyRight.i18n(['2023 - ${DateTime.now().year}']),
                    applicationVersion: '${packageInfo.version} - ${kDebugMode ? "Debug" : "Release"}',
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: ElevatedButton(
                          onPressed: (() => launchUrl(Uri.parse(Links.repo), mode: LaunchMode.externalApplication)),
                          child: Text(Texts.aboutSourceCode.i18n()),
                        ),
                      ),
                    ],
                  );
                },
              ),
              // share app
              ListTile(
                title: Text(Texts.accountDrawerShareApp.i18n()),
                leading: const Icon(Icons.share),
                onTap: () async {
                  final RenderBox? box = context.findRenderObject() as RenderBox?;
                  String text = Links.autojidelna;
                  String subject = Texts.shareDescription.i18n();
                  await Share.share(
                    text,
                    subject: subject,
                    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget locationPicker(BuildContext context) {
    return TextButton(
      style: Theme.of(context).textButtonTheme.style!.copyWith(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return Theme.of(context).colorScheme.onSurface;
              }
              return Theme.of(context).colorScheme.primary;
            }),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
          ),
      onPressed: locations.length < 2
          ? null
          : () {
              //pick location dialog
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                              child: Row(children: [Text(Texts.accountDrawerPickLocation.i18n())]),
                            ),
                            const Divider(height: 0, indent: 10, endIndent: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: locations.length,
                              itemBuilder: (context, value) {
                                return MaterialButton(
                                  padding: const EdgeInsets.all(0),
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () async {
                                    pickedLocationNotifier.value = value;
                                    loggedInCanteen.zmenitVydejnu(value + 1);
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setInt(
                                        '${Prefs.location}${loggedInCanteen.uzivatel?.uzivatelskeJmeno ?? ''}_${loggedInCanteen.canteenDataUnsafe!.url}',
                                        value);
                                    setHomeWidget(MainAppScreen(setHomeWidget: setHomeWidget));
                                  },
                                  child: ListTile(
                                    visualDensity: VisualDensity.compact,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width * 0.5,
                                          child: Text(
                                            locations[value + 1]!,
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 19),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (pickedLocationNotifier.value == value) const Icon(Icons.check),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
      child: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on),
            SizedBox(
              width: 70,
              child: ValueListenableBuilder(
                valueListenable: pickedLocationNotifier,
                builder: (context, pickedLocation, child) {
                  return Text(
                    locations[pickedLocation + 1] ?? locations[1] ?? '',
                    style: const TextStyle(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
