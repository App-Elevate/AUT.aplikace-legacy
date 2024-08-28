import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/datetime_wrapper.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/canteen/dish_list.dart';
import 'package:autojidelna/shared_widgets/canteen/error_loading_data.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuOfTheDay extends StatelessWidget {
  const MenuOfTheDay(this.dayIndex, {super.key});
  final int dayIndex;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DishesOfTheDay()..setDayIndex(dayIndex),
      child: const _MenuContent(),
    );
  }
}

class _MenuContent extends StatelessWidget {
  const _MenuContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<DishesOfTheDay>(
      builder: (context, data, child) {
        return FutureBuilder(
          future: loggedInCanteen.getLunchesForDay(convertIndexToDatetime(data.dayIndex)),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const ErrorLoadingData();

            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

            // Check if widget is still in tree
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) data.setMenu(snapshot.data as Jidelnicek);
            });

            return const DishList();
          },
        );
      },
    );
  }
}