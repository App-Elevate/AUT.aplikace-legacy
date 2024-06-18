import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/methods_vars/get_correct_date_string.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateFormatPicker extends StatelessWidget {
  const DateFormatPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 4),
      contentPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      title: const SectionTitle("Date Format"),
      content: Selector<UserPreferences, ({DateFormat read, Function(DateFormat) set})>(
        selector: (_, p1) => (read: p1.dateFormat, set: p1.setDateFormat),
        builder: (context, dateFormat, child) => SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * .8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: DateFormat.values.map((format) {
                DateFormat pickedFormat = dateFormat.read;

                return ListTile(
                  minVerticalPadding: 0,
                  visualDensity: const VisualDensity(vertical: -4),
                  title: Text(getCorrectDateString(format)),
                  titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                  trailing: pickedFormat == format ? const Icon(Icons.check) : null,
                  onTap: () {
                    dateFormat.set(format);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomDivider(height: Spacing.s4),
            CustomDivider(height: Spacing.s8, isTransparent: false),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
                visualDensity: const VisualDensity(vertical: -4),
                padding: EdgeInsets.only(right: Spacing.s16),
              ),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ],
    );
  }
}
