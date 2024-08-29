import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/methods_vars/string_extention.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';
import 'package:autojidelna/shared_widgets/configured_alert_dialog.dart';
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
        title: Text(lang.tabletUi),
        subtitle: Text(EnumToString.convertToString(tabletUi.read).capitalize()),
        onTap: () => configuredDialog(context, builder: (context) => const TabletUiPicker()),
      ),
    );
  }
}

class TabletUiPicker extends StatelessWidget {
  const TabletUiPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfiguredAlertDialog(
      title: "Tablet UI",
      content: Selector<AppearancePreferences, ({TabletUi read, Function(TabletUi) set})>(
        selector: (_, p1) => (read: p1.tabletUi, set: p1.setTabletUi),
        builder: (context, tabletUi, child) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: TabletUi.values
                .map(
                  (format) => ListTile(
                    minVerticalPadding: 0,
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(EnumToString.convertToString(format).capitalize()),
                    titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                    trailing: tabletUi.read == format ? const Icon(Icons.check) : null,
                    onTap: () {
                      tabletUi.set(format);
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
