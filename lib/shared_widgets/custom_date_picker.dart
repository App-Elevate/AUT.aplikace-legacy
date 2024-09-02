// This is the custom date picker used in the main app screen (jidelna.dart)

import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/methods_vars/string_extention.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';

showCustomDatePicker(BuildContext context, DateTime currentDate) {
  ValueNotifier<DateTime> focusedDateNotifier = ValueNotifier<DateTime>(currentDate);
  List<DateTime> orderedFoodDays = [];
  bool bigMarkersEnabled = context.read<Settings>().bigCalendarMarkers;
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  String locale = Localizations.localeOf(context).toLanguageTag();
  configuredDialog(
    context,
    builder: (context) {
      return Dialog(
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: focusedDateNotifier,
              builder: (context, value, ___) {
                return TableCalendar(
                  locale: locale,
                  sixWeekMonthsEnforced: true,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: Theme.of(context).textTheme.headlineSmall!,
                    decoration: BoxDecoration(
                      color: colorScheme.brightness == Brightness.dark ? colorScheme.onSurface.withOpacity(0.1) : colorScheme.secondary,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    markersMaxCount: 3,
                    todayTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                    todayDecoration: BoxDecoration(border: Border.all(color: colorScheme.primary), shape: BoxShape.circle),
                    markerSizeScale: bigMarkersEnabled ? 0 : 0.3,
                    markerDecoration: BoxDecoration(color: colorScheme.secondary, shape: BoxShape.circle),
                    selectedTextStyle: Theme.of(context).textTheme.titleMedium!,
                    selectedDecoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                    defaultTextStyle: Theme.of(context).textTheme.titleMedium!,
                    defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
                  ),
                  rowHeight: 45,
                  daysOfWeekHeight: 25,
                  focusedDay: currentDate,
                  currentDay: DateTime.now(),
                  firstDay: minimalDate,
                  lastDay: maximalDate,
                  selectedDayPredicate: (day) => isSameDay(currentDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    focusedDateNotifier.value = selectedDay;
                    currentDate = focusedDay;
                  },
                  eventLoader: (day) {
                    orderedFoodDays = [];
                    DateTime date = DateTime(day.year, day.month, day.day);

                    if (loggedInCanteen.canteenDataUnsafe!.jidelnicky[date] != null) {
                      for (int i = 0; i < loggedInCanteen.canteenDataUnsafe!.jidelnicky[date]!.jidla.length; i++) {
                        if (loggedInCanteen.canteenDataUnsafe!.jidelnicky[date]!.jidla[i].objednano) orderedFoodDays.add(date);
                      }
                    }

                    return orderedFoodDays;
                  },
                  calendarBuilders: CalendarBuilders(
                    headerTitleBuilder: (context, day) => _headerTitle(locale, day, context),
                    selectedBuilder: (context, date, currentDate) => _cellTemplate(context, date),
                    todayBuilder: (context, date, currentDate) => _cellTemplate(context, date, today: true),
                    defaultBuilder: bigMarkersEnabled
                        ? (context, date, currentDate) {
                            DateTime day = DateTime(date.year, date.month, date.day);
                            if (orderedFoodDays.contains(day)) return _cellTemplate(context, date, base: true);
                            return null;
                          }
                        : null,
                  ),
                );
              },
            ),
            const Divider(height: 0),
            _actionButtons(context, focusedDateNotifier),
          ],
        ),
      );
    },
  );
}

Center _headerTitle(String locale, DateTime day, BuildContext context) {
  return Center(
    child: Text(
      DateFormat(DateFormat.YEAR_MONTH, locale).format(day).capitalize(),
      style: Theme.of(context).textTheme.headlineSmall!,
    ),
  );
}

Center _cellTemplate(BuildContext context, DateTime date, {bool today = false, bool base = false}) {
  final theme = Theme.of(context);
  double size = base ? 35 : 40;

  Color? color = today
      ? null
      : base
          ? theme.colorScheme.secondary
          : theme.colorScheme.primary;

  return Center(
    child: Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        border: today ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium!.copyWith(color: today ? Theme.of(context).colorScheme.primary : null),
        ),
      ),
    ),
  );
}

Row _actionButtons(BuildContext context, ValueNotifier<DateTime> focusedDateNotifier) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () => Navigator.maybeOf(context)?.popUntil((route) => route.isFirst),
        child: Text(lang.cancel),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          changeDate(newDate: focusedDateNotifier.value);
        },
        child: Text(lang.ok),
      ),
      const SizedBox(width: 10),
    ],
  );
}
