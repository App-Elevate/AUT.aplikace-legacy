import './../every_import.dart';

// snackbar je ze začátku skrytý
SnackBarShown snackbarshown = SnackBarShown(shown: false);

// aktuální stránka jídelníčku - dnešní den
final JidelnicekPageNum jidelnicekPageNum = JidelnicekPageNum(
  pageNumber: DateTime.now().difference(DateTime(2006, 5, 23)).inDays,
);

// getter pro stránku jídelníčku
JidelnicekPageNum getJidelnicekPageNum() {
  return jidelnicekPageNum;
}
