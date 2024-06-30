import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';

class ConfiguredAlertDialog extends StatelessWidget {
  const ConfiguredAlertDialog({super.key, required this.title, required this.content, this.actions = const []});
  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: Spacing.s4),
      contentPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.fromLTRB(Spacing.zero, Spacing.zero, Spacing.s8, Spacing.s8),
      title: SectionTitle(title),
      content: SizedBox(width: MediaQuery.sizeOf(context).width * .75, child: content),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomDivider(height: Spacing.s4),
            CustomDivider(height: Spacing.s8, isTransparent: false),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...actions,
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
        ),
      ],
    );
  }
}
