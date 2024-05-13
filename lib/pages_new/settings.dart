import 'package:autojidelna/pages_new/appearance.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("Appearance"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AppearanceScreen()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
