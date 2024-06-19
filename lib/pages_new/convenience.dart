import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConvenienceScreen extends StatelessWidget {
  const ConvenienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conveniece")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SectionTitle("Convenience"),
            // TODO: implement this
            // skip weekends switch
            Selector<AppearancePreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.skipWeekends, set: p1.setSkipWeekends),
              builder: (context, skipWeekends, child) => SwitchListTile(
                title: const Text("Skip weekends"),
                value: skipWeekends.read,
                onChanged: skipWeekends.set,
              ),
            ),
            // TODO: implement this
            // big calendar markers switch
            Selector<AppearancePreferences, ({bool read, Function(bool) set})>(
              selector: (_, p1) => (read: p1.bigCalendarMarkers, set: p1.setCalendarMarkers),
              builder: (context, bigCalendarMarkers, child) => SwitchListTile(
                title: const Text("Big calendar markers"),
                value: bigCalendarMarkers.read,
                onChanged: bigCalendarMarkers.set,
              ),
            ),
            const CustomDivider(),
          ],
        ),
      ),
    );
  }
}
