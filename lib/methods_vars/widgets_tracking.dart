import './../every_import.dart';

bool reloading = false;
bool ordering = false;

// snackbar je ze začátku skrytý
SnackBarShown snackbarshown = SnackBarShown(shown: false);

late void Function(Widget widget) setHomeWidgetPublic;

final DateTime minimalDate = DateTime(2006, 5, 23);

///date listener for the ValueListenableBuilder which tells which date is currently selected to the button and updates it
final ValueNotifier<DateTime> dateListener = ValueNotifier<DateTime>(DateTime.now());

///page controller for the PageView which tells which date is currently selected
final PageController pageviewController = PageController(initialPage: DateTime.now().difference(minimalDate).inDays);

bool loginScreenVisible = false;

///changes the date of the Jidelnicek
///newDate - just sets the new date
///newDate and animateToPage - animates to the new page
///daysChange - animates the change of date by the number of days
///index - changes the date by the index of the page
void changeDate({DateTime? newDate, int? daysChange, int? index, bool? animateToPage}) {
  if (newDate != null && animateToPage != null && animateToPage) {
    loggedInCanteen.smartPreIndexing(newDate);
    dateListener.value = newDate;
    pageviewController.animateToPage(
      newDate.difference(minimalDate).inDays,
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  } else if (daysChange != null) {
    newDate = dateListener.value.add(Duration(days: daysChange));
    loggedInCanteen.smartPreIndexing(newDate);
    pageviewController.animateToPage(
      newDate.difference(minimalDate).inDays,
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  } else if (index != null) {
    newDate = minimalDate.add(Duration(days: index));
    loggedInCanteen.smartPreIndexing(newDate);
    dateListener.value = newDate;
  } else if (newDate != null) {
    loggedInCanteen.smartPreIndexing(newDate);
    dateListener.value = newDate;
    pageviewController.jumpToPage(newDate.difference(minimalDate).inDays);
  }
}
