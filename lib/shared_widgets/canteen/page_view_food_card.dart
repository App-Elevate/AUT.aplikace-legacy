import 'package:autojidelna/pages_new/dish_detail.dart';
import 'package:autojidelna/shared_widgets/canteen/order_dish_button.dart';
import 'package:autojidelna/shared_widgets/lined_card.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageViewFoodCard extends StatelessWidget {
  const PageViewFoodCard(this.dish, {super.key});
  final Jidlo dish;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: LinedCard(
        smallButton: false,
        transparentFooterDivider: true,
        title: dish.varianta,
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DishDetail())),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -4),
              title: Text(dish.kategorizovano!.hlavniJidlo!),
              subtitle: Text(NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toLanguageTag()).format(dish.cena)),
            ),
            const CustomDivider(height: 8),
            OrderDishButton(dish),
          ],
        ),
      ),
    );
  }
}
