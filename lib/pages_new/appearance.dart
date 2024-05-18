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
    final bool isLightMode = context.select<UserPreferences, ThemeMode>((value) => value.themeMode) == ThemeMode.light;
    final bool isBright = MediaQuery.platformBrightnessOf(context) == Brightness.light || isLightMode;
    final TextStyle? subtitleTextStyle = isBright ? null : const TextStyle(color: Colors.white54);

    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SectionTitle("Theme"),
            CustomDivider(height: Spacing.medium1),
            // theme mode picker
            const ThemeModePicker(),
            CustomDivider(height: Spacing.medium2),
            // theme style picker
            const ThemeStylePicker(),
            CustomDivider(height: Spacing.medium1),
            // pure black mode switch
            Selector<UserPreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.isPureBlack, set: p1.setPureBlack),
              builder: (context, pureBlack, child) => SwitchListTile(
                title: const Text("Pure black dark mode"),
                subtitle: Text("If You Only Knew The Power Of The Dark Side...", style: subtitleTextStyle),
                value: pureBlack.read,
                onChanged: isBright ? null : pureBlack.set,
              ),
            ),
            const SectionTitle("Display"),
            // TODO: implement this
            // list UI switch
            Selector<UserPreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.isListUi, set: p1.setListUi),
              builder: (context, listUi, child) => SwitchListTile(
                title: const Text("List UI"),
                subtitle: Text("Old School!!!", style: subtitleTextStyle),
                value: listUi.read,
                onChanged: listUi.set,
              ),
            ),
            // TODO: implement this
            // big calendar markers switch
            Selector<UserPreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.bigCalendarMarkers, set: p1.setCalendarMarkers),
              builder: (context, bigCalendarMarkers, child) => SwitchListTile(
                title: const Text("Big calendar markers"),
                value: bigCalendarMarkers.read,
                onChanged: bigCalendarMarkers.set,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
