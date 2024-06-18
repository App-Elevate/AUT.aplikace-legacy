import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/methods_vars/get_correct_date_string.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';
import 'package:autojidelna/shared_widgets/settings/date_format_picker.dart';
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
        subtitle: Text(getCorrectDateString(dateFormat.read)),
        onTap: () {
          configuredDialog(context, builder: (context) => const DateFormatPicker());
        },
      ),
    );
  }
}
