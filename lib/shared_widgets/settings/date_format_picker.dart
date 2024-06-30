import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/methods_vars/get_correct_date_string.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/configured_alert_dialog.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateFormatPickerButton extends StatelessWidget {
  const DateFormatPickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AppearancePreferences, ({DateFormat read})>(
      selector: (_, p1) => (read: p1.dateFormat),
      builder: (context, dateFormat, child) => ListTile(
        title: const Text("Date format"),
        subtitle: Text(getCorrectDateString(dateFormat.read, inSettings: true)),
        onTap: () => configuredDialog(context, builder: (context) => const DateFormatPicker()),
      ),
    );
  }
}

class DateFormatPicker extends StatelessWidget {
  const DateFormatPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfiguredAlertDialog(
      title: "Date Format",
      content: Selector<AppearancePreferences, ({DateFormat read, Function(DateFormat) set})>(
        selector: (_, p1) => (read: p1.dateFormat, set: p1.setDateFormat),
        builder: (context, dateFormat, child) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: DateFormat.values
                .map(
                  (format) => ListTile(
                    minVerticalPadding: 0,
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(getCorrectDateString(format, inSettings: true)),
                    titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                    trailing: dateFormat.read == format ? const Icon(Icons.check) : null,
                    onTap: () {
                      dateFormat.set(format);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
