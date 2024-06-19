import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/pages_new/about.dart';
import 'package:autojidelna/pages_new/appearance.dart';
import 'package:autojidelna/pages_new/convenience.dart';
import 'package:autojidelna/pages_new/data_collection.dart';
import 'package:autojidelna/pages_new/notifications.dart';
import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ScrollViewColumn(
        children: [
          CustomDivider(height: Spacing.s4),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text("Appearance"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearanceScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.tune_outlined),
            title: const Text("Convenience"),
            onTap: () async => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConvenienceScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.edit_notifications_outlined),
            title: const Text("Notifications"),
            onTap: () async => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.cookie_outlined),
            title: const Text("Data Collection"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DataCollectionScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutScreen())),
          ),
        ],
      ),
    );
  }
}
