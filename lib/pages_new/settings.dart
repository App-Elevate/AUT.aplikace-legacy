import 'package:autojidelna/shared_widgets/settings/all_settings_widgets.dart';
import 'package:flutter/material.dart';

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
    return const SingleChildScrollView(
      child: Column(
        children: [
          ThemeModePicker(),
          ThemeStylePicker(),
        ],
      ),
    );
  }
}
