import 'package:autojidelna/classes_enums/all.dart';

/// Returns correctly formated date string
///
/// [format]      | what format it should use
///
/// [date]        | date to be formated
///
/// [inSettings]  | If true, adds a "title" to the date -> ex. "Default (1.1.2024)"
String getCorrectDateString(DateFormat format, {DateTime? date, bool inSettings = false}) {
  String string;
  String dateStr;
  DateTime currentDate = DateTime.now();
  date = DateTime(currentDate.year, currentDate.month, currentDate.day);
  switch (format) {
    case DateFormat.ddmmmyyyy:
      dateStr = "${currentDate.day} ${getMonthString(currentDate.month)} ${currentDate.year}";
      string = "dd MMM yyyy ($dateStr)";
      break;
    case DateFormat.ddmmyy:
      dateStr = "${currentDate.day}/${currentDate.month}/${currentDate.year % 100}";
      string = "dd/MM/yy ($dateStr)";
      break;
    case DateFormat.mmddyy:
      dateStr = "${currentDate.month}/${currentDate.day}/${currentDate.year % 100}";
      string = "MM/dd/yy ($dateStr)";
      break;
    case DateFormat.mmmddyyyy:
      dateStr = "${getMonthString(currentDate.month)} ${currentDate.day}, ${currentDate.year}";
      string = "MMM dd, yyyy($dateStr)";
      break;
    case DateFormat.yyyymmdd:
      dateStr = "${currentDate.year}-${currentDate.month}-${currentDate.day}";
      string = "yyyy-mm-dd ($dateStr)";
      break;
    default:
      dateStr = "${currentDate.day}. ${currentDate.month}. ${currentDate.year}";
      string = "Default ($dateStr)";
  }
  return inSettings ? string : dateStr;
}

/// Converts moth number to month name
String getMonthString(int month) {
  const monthStrings = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  if (month < 1 || month > 12) {
    throw ArgumentError("Invalid month: $month");
  }

  return monthStrings[month - 1];
}
