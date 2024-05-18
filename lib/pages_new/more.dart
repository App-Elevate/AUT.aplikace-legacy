import 'package:autojidelna/pages_new/settings.dart';
import 'package:flutter/material.dart';

class MoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MoreAppBar({super.key});

  @override
  Widget build(BuildContext context) => AppBar(automaticallyImplyLeading: false, forceMaterialTransparency: true);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen())),
          )
        ],
      ),
    );
  }
}
