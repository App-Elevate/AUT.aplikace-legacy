import './../every_import.dart';
import 'package:share_plus/share_plus.dart';

class MainAccountDrawer extends StatelessWidget {
  const MainAccountDrawer({
    super.key,
    required this.setHomeWidget,
    required this.page,
  });
  final Function setHomeWidget;
  final NavigationDrawerItem page;

  @override
  Widget build(BuildContext context) {
    final String username = canteenData!.username;
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
                                        '${canteenData!.uzivatel.kredit.toInt()}',
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
                          //Nothing yet
                          const SizedBox(
                            width: 100,
                            //  child: Row(
                            //    mainAxisAlignment: MainAxisAlignment.center,
                            //    crossAxisAlignment: CrossAxisAlignment.center,
                            //    children: [
                            //      Icon(),
                            //      Padding(
                            //        padding: const EdgeInsets.only(left: 10.0),
                            //        child: Column(
                            //          mainAxisAlignment: MainAxisAlignment.center,
                            //          crossAxisAlignment: CrossAxisAlignment.start,
                            //          children: [
                            //            const Text(""),
                            //            Text(
                            //              "",
                            //              style: TextStyle(fontSize: 20)),
                            //          ],
                            //        ),
                            //      ),
                            //    ],
                            //  ),
                          ),
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
                      builder: (context) => AnalyticSettingsPage(),
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
                    applicationVersion: packageInfo.version,
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
                          try {} catch (e) {
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                await getLatestRelease();
                                if (releaseInfo.isAndroid && releaseInfo.currentlyLatestVersion! && context.mounted) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbarFunction('Aktuálně jste na nejnovější verzi aplikace 👍'))
                                      .closed
                                      .then((SnackBarClosedReason reason) {
                                    snackbarshown.shown = false;
                                  });
                                  return;
                                } else if (!releaseInfo.isAndroid) {
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbarFunction('Nepovedlo se připojit k serverům githubu. Ověřte připojení a zkuste to znovu.'))
                                      .closed
                                      .then((SnackBarClosedReason reason) {
                                    snackbarshown.shown = false;
                                  });
                                  return;
                                }
                                Future.delayed(Duration.zero, () => newUpdateDialog(context));
                              },
                              child: const Text('Zkontrolovat aktualizace'),
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
}
