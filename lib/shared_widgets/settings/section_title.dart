import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDivider(height: Spacing.s8),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * .9,
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        CustomDivider(height: Spacing.s8, isTransparent: false),
        CustomDivider(height: Spacing.s4),
      ],
    );
  }
}
