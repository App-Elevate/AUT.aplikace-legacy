import './../every_import.dart';

bool reloading = false;
bool ordering = false;

// snackbar je ze začátku skrytý
SnackBarShown snackbarshown = SnackBarShown(shown: false);

late void Function(Widget widget) setHomeWidgetPublic;

final DateTime minimalDate = DateTime(2006, 5, 23);

///date listener for the ValueListenableBuilder which tells which date is currently selected to the button and updates it
late final ValueNotifier<DateTime> dateListener;

///page controller for the PageView which tells which date is currently selected
late final PageController pageviewController;

bool loginScreenVisible = false;

bool skipWeekends = false;

int? lastChangeDateIndex;

bool animating = false;

void setCurrentDate() async {
  DateTime initialDate = DateTime.now();
  if (!skipWeekends) {
    bool success = false;
    while (!success) {
      try {
        changeDate(newDate: initialDate);
        success = true;
      } catch (e) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    return;
  }
  while (initialDate.weekday == 6 || initialDate.weekday == 7) {
    initialDate = initialDate.add(const Duration(days: 1));
  }
  int index = initialDate.difference(minimalDate).inDays;
  while (initialDate.add(Duration(days: index)).weekday == 6 || initialDate.add(Duration(days: index)).weekday == 7) {
    index++;
  }
  bool success = false;
  while (!success) {
    try {
      pageviewController.jumpToPage(index);
      success = true;
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
  changeDate(index: index);
}

///changes the date of the Jidelnicek
///newDate - just sets the new date
///newDate and animateToPage - animates to the new page
///daysChange - animates the change of date by the number of days
///index - changes the date by the index of the page
void changeDate({DateTime? newDate, int? daysChange, int? index, bool? animateToPage, int overflow = 0}) {
  if (overflow > 5) {
    return;
  }
  if (newDate != null && animateToPage != null && animateToPage) {
    loggedInCanteen.smartPreIndexing(newDate);
    dateListener.value = newDate;
    lastChangeDateIndex = newDate.difference(minimalDate).inDays;
    animating = true;
    pageviewController
        .animateToPage(
          newDate.difference(minimalDate).inDays,
          duration: const Duration(milliseconds: 150),
          curve: Curves.linear,
        )
        .then((value) => animating = false);
  } else if (daysChange != null) {
    newDate = dateListener.value.add(Duration(days: daysChange));
    if (newDate.weekday == 6 || newDate.weekday == 7 && skipWeekends) {
      return changeDate(daysChange: daysChange > 0 ? daysChange + 1 : daysChange - 1, overflow: overflow + 1);
    }
    loggedInCanteen.smartPreIndexing(newDate);

    pageviewController.animateToPage(
      newDate.difference(minimalDate).inDays,
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  } else if (index != null) {
    lastChangeDateIndex ??= index;
    newDate = minimalDate.add(Duration(days: index));
    bool hasToBeAnimated = false;
    if ((newDate.weekday == 6 || newDate.weekday == 7) && skipWeekends && !animating) {
      hasToBeAnimated = true;
      bool forwardOrBackward = index > lastChangeDateIndex!;
      switch (forwardOrBackward) {
        case true:
          index += newDate.weekday == 6 ? 2 : 1;
          break;
        case false:
          index -= newDate.weekday == 7 ? 2 : 1;
          break;
      }
    }
    newDate = minimalDate.add(Duration(days: index));
    if ((newDate.weekday == 6 || newDate.weekday == 7) && skipWeekends && !animating) {
      return changeDate(index: index, overflow: overflow + 1);
    }
    if (hasToBeAnimated) {
      animating = true;
      pageviewController
          .animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          )
          .then((value) => animating = false);
    }
    lastChangeDateIndex = index;
    loggedInCanteen.smartPreIndexing(newDate);
    dateListener.value = newDate;
  } else if (newDate != null) {
    loggedInCanteen.smartPreIndexing(newDate);
    dateListener.value = newDate;
    pageviewController.jumpToPage(newDate.difference(minimalDate).inDays);
  }
}
