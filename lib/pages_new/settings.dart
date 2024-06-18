import 'package:autojidelna/pages_new/appearance.dart';
import 'package:autojidelna/providers.dart';
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
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text("Appearance"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearanceScreen())),
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
            // TODO: implement this
            const SectionTitle("Data collection"),
            SwitchListTile(
              title: const Text("Sell your data"),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
