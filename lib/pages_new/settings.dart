import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/pages_new/appearance.dart';
import 'package:autojidelna/pages_new/data_collection.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:autojidelna/shared_widgets/settings/time_picker_todays_food.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomDivider(height: Spacing.s4),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text("Appearance"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearanceScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.cookie_outlined),
              title: const Text("Data Collection"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DataCollectionScreen())),
            ),
            const SectionTitle("Convenience"),
            // TODO: implement this
            // skip weekends switch
            Selector<AppearancePreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.skipWeekends, set: p1.setSkipWeekends),
              builder: (context, skipWeekends, child) => SwitchListTile(
                title: const Text("Skip weekends"),
                value: skipWeekends.read,
                onChanged: skipWeekends.set,
              ),
            ),
            // TODO: implement this
            // big calendar markers switch
            Selector<AppearancePreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.bigCalendarMarkers, set: p1.setCalendarMarkers),
              builder: (context, bigCalendarMarkers, child) => SwitchListTile(
                title: const Text("Big calendar markers"),
                value: bigCalendarMarkers.read,
                onChanged: bigCalendarMarkers.set,
              ),
            ),
            // TODO: implement this
            const SectionTitle("Notification"),
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
      ),
    );
  }
}
