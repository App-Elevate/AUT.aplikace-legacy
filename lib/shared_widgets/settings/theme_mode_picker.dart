import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeModePicker extends StatelessWidget {
  const ThemeModePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .9,
      child: Selector<AppearancePreferences, ({ThemeMode read, Function(ThemeMode) set})>(
        selector: (_, p1) => (read: p1.themeMode, set: p1.setThemeMode),
        builder: (_, themeMode, __) => SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          selected: {themeMode.read},
          onSelectionChanged: (Set<ThemeMode> selected) => themeMode.set(selected.first),
          segments: [
            ButtonSegment<ThemeMode>(value: ThemeMode.system, label: Text(lang.systemThemeMode)),
            ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text(lang.lightThemeMode)),
            ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text(lang.darkThemeMode)),
          ],
        ),
      ),
    );
  }
}
