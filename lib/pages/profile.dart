import 'package:autojidelna/main.dart';

import './../every_import.dart';

/*zde se budou nacházet nastavení a možnost zakoupit pro a vidět statistiky profilu Icanteen. Zároveň zde bude systém pro měnění účtů */
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.setHomeWidget});
  final Function setHomeWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _appBarLogoutButton(context),
        ],
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Icon, username, credit
                _userMainInfo(context),
                const Divider(),
                //Jméno a příjmení
                _userPersonalinfo(context),
                const Divider(),
                // Platební údaje
                _userBillingInfo(context),
                const Divider(),
                //Autojídelna
                _autojidelna(context),
                const Divider()
              ],
            ),
          );
        },
      ),
    );
  }

  Padding _appBarLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        onPressed: () async {
          logout();
          Navigator.of(context).pop();
          await Future.delayed(const Duration(milliseconds: 300));
          setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Odhlásit se',
                style: TextStyle(
                  fontSize: 20,
                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                ),
              ),
            ),
            Icon(Icons.logout, color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232)),
          ],
        ),
      ),
    );
  }

  Row _userMainInfo(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.account_circle, size: 80),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Builder(
                        builder: (context) {
                          if (canteenData!.uzivatel.uzivatelskeJmeno != null) {
                            return Text(canteenData!.uzivatel.uzivatelskeJmeno!);
                          } else {
                            return FutureBuilder(
                              future: getLoginDataFromSecureStorage(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data?.users[snapshot.data!.currentlyLoggedInId!].username ?? '',
                                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.normal),
                                  );
                                } else {
                                  return const Text('Načítání...');
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                    Text(
                      'Kredit: ${canteenData!.uzivatel.kredit.toInt()} kč',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding _userPersonalinfo(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Osobní Údaje',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Builder(
            builder: (context) {
              if (canteenData!.uzivatel.jmeno != null || canteenData!.uzivatel.prijmeni != null) {
                return Text(
                  'Jméno: ${canteenData!.uzivatel.jmeno ?? ''} ${canteenData!.uzivatel.prijmeni}',
                  style: Theme.of(context).textTheme.displayMedium,
                );
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
          Builder(
            builder: (context) {
              if (canteenData!.uzivatel.kategorie != null) {
                return Text(
                  'Kategorie: ${canteenData!.uzivatel.kategorie!}',
                  style: Theme.of(context).textTheme.displayMedium,
                );
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
        ],
      ),
    );
  }

  Padding _userBillingInfo(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Platební Údaje',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Builder(
            builder: (context) {
              if (canteenData!.uzivatel.ucetProPlatby != null && canteenData!.uzivatel.ucetProPlatby != '') {
                return Text(
                  'Číslo účtu pro platby: ${canteenData!.uzivatel.ucetProPlatby}',
                  style: Theme.of(context).textTheme.displayMedium,
                );
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
          Builder(
            builder: (context) {
              if (canteenData!.uzivatel.specSymbol != null && canteenData!.uzivatel.specSymbol != '') {
                return Text(
                  'Specifický Symbol: ${canteenData!.uzivatel.specSymbol}',
                  style: Theme.of(context).textTheme.displayMedium,
                );
              } else {
                //return nothing
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
          Builder(
            builder: (context) {
              if (canteenData!.uzivatel.varSymbol != null && canteenData!.uzivatel.varSymbol != '') {
                return Text(
                  'Variabilní Symbol: ${canteenData!.uzivatel.varSymbol}',
                  style: Theme.of(context).textTheme.displayMedium,
                );
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
        ],
      ),
    );
  }

  Padding _autojidelna(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Autojídelna',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          FutureBuilder(
            future: readData('statistika:objednavka'),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Počet objednávek s autojídelnou: chyba při načítání dat');
              } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return Text(
                  'Počet objednávek s autojídelnou: ${snapshot.data}',
                  style: Theme.of(context).textTheme.displayMedium,
                );
              } else {
                return const Text('Počet objednávek s autojídelnou: 0');
              }
            },
          ),
          // const Text('Počet automatických objenávek: 0'),
          // const Text('Počet objednávek chycených burza Catcherem: 0'),
          // const Padding(
          //   padding: EdgeInsets.only(top: 5.0),
          //   child: Text('Pro verze: není dostupná'),
          // ),
          //const Divider(),
          // ElevatedButton(onPressed: () {}, child: const Text('Zakoupit Pro')),
        ],
      ),
    );
  }
}
