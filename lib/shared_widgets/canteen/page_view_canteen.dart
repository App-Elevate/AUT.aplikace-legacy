import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/methods_vars/portable_refresh.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/canteen/menu_of_the_day.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageViewCanteen extends StatelessWidget {
  const PageViewCanteen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: portableSoftRefresh,
      child: PageView.builder(
        controller: pageviewController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) {
          changeDate(index: value);
          context.read<DishesOfTheDay>().setDayIndex(value);
        },
        itemBuilder: (_, index) => MenuOfTheDay(index),
      ),
    );
  }
}
