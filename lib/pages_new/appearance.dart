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

    const double height1 = 4;
    const double height2 = 8;
    const double height3 = 30;
    const double height4 = 38;

    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomDivider(),
            const SectionTitle("Theme"),
            const CustomDivider(height: height2, isTransparent: false),
            const CustomDivider(height: height3),
            const ThemeModePicker(),
            const CustomDivider(height: height4),
            const ThemeStylePicker(),
            const CustomDivider(height: height3),
            SwitchListTile(
              title: const Text("Pure black dark mode"),
              subtitle: Text("If You Only Knew The Power Of The Dark Side...", style: subtitleTextStyle),
              value: userPreferences.isPureBlack,
              onChanged: isBright ? null : (value) => userPreferences.setPureBlack = value,
            ),
            const CustomDivider(height: height3),
            const SectionTitle("Display"),
            const CustomDivider(height: height2, isTransparent: false),
            const CustomDivider(height: height1),
            // TODO: implement this
            SwitchListTile(
              title: const Text("List UI"),
              subtitle: Text("Old School!!!", style: subtitleTextStyle),
              value: userPreferences.isListUi,
              onChanged: (value) => userPreferences.setListUi = value,
            ),
            // TODO: implement this
            SwitchListTile(
              title: const Text("Big calendar markers"),
              value: userPreferences.bigCalendarMarkers,
              onChanged: (value) => userPreferences.setCalendarMarkers = value,
            ),
            // TODO: implement this
            SwitchListTile(
              title: const Text("Skip weekends"),
              value: userPreferences.skipWeekends,
              onChanged: (value) => userPreferences.setSkipWeekends = value,
            ),
          ],
        ),
      ),
    );
  }
}
