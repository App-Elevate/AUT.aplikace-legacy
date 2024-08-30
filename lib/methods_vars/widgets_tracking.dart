// variables and methods for tracking the widgets and their states

import 'package:autojidelna/local_imports.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

bool reloading = false;

// snackbar je ze začátku skrytý
SnackBarShown snackbarshown = SnackBarShown(shown: false);

bool analyticsEnabledGlobally = false;

FirebaseAnalytics? analytics;

late void Function(Widget widget) setHomeWidgetPublic;

final DateTime minimalDate = DateTime(2006, 5, 23);

///date listener for the ValueListenableBuilder which tells which date is currently selected to the button and updates it
late final ValueNotifier<DateTime> dateListener;

///page controller for the PageView which tells which date is currently selected
late final PageController pageviewController;

///page controller for the PageView which tells which date is currently selected
final ItemScrollController itemScrollController = ItemScrollController();

bool loginScreenVisible = false;

bool skipWeekends = false;

int lastChangeDateIndex = 0;

bool animating = false;

//index (jaký den)
int? indexJidlaCoMaBytZobrazeno;
//index (kolikáté jídlo ve dni)
int? indexJidlaKtereMaBytZobrazeno;

void setCurrentDate() async {
  DateTime newDate = DateTime.now();
  if (skipWeekends) {
    while (newDate.weekday == 6 || newDate.weekday == 7) {
      newDate = newDate.add(const Duration(days: 1));
    }
  }

  for (int i = 0; i < 20; i++) {
    try {
      changeDate(newDate: newDate, animateToPage: true);
      return;
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 50));
    }
  }
}

void changeDateTillSuccess(int index) async {
  DateTime newDate = convertIndexToDatetime(index);

  for (int i = 0; i < 20; i++) {
    try {
      changeDate(newDate: newDate);
      return;
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 50));
    }
  }
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
    try {
      animating = true;
      pageviewController
          .animateToPage(
            newDate.difference(minimalDate).inDays,
            duration: const Duration(milliseconds: 150),
            curve: Curves.linear,
          )
          .then((value) => animating = false);
    } catch (e) {
      animating = false;
      rethrow;
    }
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
    newDate = convertIndexToDatetime(index);
    bool hasToBeAnimated = false;
    if ((newDate.weekday == 6 || newDate.weekday == 7) && skipWeekends && !animating) {
      hasToBeAnimated = true;
      bool forwardOrBackward = index > lastChangeDateIndex;
      switch (forwardOrBackward) {
        case true:
          index += newDate.weekday == 6 ? 2 : 1;
          break;
        case false:
          index -= newDate.weekday == 7 ? 2 : 1;
          break;
      }
    }
    newDate = convertIndexToDatetime(index);
    if (hasToBeAnimated) {
      try {
        animating = true;
        pageviewController
            .animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            )
            .then((value) => animating = false);
      } catch (e) {
        animating = false;
        rethrow;
      }
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
