import 'package:autojidelna/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeModePicker extends StatelessWidget {
  const ThemeModePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .9,
      child: Selector<UserPreferences, ({ThemeMode read, Function(ThemeMode) set})>(
        selector: (_, userPreferences) => (read: userPreferences.themeMode, set: userPreferences.setThemeMode),
        builder: (_, userPreferences, __) => SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          selected: {userPreferences.read},
          onSelectionChanged: (Set<ThemeMode> selected) => userPreferences.set(selected.first),
          segments: const [
            ButtonSegment<ThemeMode>(value: ThemeMode.system, label: Text("System")),
            ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text("Light")),
            ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text("Dark")),
          ],
        ),
      ),
    );
  }
}
