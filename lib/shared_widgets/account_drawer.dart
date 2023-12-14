import 'package:flutter/foundation.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MainAccountDrawer extends StatelessWidget {
  MainAccountDrawer({
    super.key,
    required this.setHomeWidget,
    required this.page,
  });
  final Function(Widget widget) setHomeWidget;
  final NavigationDrawerItem page;
  final ValueNotifier<String> pickedLocationNotifier = ValueNotifier<String>("Neznámá lokace");
  final List locations = [];

  Future<void> getLocation() async {
    String? pickedLocationString = await loggedInCanteen.readData('location');
    pickedLocationNotifier.value = pickedLocationString!;
  }

  @override
  Widget build(BuildContext context) {
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
                                textStyle: const MaterialStatePropertyAll(
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
                                        '${loggedInCanteen.uzivatel!.kredit.toInt()}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const Text('Kč'),
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
                              future: getLocation(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (!locations.contains(pickedLocationNotifier.value)) {
                                    pickedLocationNotifier.value = locations[0];
                                  }
                                  return locationPicker(context);
                                } else {
                                  return const SizedBox(width: 100);
                                }
                              },
                            ),
                          if (locations.isEmpty) const SizedBox(width: 100),
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
                title: const Text('Profil'),
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
                title: const Text('Nastavení'),
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
                title: const Text('O Aplikaci'),
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
                    applicationName: "Autojidelna",
                    applicationLegalese: "© 2023 Tomáš Protiva, Matěj Verhaegen a kolaborátoři\nZveřejněno pod licencí GNU GPLv3",
                    applicationVersion: '${packageInfo.version} - ${kDebugMode ? "Debug" : "Release"}',
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: ElevatedButton(
                          onPressed: (() =>
                              launchUrl(Uri.parse("https://github.com/tpkowastaken/autojidelna"), mode: LaunchMode.externalApplication)),
                          child: const Text('Zdrojový kód'),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                ReleaseInfo localReleaseInfo = releaseInfo ?? await getLatestRelease();
                                if (localReleaseInfo.currentlyLatestVersion && context.mounted) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbarFunction('Aktuálně jste na nejnovější verzi aplikace 👍'))
                                      .closed
                                      .then((SnackBarClosedReason reason) {
                                    snackbarshown.shown = false;
                                  });
                                  return;
                                }
                                Future.delayed(Duration.zero, () => newUpdateDialog(context));
                              },
                              child: const Text('Zkontrolovat aktualizace', textAlign: TextAlign.center),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              // share app
              ListTile(
                title: const Text('Sdílet Aplikaci'),
                leading: const Icon(Icons.share),
                onTap: () async {
                  final RenderBox? box = context.findRenderObject() as RenderBox?;
                  String text = 'https://autojidelna.tomprotiva.com';
                  String subject = 'Autojídelna (aplikace na objednávání jídla)';
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

  TextButton locationPicker(BuildContext context) {
    return TextButton(
      style: Theme.of(context).textButtonTheme.style!.copyWith(
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Theme.of(context).colorScheme.onBackground;
              }
              return Theme.of(context).colorScheme.primary;
            }),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
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
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                              child: Row(children: [Text("Vyberte lokaci:")]),
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
                                  onPressed: () {
                                    pickedLocationNotifier.value = locations[value];
                                    loggedInCanteen.saveData("location", locations[value]);
                                    Navigator.maybeOf(context)!.popUntil((route) => route.isFirst);
                                  },
                                  child: ListTile(
                                    visualDensity: VisualDensity.compact,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width * 0.5,
                                          child: Text(
                                            locations[value],
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 19),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (pickedLocationNotifier.value == locations[value]) const Icon(Icons.check),
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
                    pickedLocation,
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
