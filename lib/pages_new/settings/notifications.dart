import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:autojidelna/shared_widgets/settings/time_picker_todays_food.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ScrollViewColumn(
        children: [
          const SectionTitle("Notifications"),
          const TimePickerTodaysFoodTiles(),
          Selector<NotificationPreferences, ({bool read, Function(bool) set})>(
            selector: (_, p1) => (read: p1.lowCredit, set: p1.setLowCredit),
            builder: (context, lowCredit, child) => SwitchListTile(
              title: const Text("Low Credit"),
              value: lowCredit.read,
              onChanged: lowCredit.set,
            ),
          ),
          Selector<NotificationPreferences, ({bool read, Function(bool) set})>(
            selector: (_, p1) => (read: p1.weekLongFamine, set: p1.setWeekLongFamine),
            builder: (context, weekLongFamine, child) => SwitchListTile(
              title: const Text("No food"),
              value: weekLongFamine.read,
              onChanged: weekLongFamine.set,
            ),
          ),
        ],
      ),
    );
  }
}
