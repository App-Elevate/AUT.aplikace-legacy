import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/methods_vars/capitalize.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabletUiPicker extends StatelessWidget {
  const TabletUiPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 4),
      contentPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * .1),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      title: const SectionTitle("Tablet UI"),
      content: Selector<AppearancePreferences, ({TabletUi read, Function(TabletUi) set})>(
        selector: (_, p1) => (read: p1.tabletUi, set: p1.setTabletUi),
        builder: (context, tabletUi, child) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: TabletUi.values.map((format) {
              TabletUi pickedFormat = tabletUi.read;

              return ListTile(
                minVerticalPadding: 0,
                visualDensity: const VisualDensity(vertical: -4),
                title: Text(capitalize(EnumToString.convertToString(format))),
                titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                trailing: pickedFormat == format ? const Icon(Icons.check) : null,
                onTap: () {
                  tabletUi.set(format);
                  Navigator.pop(context);
                },
              );
            }).toList(),
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
