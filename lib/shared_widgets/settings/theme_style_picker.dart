import 'package:autojidelna/app_themes.dart';
import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeStylePicker extends StatelessWidget {
  const ThemeStylePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: Selector<AppearancePreferences, ({ThemeStyle style, Function(ThemeStyle) setStyle, ThemeMode mode, bool pureBlack})>(
        selector: (_, p1) => (style: p1.themeStyle, setStyle: p1.setThemeStyle, mode: p1.themeMode, pureBlack: p1.isPureBlack),
        builder: (context, userPreferences, _) => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Spacing.s16),
          itemCount: ThemeStyle.values.length,
          itemBuilder: (context, index) {
            final bool isBright = MediaQuery.platformBrightnessOf(context) == Brightness.light || userPreferences.mode == ThemeMode.light;
            final ThemeData theme = Themes.getTheme(ThemeStyle.values[index], isPureBlack: isBright ? null : userPreferences.pureBlack);

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
                      color: ThemeStyle.values[index] == userPreferences.style ? theme.colorScheme.primary : Colors.grey,
                    ),
                  ),
                  onPressed: () => userPreferences.setStyle(ThemeStyle.values[index]),
                  child: Column(
                    children: [
                      SizedBox(height: 35, child: AppBar(automaticallyImplyLeading: false)),
                      const Divider(color: Colors.transparent),
                      foodTileColorSchemePreview(context, theme.colorScheme.primary),
                      foodTileColorSchemePreview(context, theme.colorScheme.secondary),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
