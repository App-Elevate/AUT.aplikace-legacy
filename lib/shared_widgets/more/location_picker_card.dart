import 'package:autojidelna/consts.dart';
import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/shared_widgets/configured_alert_dialog.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';
import 'package:autojidelna/shared_widgets/lined_card.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LocationPickerCard extends StatefulWidget {
  const LocationPickerCard({super.key});

  @override
  State<LocationPickerCard> createState() => _LocationPickerCardState();
}

class _LocationPickerCardState extends State<LocationPickerCard> {
  final bool hasMoreLocations = true;
  int selectedLocation = 1;
  void updatePicked(int i) => setState(() {
        selectedLocation = i;
      });

  @override
  Widget build(BuildContext context) {
    final Map<int, String> locations = loggedInCanteen.canteenDataUnsafe?.vydejny ?? {};
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        LinedCard(
          smallButton: false,
          title: lang.location,
          footer: locations.length > 1 ? lang.pickLocation : null,
          footerTextAlign: TextAlign.end,
          onPressed: locations.length < 2 ? null : () => pickerDialog(context, locations),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(vertical: -4),
            title: Text(locations[selectedLocation + 1] ?? locations[1] ?? ''),
          ),
        ),
        if (locations.isEmpty) lockedCover(context),
      ],
    );
  }

  void pickerDialog(BuildContext context, Map<int, String> locations) {
    configuredDialog(
      context,
      builder: (context) => ConfiguredAlertDialog(
        title: lang.pickLocation,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            locations.length,
            (i) => ListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                locations[i + 1]!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: selectedLocation == i ? const Icon(Icons.check) : null,
              onTap: () async {
                updatePicked(i);
                loggedInCanteen.zmenitVydejnu(i + 1);
                Navigator.of(context).popUntil((route) => route.isFirst);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt('${Prefs.location}${loggedInCanteen.uzivatel?.uzivatelskeJmeno ?? ''}_${loggedInCanteen.canteenDataUnsafe!.url}', i);
              },
            ),
          ),
        ),
      ),
    );
  }

  Positioned lockedCover(BuildContext context) {
    return Positioned.fill(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onInverseSurface.withOpacity(.9),
          border: Border.all(color: Theme.of(context).dividerTheme.color!),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.lock_outline_rounded),
      ),
    );
  }
}
