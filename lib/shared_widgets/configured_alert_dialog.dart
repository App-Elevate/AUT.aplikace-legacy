import 'package:autojidelna/lang/l10n_global.dart';
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
      titlePadding: const EdgeInsets.only(top: 4),
      contentPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      title: SectionTitle(title),
      content: SizedBox(width: MediaQuery.sizeOf(context).width * .75, child: content),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CustomDivider(height: 4),
            const CustomDivider(height: 8, isTransparent: false),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...actions,
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    visualDensity: const VisualDensity(vertical: -4),
                    padding: const EdgeInsets.only(right: 16),
                  ),
                  child: Text(lang.cancel),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
