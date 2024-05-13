import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/settings/all_settings_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userPreferences = context.watch<UserPreferences>();
    final bool isBright = MediaQuery.platformBrightnessOf(context) == Brightness.light || userPreferences.themeMode == ThemeMode.light;
    final TextStyle? subtitleTextStyle = isBright ? null : const TextStyle(color: Colors.white38);

    return SingleChildScrollView(
      child: Column(
        children: [
          const ThemeModePicker(),
          const ThemeStylePicker(),
          SwitchListTile(
            title: const Text("Pure black dark mode"),
            subtitle: Text("If You Only Knew The Power Of The Dark Side...", style: subtitleTextStyle),
            value: userPreferences.isPureBlack,
            onChanged: isBright ? null : (value) => userPreferences.setPureBlack = value,
          ),
          SwitchListTile(
            title: const Text("List UI"),
            subtitle: Text("This is a test", style: subtitleTextStyle),
            value: userPreferences.isListUi,
            onChanged: (value) => userPreferences.setListUi = value,
          ),
          SwitchListTile(
            title: const Text("Big calendar markers"),
            value: userPreferences.bigCalendarMarkers,
            onChanged: (value) => userPreferences.setCalendarMarkers = value,
          ),
        ],
      ),
    );
  }
}
