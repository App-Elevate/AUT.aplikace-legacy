import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConvenienceScreen extends StatelessWidget {
  const ConvenienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lang.convenience)),
      body: ScrollViewColumn(
        children: [
          SectionTitle(lang.convenience),
          // list UI switch
          Selector<Settings, ({bool read, Function(bool) set})>(
            selector: (_, p1) => (read: p1.isListUi, set: p1.setListUi),
            builder: (context, listUi, child) => SwitchListTile(
              title: Text(lang.listUi),
              value: listUi.read,
              onChanged: listUi.set,
            ),
          ),
          // skip weekends switch
          Selector<Settings, ({bool read, Function(bool) set})>(
            selector: (_, p1) => (read: p1.getSkipWeekends, set: p1.setSkipWeekends),
            builder: (context, skipWeekends, child) => SwitchListTile(
              title: Text(lang.settingsSkipWeekends),
              value: skipWeekends.read,
              onChanged: skipWeekends.set,
            ),
          ),
          // big calendar markers switch
          Selector<Settings, ({bool read, Function(bool) set})>(
            selector: (_, p1) => (read: p1.bigCalendarMarkers, set: p1.setCalendarMarkers),
            builder: (context, bigCalendarMarkers, child) => SwitchListTile(
              title: Text(lang.settingsCalendarBigMarkers),
              value: bigCalendarMarkers.read,
              onChanged: bigCalendarMarkers.set,
            ),
          ),
        ],
      ),
    );
  }
}
