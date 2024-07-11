import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: const ScrollViewColumn(),
    );
  }
}
