import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/methods_vars/ordering.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/canteen/burzaAlertDialog.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDishButton extends StatelessWidget {
  const OrderDishButton(this.dish, {super.key});
  final Jidlo dish;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Consumer<DishesOfTheDay>(
        builder: (context, data, ___) {
          Jidelnicek? menu = data.getMenu(convertDateTimeToIndex(dish.den));
          Jidlo updatedDish = menu!.jidla.where((e) => e.nazev == dish.nazev).first;

          return Consumer<Ordering>(
            builder: (context, prov, ___) {
              ColorScheme colorScheme = Theme.of(context).colorScheme;
              StavJidla stavJidla = getStavJidla(updatedDish);
              bool isPrimary = getPrimaryState(stavJidla);
              bool burzaColor = stavJidla == StavJidla.objednanoNelzeOdebrat;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPrimary
                      ? burzaColor
                          ? colorScheme.tertiary
                          : colorScheme.primary
                      : colorScheme.secondary,
                  foregroundColor: isPrimary
                      ? burzaColor
                          ? colorScheme.onTertiary
                          : colorScheme.onPrimary
                      : colorScheme.onSecondary,
                ),
                onPressed: prov.ordering || !isButtonEnabled(stavJidla) ? null : () => burzaAlertDialog(context, updatedDish, stavJidla),
                child: Text(getObedText(context, updatedDish, stavJidla)),
              );
            },
          );
        },
      ),
    );
  }
}
