import './../every_import.dart';

// snackbar je ze začátku skrytý
SnackBarShown snackbarshown = SnackBarShown(shown: false);

// aktuální stránka jídelníčku - dnešní den
final JidelnicekPageNum jidelnicekPageNum = JidelnicekPageNum(
  pageNumber: DateTime.now().difference(DateTime(2006, 5, 23)).inDays,
);
final DateTime minimalDate = DateTime(2006, 5, 23);

// getter pro stránku jídelníčku
JidelnicekPageNum getJidelnicekPageNum() {
  return jidelnicekPageNum;
}

///date listener for the ValueListenableBuilder which tells which date is currently selected to the button and updates it
final ValueNotifier<DateTime> dateListener = ValueNotifier<DateTime>(DateTime(2006, 5, 23).add(Duration(days: getJidelnicekPageNum().pageNumber)));

///page controller for the PageView which tells which date is currently selected
final PageController pageviewController = PageController(initialPage: getJidelnicekPageNum().pageNumber);

bool loginScreenVisible = false;
