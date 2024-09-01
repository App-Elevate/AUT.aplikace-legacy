import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/portable_refresh.dart';
import 'package:autojidelna/methods_vars/widgets_tracking.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/canteen/page_view_food_card.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DishList extends StatelessWidget {
  const DishList(this.dayIndex, {super.key});
  final int dayIndex;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: portableSoftRefresh,
      child: Consumer<DishesOfTheDay>(
        builder: (_, data, child) {
          Jidelnicek? menu = data.getMenu(dayIndex);
          if (menu == null) return const Center(child: CircularProgressIndicator());
          List<Jidlo> dishList = menu.jidla;

          // Second layer fix pro api returning garbage when switching orders
          try {
            if (dishList.length < numberOfMaxLunches) {
              Future.delayed(const Duration(milliseconds: 300)).then((_) async {
                Jidelnicek jidelnicekNovy = (await loggedInCanteen.getLunchesForDay(dateListener.value, requireNew: true));
                if (dishList.length < jidelnicekNovy.jidla.length) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => data.setMenu(dayIndex, jidelnicekNovy));
                }
              });
            }
          } catch (e) {
            // We're fine if it fails. Something else will scream instead
          }

          if (dishList.isEmpty) return child!;

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
