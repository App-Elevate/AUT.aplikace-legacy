import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/pages_new/appearance.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationPreferences notificationPreferences = context.watch<NotificationPreferences>();

    void pickTimeToSend() async {
      TimeOfDay savedTimeOfDay = notificationPreferences.sendTodaysFood;
      notificationPreferences.setSendTodaysFood = await showTimePicker(context: context, initialTime: savedTimeOfDay) ?? savedTimeOfDay;
    }

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
            SwitchListTile(
              title: const Text("Today's food"),
              value: notificationPreferences.todaysFood,
              onChanged: (value) => notificationPreferences.setTodaysFood = value,
            ),
            ListTile(
              title: const Text("Time?"),
              enabled: notificationPreferences.todaysFood,
              onTap: pickTimeToSend,
              trailing: OutlinedButton(
                onPressed: notificationPreferences.todaysFood ? pickTimeToSend : null,
                child: Text(notificationPreferences.sendTodaysFood.format(context)),
              ),
            ),
            SwitchListTile(
              title: const Text("Low Credit"),
              value: notificationPreferences.lowCredit,
              onChanged: (value) => notificationPreferences.setLowCredit = value,
            ),
            SwitchListTile(
              title: const Text("No food"),
              value: notificationPreferences.weekLongFamine,
              onChanged: (value) => notificationPreferences.setWeekLongFamine = value,
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
