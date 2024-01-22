// Detail jídla

import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/shared_widgets/jidlo_widget.dart';

import 'package:canteenlib/canteenlib.dart';

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class JidloDetail extends StatelessWidget {
  const JidloDetail({
    super.key,
    required this.datumJidla,
    required this.indexJidlaVeDni,
    required this.indexDne,
    required this.refreshButtons,
    required this.jidelnicekListener,
    required this.ordering,
  });
  final DateTime datumJidla;
  final int indexDne;
  final Function(BuildContext context) refreshButtons;
  final ValueNotifier<Jidelnicek> jidelnicekListener;
  final ValueNotifier<bool> ordering;

  /// index jídla v jídelníčku dne (0 - první jídlo dne datumJidla)
  final int indexJidlaVeDni;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loggedInCanteen.getLunchesForDay(datumJidla),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          late Jidlo jidlo;
          try {
            jidlo = snapshot.data!.jidla[indexJidlaVeDni];
          } catch (e) {
            return FutureBuilder(
                future: loggedInCanteen.getLunchesForDay(datumJidla, requireNew: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return JidloDetail(
                        ordering: ordering,
                        datumJidla: datumJidla,
                        indexJidlaVeDni: indexJidlaVeDni,
                        indexDne: indexDne,
                        refreshButtons: refreshButtons,
                        jidelnicekListener: jidelnicekListener);
                  } else {
                    return const CircularProgressIndicator();
                  }
                });
          }
          String alergeny = '';
          for (Alergen alergen in jidlo.alergeny) {
            alergeny += '${alergen.nazev}, ';
          }
          if (alergeny.length > 2) {
            alergeny = alergeny.substring(0, alergeny.length - 2);
          }
          JidloKategorizovano jidloString = jidlo.kategorizovano!;
          List<Widget> jidloWidgets = [];
          //Soup
          if (jidloString.polevka != null && jidloString.polevka!.trim() != '') {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        Texts.soup,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        jidloString.polevka!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
            jidloWidgets.add(const Divider());
          }
          //Main Dish
          if (jidloString.hlavniJidlo != null && jidloString.hlavniJidlo!.trim() != '') {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        Texts.mainCourse.i18n(),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        jidloString.hlavniJidlo!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
            jidloWidgets.add(const Divider());
          }
          //Drinks
          if (jidloString.piti != null && jidloString.piti!.trim() != '') {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        Texts.drinks.i18n(),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        jidloString.piti!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
            jidloWidgets.add(const Divider());
          }
          //Side dish
          if (jidloString.salatovyBar != null && jidloString.salatovyBar!.trim() != '') {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        Texts.sideDish.i18n(),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        jidloString.salatovyBar!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
            jidloWidgets.add(const Divider());
          }
          //ostatni
          if (jidloString.ostatni != null && jidloString.ostatni!.trim() != '') {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        Texts.other.i18n(),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        jidloString.ostatni!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
            jidloWidgets.add(const Divider());
          }
          //Alergies
          if (alergeny.trim() != '') {
            jidloWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        Texts.allergens.i18n(),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        alergeny,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
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
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: ObjednatJidloTlacitko(
                ordering: ordering,
                indexJidlaVeDni: indexJidlaVeDni,
                indexDne: indexDne,
                jidelnicekListener: jidelnicekListener,
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
