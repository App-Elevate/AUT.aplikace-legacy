import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/methods_vars/ordering.dart';
import 'package:autojidelna/providers.dart';
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
      child: Consumer<Ordering>(
        builder: (context, prov, ___) {
          ColorScheme colorScheme = Theme.of(context).colorScheme;
          StavJidla stavJidla = getStavJidla(dish);
          bool isPrimary = getPrimaryState(stavJidla);

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isPrimary ? colorScheme.primary : colorScheme.secondary,
              foregroundColor: isPrimary ? colorScheme.onPrimary : colorScheme.onSecondary,
            ),
            onPressed: prov.ordering || !isButtonEnabled(stavJidla) ? null : () => pressed(context, dish, stavJidla),
            child: Text(getObedText(context, dish, stavJidla)),
          );
        },
      ),
    );
  }
}
