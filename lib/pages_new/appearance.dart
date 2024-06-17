import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/settings/all_settings_widgets.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = context.select<UserPreferences, ThemeMode>((value) => value.themeMode) == ThemeMode.light;
    final bool isBright = MediaQuery.platformBrightnessOf(context) == Brightness.light || isLightMode;

    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SectionTitle("Theme"),
            CustomDivider(height: Spacing.s30),
            // theme mode picker
            const ThemeModePicker(),
            CustomDivider(height: Spacing.s38),
            // theme style picker
            const ThemeStylePicker(),
            CustomDivider(height: Spacing.s30),
            // pure black mode switch
            Selector<UserPreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.isPureBlack, set: p1.setPureBlack),
              builder: (context, pureBlack, child) => SwitchListTile(
                title: const Text("Pure black dark mode"),
                subtitle: const Text("If You Only Knew The Power Of The Dark Side..."),
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
                subtitle: const Text("Old School!!!"),
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
            Selector<UserPreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.relTimeStamps, set: p1.setRelTimeStamps),
              builder: (context, relTimeStamps, child) => SwitchListTile(
                title: const Text("Relative timestamps"),
                subtitle: const Text("Today instead of 1.1.2024"),
                value: relTimeStamps.read,
                onChanged: relTimeStamps.set,
              ),
            ),
            Selector<UserPreferences, ({DateFormat read, Function(DateFormat) set})>(
              selector: (_, p1) => (read: p1.dateFormat, set: p1.setDateFormat),
              builder: (context, dateFormat, child) => ListTile(
                title: const Text("Date format"),
                subtitle: Text(EnumToString.convertToString(dateFormat.read)),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
