import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/methods_vars/capitalize.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';
import 'package:autojidelna/shared_widgets/settings/tablet_ui_picker.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabletUiButton extends StatelessWidget {
  const TabletUiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AppearancePreferences, ({TabletUi read})>(
      selector: (_, p1) => (read: p1.tabletUi),
      builder: (context, tabletUi, child) => ListTile(
        title: const Text("Tablet UI"),
        subtitle: Text(capitalize(EnumToString.convertToString(tabletUi.read))),
        onTap: () => configuredDialog(context, builder: (context) => const TabletUiPicker()),
      ),
    );
  }
}
