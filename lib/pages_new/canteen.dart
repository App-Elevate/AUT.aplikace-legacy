import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/shared_widgets/calendar_buttons.dart';
import 'package:flutter/material.dart';

class CanteenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CanteenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const CalendarButton(),
      actions: [
        const TodayButton(),
        VerticalDivider(color: Colors.transparent, width: Spacing.s16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CanteenPage extends StatelessWidget {
  const CanteenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
