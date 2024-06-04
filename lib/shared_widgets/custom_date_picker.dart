// This is the custom date picker used in the main app screen (jidelna.dart)

import 'package:autojidelna/local_imports.dart';

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'package:table_calendar/table_calendar.dart';

class CustomDatePicker {
  Future<DateTime?> showDatePicker(BuildContext context, DateTime currentDate) async {
    ValueNotifier focusedDateNotifier = ValueNotifier<DateTime>(currentDate);
    List<DateTime> orderedFoodDays = [];
    bool bigMarkersEnabled = false;

    Future<void> setConfig() async {
      bigMarkersEnabled = await loggedInCanteen.isPrefTrue(Prefs.calendarBigMarkers);
    }

    return showDialog<DateTime?>(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: setConfig(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Dialog(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: focusedDateNotifier,
                        builder: (context, value, child) {
                          return TableCalendar(
                            //get current locale
                            locale: '${Localizations.localeOf(context).languageCode}_${Localizations.localeOf(context).countryCode}',
                            sixWeekMonthsEnforced: true,
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                                color: Theme.of(context).colorScheme.brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
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
                              markerSizeScale: bigMarkersEnabled ? 0 : 0.3,
                              markerDecoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
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
                              focusedDateNotifier.value = selectedDay;
                              currentDate = focusedDay;
                            },
                            eventLoader: (day) {
                              orderedFoodDays = [];
                              DateTime date = DateTime(day.year, day.month, day.day);

                              if (loggedInCanteen.canteenDataUnsafe!.jidelnicky[date] != null) {
                                for (int i = 0; i < loggedInCanteen.canteenDataUnsafe!.jidelnicky[date]!.jidla.length; i++) {
                                  if (loggedInCanteen.canteenDataUnsafe!.jidelnicky[date]!.jidla[i].objednano) {
                                    orderedFoodDays.add(date);
                                  }
                                }
                              }

                              return orderedFoodDays;
                            },
                            calendarBuilders: CalendarBuilders(
                              selectedBuilder: (context, date, currentDate) {
                                return Center(
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        date.day.toString(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleMedium!,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              todayBuilder: (context, date, currentDate) {
                                return Center(
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 1.5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        date.day.toString(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              defaultBuilder: bigMarkersEnabled
                                  ? (context, date, currentDate) {
                                      date = DateTime(date.year, date.month, date.day);
                                      if (orderedFoodDays.contains(date)) {
                                        return Center(
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.secondary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                date.day.toString(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme.titleMedium!,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return null;
                                    }
                                  : null,
                            ),
                          );
                        },
                      ),
                      const Divider(height: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.maybeOf(context)?.popUntil((route) => route.isFirst);
                            },
                            child: Text(Texts.datePickerCancel.i18n()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(focusedDateNotifier.value);
                              },
                              child: Text(Texts.datePickerOk.i18n()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
