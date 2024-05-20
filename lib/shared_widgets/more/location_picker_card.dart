import 'package:autojidelna/shared_widgets/lined_card.dart';
import 'package:flutter/material.dart';

class LocationPickerCard extends StatelessWidget {
  const LocationPickerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const LinedCard(
      title: "Location",
      footer: "Change location",
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity(vertical: -4),
        title: Text("unknown"),
      ),
    );
  }
}
