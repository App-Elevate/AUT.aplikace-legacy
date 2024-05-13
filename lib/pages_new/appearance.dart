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

    final double height1 = MediaQuery.sizeOf(context).height * 0.035;
    final double height2 = MediaQuery.sizeOf(context).height * 0.045;
    final double height3 = MediaQuery.sizeOf(context).height * 0.005;

    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomDivider(),
            const SectionTitle("Theme"),
            const CustomDivider(height: 8, isTransparent: false),
            CustomDivider(height: height1),
            const ThemeModePicker(),
            CustomDivider(height: height2),
            const ThemeStylePicker(),
            CustomDivider(height: height1),
            SwitchListTile(
              title: const Text("Pure black dark mode"),
              subtitle: Text("If You Only Knew The Power Of The Dark Side...", style: subtitleTextStyle),
              value: userPreferences.isPureBlack,
              onChanged: isBright ? null : (value) => userPreferences.setPureBlack = value,
            ),
            CustomDivider(height: height1),
            const SectionTitle("Display"),
            const CustomDivider(height: 8, isTransparent: false),
            CustomDivider(height: height3),
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
