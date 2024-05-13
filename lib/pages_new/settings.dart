import 'package:autojidelna/pages_new/appearance.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text("Appearance"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppearanceScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
