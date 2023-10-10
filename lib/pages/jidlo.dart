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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Polévka',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: HtmlWidget(
                        jidloString.polevka!,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          jidloWidgets.add(const Divider());
          //Main Dish
          if (jidloString.hlavniJidlo != null) {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Hlavní chod',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: HtmlWidget(
                        jidloString.hlavniJidlo!,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          jidloWidgets.add(const Divider());
          //Drinks
          if (jidloString.piti != null) {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Pití',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: HtmlWidget(
                        jidloString.piti!,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          jidloWidgets.add(const Divider());
          //Side dish
          if (jidloString.salatovyBar != null) {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Přílohy',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: HtmlWidget(
                        jidloString.salatovyBar!,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          jidloWidgets.add(const Divider());
          //Alergies
          if (jidloString.alergeny != null) {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Alergeny',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: HtmlWidget(
                        jidloString.alergeny!,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );

            jidloWidgets.add(const Divider());
            jidloWidgets.add(const SizedBox(
              height: 30,
            ));
          }
          jidloWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: ObjednatJidloTlacitko(
                refreshButtons: refreshButtons,
                indexJidlaVeDni: indexJidlaVeDni,
                indexDne: indexDne,
                jidlaListener: jidlaListener,
              ),
            ),
          );
          return Scaffold(
            appBar: AppBar(
              title: Text(jidlo.varianta),
            ),
            body: SingleChildScrollView(
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
      },
    );
  }
}
