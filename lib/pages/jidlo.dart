import 'package:autojidelna/every_import.dart';

class JidloDetail extends StatelessWidget {
  const JidloDetail({
    super.key,
    required this.datumJidla,
    required this.indexJidlaVeDni,
    required this.indexDne,
    required this.refreshButtons,
    required this.jidlaListener,
  });
  final DateTime datumJidla;
  final int indexDne;
  final Function(BuildContext context) refreshButtons;
  final ValueNotifier<dynamic> jidlaListener;

  /// index jídla v jídelníčku dne (0 - první jídlo dne datumJidla)
  final int indexJidlaVeDni;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLunchesForDay(datumJidla),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Jidlo jidlo = snapshot.data!.jidla[indexJidlaVeDni];
            ParsedFoodString jidloString = parseJidlo(jidlo.nazev);
            List<Widget> jidloWidgets = [];
            //Soup
            if (jidloString.polevka != null) {
              jidloWidgets.add(
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Polévka',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(
                          jidloString.polevka!,
                          textStyle: const TextStyle(fontSize: 20, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              jidloWidgets.add(const Divider());
            }
            //Main Dish
            if (jidloString.hlavniJidlo != null) {
              jidloWidgets.add(
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hlavní chod',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(
                          jidloString.hlavniJidlo!,
                          textStyle: const TextStyle(fontSize: 20, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              jidloWidgets.add(const Divider());
            }
            //Drinks
            if (jidloString.piti != null) {
              jidloWidgets.add(
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pití',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(
                          jidloString.piti!,
                          textStyle: const TextStyle(fontSize: 20, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              jidloWidgets.add(const Divider());
            }
            //Side dish
            if (jidloString.salatovyBar != null) {
              jidloWidgets.add(
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Přílohy',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(
                          jidloString.salatovyBar!,
                          textStyle: const TextStyle(fontSize: 20, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              jidloWidgets.add(const Divider());
            }
            //Alergies
            if (jidloString.alergeny != null) {
              jidloWidgets.add(
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alergeny',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(
                          jidloString.alergeny!,
                          textStyle: const TextStyle(fontSize: 20, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              jidloWidgets.add(const Divider());
            }
            jidloWidgets.add(
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: ObjednatJidloTlacitko(
                    refreshButtons: refreshButtons,
                    indexJidlaVeDni: indexJidlaVeDni,
                    indexDne: indexDne,
                    jidlaListener: jidlaListener),
              ),
            );
            return Scaffold(
              appBar: AppBar(
                title: Text(jidlo.varianta),
                centerTitle: true,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: jidloWidgets,
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
