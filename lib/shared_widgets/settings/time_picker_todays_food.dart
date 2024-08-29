import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimePickerTodaysFoodTiles extends StatelessWidget {
  const TimePickerTodaysFoodTiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var todaysFood = context.select<NotificationPreferences, ({TimeOfDay read, Function(TimeOfDay) setSend})>(
      (value) => (read: value.sendTodaysFood, setSend: value.setSendTodaysFood),
    );

    void pickTimeToSend() async {
      TimeOfDay savedTimeOfDay = todaysFood.read;
      todaysFood.setSend(await showTimePicker(context: context, initialTime: savedTimeOfDay) ?? savedTimeOfDay);
    }

    return Selector<NotificationPreferences, ({bool read, Function(bool) set, TimeOfDay readSend})>(
      selector: (_, p1) => (read: p1.todaysFood, set: p1.setTodaysFood, readSend: p1.sendTodaysFood),
      builder: (context, todaysFood, child) => Column(
        children: [
          SwitchListTile(
            title: Text(lang.settingsTitleTodaysFood),
            value: todaysFood.read,
            onChanged: todaysFood.set,
          ),
          ListTile(
            title: Text(lang.settingsNotificationTime),
            enabled: todaysFood.read,
            onTap: pickTimeToSend,
            trailing: OutlinedButton(
              onPressed: todaysFood.read ? pickTimeToSend : null,
              child: Text(todaysFood.readSend.format(context)),
            ),
          ),
        ],
      ),
    );
  }
}
