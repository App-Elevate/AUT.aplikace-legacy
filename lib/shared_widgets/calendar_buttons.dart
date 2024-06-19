import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/methods_vars/get_correct_date_string.dart';
import 'package:autojidelna/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.calendar_month_outlined),
        label: Selector<AppearancePreferences, ({DateFormat read})>(
          selector: (_, p1) => (read: p1.dateFormat),
          builder: (context, dateFormat, _) => Text(getCorrectDateString(dateFormat.read)),
        ),
      ),
    );
  }
}

class TodayButton extends StatelessWidget {
  const TodayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 35,
      child: MaterialButton(
        textColor: Theme.of(context).colorScheme.onSurfaceVariant,
        padding: EdgeInsets.zero,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.s16),
          side: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant, width: 1.75),
        ),
        child: Text(DateTime.now().day.toString()),
        onPressed: () {
          //changeDate(newDate: DateTime.now(), animateToPage: true);
        },
      ),
    );
  }
}
