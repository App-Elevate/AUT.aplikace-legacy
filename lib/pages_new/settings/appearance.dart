import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/methods_vars/get_correct_date_string.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:autojidelna/shared_widgets/settings/all_settings_widgets.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/date_format_picker.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = context.select<Settings, ThemeMode>((value) => value.themeMode) == ThemeMode.light;
    final bool isBright = MediaQuery.platformBrightnessOf(context) == Brightness.light || isLightMode;

    return Scaffold(
      appBar: AppBar(title: Text(lang.settingsAppearence)),
      body: ScrollViewColumn(
        children: [
          SectionTitle(lang.settingsTheme),
          const CustomDivider(height: 24),
          // theme mode picker
          const ThemeModePicker(),
          const CustomDivider(height: 38),
          // theme style picker
          const ThemeStylePicker(),
          const CustomDivider(height: 30),
          // pure black mode switch
          Selector<Settings, ({bool read, Function(bool) set})>(
            selector: (_, p1) => (read: p1.isPureBlack, set: p1.setPureBlack),
            builder: (context, pureBlack, child) => SwitchListTile(
              title: Text(lang.settingsAmoled),
              subtitle: Text(lang.settingsAmoledSub),
              value: pureBlack.read,
              onChanged: isBright ? null : pureBlack.set,
            ),
          ),
          SectionTitle(lang.settingsDisplay),
          // TODO: const TabletUiButton(),
          /* TODO: add this
          Selector<Settings, ({bool read, Function(bool) set, DateFormatOptions format})>(
            selector: (_, p1) => (read: p1.relTimeStamps, set: p1.setRelTimeStamps, format: p1.dateFormat),
            builder: (context, relTimeStamps, child) => SwitchListTile(
              title: Text(lang.settingsRelativeTimestamps),
              subtitle: Text(lang.settingsRelativeTimestampsSub(getCorrectDateString(relTimeStamps.format))),
              value: relTimeStamps.read,
              onChanged: relTimeStamps.set,
            ),
          ),*/
          const DateFormatPickerButton(),
        ],
      ),
    );
  }
}
