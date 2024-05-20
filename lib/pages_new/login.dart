import 'package:autojidelna/pages_new/navigation.dart';
import 'package:flutter/material.dart';

class LoginScreenV2 extends StatelessWidget {
  const LoginScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true),
      body: Center(
        child: ElevatedButton(
          child: const Text("Log In"),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const NavigationScreen()),
            (route) => false,
          ),
        ),
      ),
    );
  }
}
