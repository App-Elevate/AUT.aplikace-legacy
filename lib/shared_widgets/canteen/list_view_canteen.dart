import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/shared_widgets/canteen/day_card.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListViewCanteen extends StatelessWidget {
  const ListViewCanteen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      initialScrollIndex: convertDateTimeToIndex(DateTime.now()),
      itemCount: minimalDate.difference(DateTime.now().add(const Duration(days: 2 * 365))).inDays.abs(),
      itemBuilder: (context, index) => DayCard(index),
    );
  }
}
