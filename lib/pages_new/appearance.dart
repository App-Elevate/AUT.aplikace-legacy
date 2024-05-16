import 'package:autojidelna/classes_enums/Spacing.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/settings/all_settings_widgets.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userPreferences = context.watch<UserPreferences>();
    final bool isBright = MediaQuery.platformBrightnessOf(context) == Brightness.light || userPreferences.themeMode == ThemeMode.light;
    final TextStyle? subtitleTextStyle = isBright ? null : const TextStyle(color: Colors.white54);

    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomDivider(),
            const SectionTitle("Theme"),
            CustomDivider(height: Spacing.short2, isTransparent: false),
            CustomDivider(height: Spacing.medium1),
            const ThemeModePicker(),
            CustomDivider(height: Spacing.medium2),
            const ThemeStylePicker(),
            CustomDivider(height: Spacing.medium1),
            SwitchListTile(
              title: const Text("Pure black dark mode"),
              subtitle: Text("If You Only Knew The Power Of The Dark Side...", style: subtitleTextStyle),
              value: userPreferences.isPureBlack,
              onChanged: isBright ? null : userPreferences.setPureBlack,
            ),
            CustomDivider(height: Spacing.medium1),
            const SectionTitle("Display"),
            CustomDivider(height: Spacing.short2, isTransparent: false),
            CustomDivider(height: Spacing.short1),
            // TODO: implement this
            SwitchListTile(
              title: const Text("List UI"),
              subtitle: Text("Old School!!!", style: subtitleTextStyle),
              value: userPreferences.isListUi,
              onChanged: userPreferences.setListUi,
            ),
            // TODO: implement this
            SwitchListTile(
              title: const Text("Big calendar markers"),
              value: userPreferences.bigCalendarMarkers,
              onChanged: userPreferences.setCalendarMarkers,
            ),
            // TODO: implement this
            SwitchListTile(
              title: const Text("Skip weekends"),
              value: userPreferences.skipWeekends,
              onChanged: userPreferences.setSkipWeekends,
            ),
          ],
        ),
      ),
    );
  }
}
