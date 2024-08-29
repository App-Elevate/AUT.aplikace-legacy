import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/methods_vars/portable_refresh.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/canteen/page_view_food_card.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DishList extends StatelessWidget {
  const DishList({super.key});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: portableSoftRefresh,
      child: Selector<DishesOfTheDay, Jidelnicek>(
        selector: (_, p1) => p1.menu,
        builder: (context, menu, child) {
          List<Jidlo> dishList = menu.jidla;
          if (dishList.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {});
            return child!;
          }

          return ListView.builder(
            itemCount: dishList.length,
            padding: const EdgeInsets.symmetric(vertical: 24),
            itemBuilder: (_, index) => PageViewFoodCard(dishList[index]),
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).height / 2 - 100),
              child: Text(lang.noFood),
            ),
          ),
        ),
      ),
    );
  }
}
