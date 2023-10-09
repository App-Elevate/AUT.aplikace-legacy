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
  final ValueNotifier<List<Jidlo>> jidlaListener;

  /// index jídla v jídelníčku dne (0 - první jídlo dne datumJidla)
  final int indexJidlaVeDni;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLunchesForDay(datumJidla),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            Jidlo jidlo = snapshot.data!.jidla[indexJidlaVeDni];
            ParsedFoodString jidloString = parseJidlo(jidlo.nazev);
            List<Widget> jidloWidgets = [];
            //Soup
            if (jidloString.polevka != null) {
              jidloWidgets.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Polévka'),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(jidloString.polevka!),
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
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hlavní chod'),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(jidloString.hlavniJidlo!),
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
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pití'),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(jidloString.piti!),
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
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Přílohy'),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(jidloString.salatovyBar!),
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
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Alergeny'),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(jidloString.alergeny!),
                      ),
                    ],
                  ),
                ),
              );
              jidloWidgets.add(const Divider());
            }
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: ObjednatJidloTlacitko(
                    refreshButtons: refreshButtons, indexJidlaVeDni: indexJidlaVeDni, indexDne: indexDne, jidlaListener: jidlaListener),
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
