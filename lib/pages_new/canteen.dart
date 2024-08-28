import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/calendar_buttons.dart';
import 'package:autojidelna/shared_widgets/canteen/list_view_canteen.dart';
import 'package:autojidelna/shared_widgets/canteen/page_view_canteen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CanteenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CanteenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const CalendarButton(),
      actions: const [
        TodayButton(),
        VerticalDivider(color: Colors.transparent, width: 16),
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
    return Selector<AppearancePreferences, bool>(
      selector: (_, p1) => p1.isListUi,
      builder: (context, data, child) => data ? const ListViewCanteen() : const PageViewCanteen(),
    );
  }
}
