import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/pages_new/about.dart';
import 'package:autojidelna/pages_new/settings/appearance.dart';
import 'package:autojidelna/pages_new/settings/convenience.dart';
import 'package:autojidelna/pages_new/settings/data_collection.dart';
import 'package:autojidelna/pages_new/settings/notifications.dart';
import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lang.settings)),
      body: ScrollViewColumn(
        children: [
          const CustomDivider(height: 4),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(lang.settingsAppearence),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearanceScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.tune_outlined),
            title: Text(lang.convenience),
            onTap: () async => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConvenienceScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.edit_notifications_outlined),
            title: Text(lang.notifications),
            onTap: () async => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.cookie_outlined),
            title: Text(lang.settingsDataCollection),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DataCollectionScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(lang.about),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutScreen())),
          ),
        ],
      ),
    );
  }
}
