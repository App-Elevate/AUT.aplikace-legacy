import './../every_import.dart';

/*zde se budou nacházet nastavení a možnost zakoupit pro a vidět statistiky profilu Icanteen. Zároveň zde bude systém pro měnění účtů */
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.setHomeWidget});
  final Function setHomeWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          color: MediaQuery.of(context).platformBrightness == Brightness.dark?const Color(0xff2e2e2e):const Color(0xfffafafa),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                backgroundColor: Colors.black,
                                onPressed: () {},
                                child: const Icon(
                                  color: Colors.white,
                                  Icons.person),
                              ),
                            ),
                            Center(
                              child: Builder(builder: (context) {
                                if (getCanteenData()
                                        .uzivatel
                                        .uzivatelskeJmeno !=
                                    null) {
                                  return Text(getCanteenData()
                                      .uzivatel
                                      .uzivatelskeJmeno!);
                                } else {
                                  return FutureBuilder(
                                      future:
                                          getDataFromSecureStorage('username'),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(snapshot.data ?? '');
                                        } else {
                                          return const Text('Načítání...');
                                        }
                                      });
                                }
                              }),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  //Jméno a příjmení
                  Builder(builder: (context) {
                    if (getCanteenData().uzivatel.jmeno != null ||
                        getCanteenData().uzivatel.prijmeni != null) {
                      return Text(
                          'Jméno: ${getCanteenData().uzivatel.jmeno ?? ''} ${getCanteenData().uzivatel.prijmeni}');
                    } else {
                      return const Placeholder();
                    }
                  }),
                  Text('Kredit: ${getCanteenData().uzivatel.kredit.toInt()} kč'),
                  Builder(
                    builder: (context) {
                      if (getCanteenData().uzivatel.kategorie != null) {
                        return Text(
                            'Kategorie: ${getCanteenData().uzivatel.kategorie!}');
                      } else {
                        return const SizedBox(width: 0, height: 0);
                      }
                    },
                  ),
                  // Platební údaje
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text('Platební Údaje')),
                  ),
                  Builder(builder: (context) {
                    if (getCanteenData().uzivatel.ucetProPlatby != null &&
                        getCanteenData().uzivatel.ucetProPlatby != '') {
                      return Text(
                          'Číslo účtu pro platby: ${getCanteenData().uzivatel.ucetProPlatby}');
                    } else {
                        return const SizedBox(width: 0, height: 0);
                    }
                  }),
                  Builder(builder: (context) {
                    if (getCanteenData().uzivatel.specSymbol != null &&
                        getCanteenData().uzivatel.specSymbol != '') {
                      return Text(
                          'Specifický Symbol: ${getCanteenData().uzivatel.specSymbol}');
                    } else {
                      //return nothing
                      return const SizedBox(width: 0, height: 0);
                    }
                  }),
                  Builder(builder: (context) {
                    if (getCanteenData().uzivatel.varSymbol != null &&
                        getCanteenData().uzivatel.varSymbol != '') {
                      return Text(
                          'Variabilní Symbol: ${getCanteenData().uzivatel.varSymbol}');
                    } else {
                      return const SizedBox(width: 0, height: 0);
                    }
                  }),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text('Autojídelna')),
                  ),
                  FutureBuilder(
                    future: readData('statistika:objednavka'),
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return const Text('počet objednávek s autojídelnou: chyba při načítání dat');
                      }
                      else if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                        return Text('počet objednávek s autojídelnou: ${snapshot.data}');
                      }
                      else{
                        return const Text('počet objednávek s autojídelnou: 0');
                      }
                    }
                  ),
                  /*const Text('Pro verze: není dostupná'),
                  const Text('počet automatických objenávek: 0'),
                  const Text('počet objednávek chycených burza Catcherem: 0'),
                  const Divider(),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Nastavení')),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Zakoupit Pro')),*/
                ],
              ),
            );
          },
        ));
  }
}
