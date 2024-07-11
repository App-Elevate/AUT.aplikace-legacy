import 'package:autojidelna/shared_widgets/lined_card.dart';
import 'package:flutter/material.dart';

class LocationPickerCard extends StatelessWidget {
  const LocationPickerCard({super.key});
  final bool hasMoreLocations = false;

  @override
  Widget build(BuildContext context) {
    return LinedCard(
      title: "Location",
      footer: hasMoreLocations ? "Change location" : null, // TODO: hide text if there is only 1 location available
      child: const ListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity(vertical: -4),
        title: Text("unknown"), // TODO: replace with current location
      ),
    );
  }
}
