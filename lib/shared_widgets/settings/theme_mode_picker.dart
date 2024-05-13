import 'package:autojidelna/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeModePicker extends StatelessWidget {
  const ThemeModePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPreferences>(
      builder: (context, value, child) => SegmentedButton<ThemeMode>(
        showSelectedIcon: false,
        selected: {value.themeMode},
        onSelectionChanged: (Set<ThemeMode> selected) => value.setThemeMode = selected.first,
        segments: const [
          ButtonSegment<ThemeMode>(value: ThemeMode.system, label: Text("System")),
          ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text("Light")),
          ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text("Dark")),
        ],
      ),
    );
  }
}
