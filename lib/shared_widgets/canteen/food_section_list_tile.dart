import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodSectionListTile extends StatelessWidget {
  const FoodSectionListTile({super.key, required this.title, required this.selection});
  final String title;
  final List<Jidlo> selection;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: timeOfDayFoodTitle(context, title),
      subtitle: Column(
        children: selection.asMap().entries.map((data) {
          int index = data.key;
          Jidlo jidlo = data.value;

          String nazev = (selection[index].kategorizovano?.hlavniJidlo ?? selection[index].nazev) == ''
              ? selection[index].nazev
              : (selection[index].kategorizovano?.hlavniJidlo ?? selection[index].nazev);

          return ListTile(
            //enabled: jidlo.lzeObjednat,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
            leading: Radio<bool>(
              value: jidlo.objednano,
              groupValue: true,
              onChanged: jidlo.lzeObjednat ? (data) {} : null,
            ),
            title: Text(nazev),
            subtitle: Text(NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toLanguageTag()).format(jidlo.cena)),
            trailing: IconButton(
              onPressed: () {}, // TODO: Push to detail page
              icon: Icon(
                Icons.info_outline,
                color: Theme.of(context).listTileTheme.subtitleTextStyle!.color,
                size: 24,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Text timeOfDayFoodTitle(BuildContext context, String text) => Text(text.toUpperCase(), style: Theme.of(context).textTheme.titleSmall);
}
