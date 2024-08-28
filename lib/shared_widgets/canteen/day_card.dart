import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/shared_widgets/canteen/food_section_list_tile.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayCard extends StatelessWidget {
  const DayCard({super.key, required this.jidelnicek});
  final Jidelnicek jidelnicek;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 0.6,
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).dividerTheme.color!)),
      margin: EdgeInsets.symmetric(horizontal: Spacing.s16, vertical: Spacing.s16),
      child: Column(
        children: [
          DayCardheader(date: jidelnicek.den),
          const CustomDivider(isTransparent: false),
          FoodSectionListTile(title: 'OBĚD', selection: jidelnicek.jidla),
        ],
      ),
    );
  }
}

class DayCardheader extends StatelessWidget {
  const DayCardheader({required this.date, super.key});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            DateFormat(DateFormat.YEAR_MONTH_DAY).format(date),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}