import 'package:autojidelna/local_imports.dart';

DateTime convertIndexToDatetime(int index) {
  DateTime newDate = minimalDate.add(Duration(days: index));
  while (newDate.hour != 0 && newDate.hour > 12) {
    newDate = newDate.add(const Duration(hours: 1));
  }
  while (newDate.hour != 0 && newDate.hour < 12) {
    newDate = newDate.subtract(const Duration(hours: 1));
  }
  return newDate;
}
