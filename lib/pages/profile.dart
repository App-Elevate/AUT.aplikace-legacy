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
                _userPersonalinfo(),
                const Divider(),
                // Platební údaje
                _userBillingInfo(),
                const Divider(),
                //Autojídelna
                _autojidelna(),
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
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
              Navigator.of(context).pop(
                setHomeWidget(
                  LoginScreen(
                    setHomeWidget: setHomeWidget,
                  ),
                ),
              );
            },
          ),
        ],
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle,
                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : const Color(0xff323232),
                  size: 80,
                ),
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
                          if (getCanteenData().uzivatel.uzivatelskeJmeno != null) {
                            return Text(getCanteenData().uzivatel.uzivatelskeJmeno!);
                          } else {
                            return FutureBuilder(
                              future: getLoginDataFromSecureStorage(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data?.users[snapshot.data!.currentlyLoggedInId!].username ?? '',
                                    style: const TextStyle(
                                      fontSize: 25,
                                    ),
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
                      'Kredit: ${getCanteenData().uzivatel.kredit.toInt()} kč',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
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

  Padding _userPersonalinfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Osobní Údaje',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Builder(
            builder: (context) {
              if (getCanteenData().uzivatel.jmeno != null || getCanteenData().uzivatel.prijmeni != null) {
                return Text('Jméno: ${getCanteenData().uzivatel.jmeno ?? ''} ${getCanteenData().uzivatel.prijmeni}');
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
          Builder(
            builder: (context) {
              if (getCanteenData().uzivatel.kategorie != null) {
                return Text('Kategorie: ${getCanteenData().uzivatel.kategorie!}');
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
        ],
      ),
    );
  }

  Padding _userBillingInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Platební Údaje',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Builder(
            builder: (context) {
              if (getCanteenData().uzivatel.ucetProPlatby != null && getCanteenData().uzivatel.ucetProPlatby != '') {
                return Text('Číslo účtu pro platby: ${getCanteenData().uzivatel.ucetProPlatby}');
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
          Builder(
            builder: (context) {
              if (getCanteenData().uzivatel.specSymbol != null && getCanteenData().uzivatel.specSymbol != '') {
                return Text('Specifický Symbol: ${getCanteenData().uzivatel.specSymbol}');
              } else {
                //return nothing
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
          Builder(
            builder: (context) {
              if (getCanteenData().uzivatel.varSymbol != null && getCanteenData().uzivatel.varSymbol != '') {
                return Text('Variabilní Symbol: ${getCanteenData().uzivatel.varSymbol}');
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
        ],
      ),
    );
  }

  Padding _autojidelna() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Autojídelna',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          FutureBuilder(
            future: readData('statistika:objednavka'),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Počet objednávek s autojídelnou: chyba při načítání dat');
              } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return Text('Počet objednávek s autojídelnou: ${snapshot.data}');
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
