import 'package:autojidelna/lang/l10n_global.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lang.account)),
      body: const Placeholder(),
    );
  }
}
