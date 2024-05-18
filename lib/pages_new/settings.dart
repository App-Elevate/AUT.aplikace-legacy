import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/pages_new/appearance.dart';
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
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text("Appearance"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearanceScreen())),
            ),
            CustomDivider(height: Spacing.short1),
            const SectionTitle("Notification"),
            CustomDivider(height: Spacing.short2, isTransparent: false),
            CustomDivider(height: Spacing.short1),
            const TimePickerTodaysFoodTiles(),
            Selector<NotificationPreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.lowCredit, set: p1.setLowCredit),
              builder: (context, notificationPreferences, child) => SwitchListTile(
                title: const Text("Low Credit"),
                value: notificationPreferences.read,
                onChanged: notificationPreferences.set,
              ),
            ),
            Selector<NotificationPreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.weekLongFamine, set: p1.setWeekLongFamine),
              builder: (context, notificationPreferences, child) => SwitchListTile(
                title: const Text("No food"),
                value: notificationPreferences.read,
                onChanged: notificationPreferences.set,
              ),
            ),
            CustomDivider(height: Spacing.short2),
            const SectionTitle("Data collection"),
            CustomDivider(height: Spacing.short2, isTransparent: false),
            CustomDivider(height: Spacing.short1),
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
