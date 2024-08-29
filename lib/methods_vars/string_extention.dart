import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() => toBeginningOfSentenceCase(this);
}
