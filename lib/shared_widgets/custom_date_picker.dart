import 'package:autojidelna/every_import.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePicker {
  Future<DateTime?> showDatePicker(BuildContext context, DateTime currentDate) {
    ValueNotifier focusedDate = ValueNotifier<DateTime>(currentDate);

    return showDialog<DateTime?>(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: ListView(
              shrinkWrap: true,
              children: [
                ValueListenableBuilder(
                  valueListenable: focusedDate,
                  builder: (context, value, child) {
                    return TableCalendar(
                      sixWeekMonthsEnforced: false,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                          color: Theme.of(context).colorScheme.brightness == Brightness.dark
                              ? Theme.of(context).colorScheme.onBackground.withOpacity(0.1)
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        markersMaxCount: 3,
                        todayTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                        todayDecoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.primary),
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: Theme.of(context).textTheme.titleMedium!,
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: Theme.of(context).textTheme.titleMedium!,
                        defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
                      ),
                      rowHeight: 45,
                      focusedDay: currentDate,
                      currentDay: DateTime.now(),
                      firstDay: minimalDate,
                      lastDay: currentDate.add(const Duration(days: 365 * 2)),
                      selectedDayPredicate: (day) {
                        return isSameDay(currentDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        focusedDate.value = selectedDay;
                        currentDate = focusedDay;
                      },
                    );
                  },
                ),
                const Divider(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.maybeOf(context)!.popUntil((route) => route.isFirst);
                      },
                      child: const Text('Zrušit'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(focusedDate.value);
                        },
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
