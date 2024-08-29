import 'package:autojidelna/methods_vars/ordering.dart';
import 'package:autojidelna/pages_new/dish_detail.dart';
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
          Jidlo dish = data.value;

          String title = (selection[index].kategorizovano?.hlavniJidlo ?? selection[index].nazev) == ''
              ? selection[index].nazev
              : (selection[index].kategorizovano?.hlavniJidlo ?? selection[index].nazev);

          return _DishListTile(dish: dish, title: title);
        }).toList(),
      ),
    );
  }

  Text timeOfDayFoodTitle(BuildContext context, String text) => Text(text.toUpperCase(), style: Theme.of(context).textTheme.titleSmall);
}

class _DishListTile extends StatelessWidget {
  const _DishListTile({required this.dish, required this.title});

  final Jidlo dish;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: dish.lzeObjednat,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      titleTextStyle: Theme.of(context).textTheme.bodyMedium,
      leading: Radio<bool>(
        value: dish.objednano,
        groupValue: true,
        onChanged: dish.lzeObjednat ? (_) => pressed(context, dish, getStavJidla(dish)) : null,
      ),
      title: Text(title),
      subtitle:
          dish.cena == null ? null : Text(NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toLanguageTag()).format(dish.cena)),
      trailing: _detailButton(context),
    );
  }

  IconButton _detailButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DishDetail())),
      icon: Icon(
        Icons.info_outline,
        color: Theme.of(context).listTileTheme.subtitleTextStyle!.color,
        size: 24,
      ),
    );
  }
}
