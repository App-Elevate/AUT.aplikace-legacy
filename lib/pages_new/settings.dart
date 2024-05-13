import 'package:autojidelna/app_themes.dart';
import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/providers.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<UserPreferences>(
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
          ),
          SizedBox(
            height: 225,
            child: Consumer<UserPreferences>(
              builder: (context, userPreferences, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(5),
                  itemCount: ThemeStyle.values.length,
                  itemBuilder: (context, index) {
                    final theme = Themes.getTheme(ThemeStyle.values[index], isPureBlack: userPreferences.isPureBlack);
                    return Theme(
                      data: theme,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: OutlinedButton(
                          clipBehavior: Clip.hardEdge,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            fixedSize: const Size.fromWidth(125),
                            padding: EdgeInsets.zero,
                            side: BorderSide(
                              width: 3,
                              strokeAlign: BorderSide.strokeAlignInside,
                              color: ThemeStyle.values[index] == userPreferences.themeStyle ? theme.colorScheme.primary : Colors.grey,
                            ),
                          ),
                          onPressed: () => userPreferences.setThemeStyle = ThemeStyle.values[index],
                          child: Column(
                            children: [
                              Container(height: 35, color: theme.appBarTheme.backgroundColor),
                              const Divider(color: Colors.transparent),
                              foodTileColorSchemePreview(context, theme.colorScheme.primary),
                              foodTileColorSchemePreview(context, theme.colorScheme.secondary),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget foodTileColorSchemePreview(BuildContext context, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        height: 20,
        width: 100,
        margin: const EdgeInsets.fromLTRB(5, 30, 5, 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.5),
        ),
      ),
    );
  }
}
