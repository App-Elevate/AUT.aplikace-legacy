import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/shared_widgets/canteen/day_card.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListViewCanteen extends StatefulWidget {
  const ListViewCanteen({super.key});

  @override
  State<ListViewCanteen> createState() => _ListViewCanteenState();
}

class _ListViewCanteenState extends State<ListViewCanteen> {
  @override
  void initState() {
    super.initState();

    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();

    itemPositionsListener!.itemPositions.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    itemPositionsListener!.itemPositions.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      initialScrollIndex: convertDateTimeToIndex(dateListener.value),
      itemCount: minimalDate.difference(maximalDate).inDays.abs(),
      itemBuilder: (context, index) => DayCard(index),
    );
  }

  /// Used to change the date in calendar button
  void _listener() {
    final positions = itemPositionsListener!.itemPositions.value.toList();
    // Sort positions by itemLeadingEdge to ensure the top item is at the beginning
    positions.sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge));

    if (positions.isEmpty) return;

    final topItem = positions.first;

    // Include the first item only if more than 10% of it is visible
    if (topItem.itemTrailingEdge > .05) {
      dateListener.value = convertIndexToDatetime(topItem.index);
    }
  }
}
