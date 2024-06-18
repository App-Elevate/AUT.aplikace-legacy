import 'package:autojidelna/classes_enums/all.dart';

String getCorrectDateString(DateFormat format, {DateTime? date}) {
  String string;
  DateTime currentDate = DateTime.now();
  date = DateTime(currentDate.year, currentDate.month, currentDate.day);
  switch (format) {
    case DateFormat.ddmmmyyyy:
      string = "dd MMM yyyy (${currentDate.day} ${getMonthString(currentDate.month)} ${currentDate.year})";
      break;
    case DateFormat.ddmmyy:
      string = "dd/MM/yy (${currentDate.day}/${currentDate.month}/${currentDate.year % 100})";
      break;
    case DateFormat.mmddyy:
      string = "MM/dd/yy (${currentDate.month}/${currentDate.day}/${currentDate.year % 100})";
      break;
    case DateFormat.mmmddyyyy:
      string = "MMM dd, yyyy(${getMonthString(currentDate.month)} ${currentDate.day}, ${currentDate.year})";
      break;
    case DateFormat.yyyymmdd:
      string = "yyyy-mm-dd (${currentDate.year}-${currentDate.month}-${currentDate.day})";
      break;
    default:
      string = "Default (${currentDate.day}. ${currentDate.month}. ${currentDate.year})";
  }
  return string;
}

String getMonthString(int month) {
  const monthStrings = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  if (month < 1 || month > 12) {
    throw ArgumentError("Invalid month: $month");
  }

  return monthStrings[month - 1];
}
