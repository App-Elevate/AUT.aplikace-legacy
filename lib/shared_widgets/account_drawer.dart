import './../every_import.dart';

class MainAccountDrawer extends StatelessWidget {
  MainAccountDrawer({
    super.key,
    required this.setHomeWidget,
    required this.page,
  });
  final Function setHomeWidget;
  final NavigationDrawerItem page;

  final CanteenData canteenData = getCanteenData();

  @override
  Widget build(BuildContext context) {
    final String username = getCanteenData().username;
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Text('Autojídelna'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              //main account stuff
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Icon(
                        Icons.account_circle,
                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                        size: 75,
                      ),
                    ),
                    //switch account button
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextButton(
                          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                          onPressed: () {
                            SwitchAccountVisible().setVisible(true);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.expand_more,
                                color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                              )
                            ],
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
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                                  size: 35,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${canteenData.uzivatel.kredit.toInt()}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        'Kč',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                              ? const Color.fromARGB(175, 255, 255, 255)
                                              : const Color(0xff323232),
                                        ),
                                      ),
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
                            //      Icon(
                            //        Icons.hub,
                            //        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                            //        size: 35,
                            //      ),
                            //      Padding(
                            //        padding: const EdgeInsets.only(left: 10.0),
                            //        child: Column(
                            //          mainAxisAlignment: MainAxisAlignment.center,
                            //          crossAxisAlignment: CrossAxisAlignment.start,
                            //          children: [
                            //            const Text(
                            //              '0',
                            //              style: TextStyle(
                            //                fontSize: 20,
                            //              ),
                            //            ),
                            //            Text(
                            //              'Bodů',
                            //              style: TextStyle(
                            //                fontSize: 15,
                            //                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                            //                    ? const Color.fromARGB(175, 255, 255, 255)
                            //                    : const Color(0xff323232),
                            //              ),
                            //            ),
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
                title: const Text(
                  'Profil',
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.account_circle,
                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                  size: 30,
                ),
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
                title: const Text(
                  'Nastavení',
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.settings,
                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                  size: 30,
                ),
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
                title: const Text(
                  'O Aplikaci',
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.info_rounded,
                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                  size: 30,
                ),
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
                          try {
                            if (!releaseInfo.isAndroid) {
                              return const SizedBox(
                                height: 0,
                                width: 0,
                              );
                            }
                          } catch (e) {
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          }
                          return ElevatedButton(
                            onPressed: () async {
                              await getLatestRelease();
                              if (releaseInfo.isAndroid && releaseInfo.currentlyLatestVersion! && context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbarFunction('Aktuálně jste na nejnovější verzi aplikace 👍', context))
                                    .closed
                                    .then((SnackBarClosedReason reason) {
                                  snackbarshown.shown = false;
                                });
                                return;
                              } else if (!releaseInfo.isAndroid) {
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                        snackbarFunction('nepovedlo se připojit k serverům githubu. Ověřte připojení a zkuste to znovu...', context))
                                    .closed
                                    .then((SnackBarClosedReason reason) {
                                  snackbarshown.shown = false;
                                });
                                return;
                              }
                              Future.delayed(Duration.zero, () => newUpdateDialog(context));
                            },
                            child: const Text('Zkontrolovat aktualizace'),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              //log out
            ],
          ),
        ),
      ),
    );
  }
}
