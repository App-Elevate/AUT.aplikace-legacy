// variables and methods for tracking the widgets and their states

import 'package:autojidelna/local_imports.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// snackbar je ze začátku skrytý
SnackBarShown snackbarshown = SnackBarShown(shown: false);

bool analyticsEnabledGlobally = false;

FirebaseAnalytics? analytics;

final DateTime minimalDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
final DateTime maximalDate = DateTime(DateTime.now().year, DateTime.now().month + 2, 0);

/// Date listener for the ValueListenableBuilder which tells which date is currently selected to the button and updates it
late final ValueNotifier<DateTime> dateListener;

/// Page controller for the PageView which tells which date is currently selected
late final PageController pageviewController;

/// Item controller for the ListView which tells which date is currently selected
final ItemScrollController itemScrollController = ItemScrollController();

bool loginScreenVisible = false;

bool skipWeekends = false;

int lastChangeDateIndex = 0;

bool animating = false;

bool hideBurzaAlertDialog = false;

//index (jaký den)
int? indexJidlaCoMaBytZobrazeno;
//index (kolikáté jídlo ve dni)
int? indexJidlaKtereMaBytZobrazeno;

///changes the date of the Jidelnicek
///newDate - just sets the new date
///newDate and animateToPage - animates to the new page
///daysChange - animates the change of date by the number of days
///index - changes the date by the index of the page
void changeDate({DateTime? newDate, int? daysChange, int? index, bool? animateToPage, int overflow = 0}) {
  if (overflow > 5) return;

  if (newDate != null && animateToPage != null && animateToPage) {
    loggedInCanteen.smartPreIndexing(newDate);
    dateListener.value = newDate;
    lastChangeDateIndex = newDate.difference(minimalDate).inDays;
    try {
      animating = true;
      pageviewController.hasClients
          ? pageviewController
              .animateToPage(
                newDate.difference(minimalDate).inDays,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
              )
              .then((value) => animating = false)
          : itemScrollController
              .scrollTo(
                index: newDate.difference(minimalDate).inDays,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
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
    pageviewController.hasClients
        ? pageviewController.animateToPage(
            newDate.difference(minimalDate).inDays,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          )
        : itemScrollController
            .scrollTo(
              index: newDate.difference(minimalDate).inDays,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            )
            .then((value) => animating = false);
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
        pageviewController.hasClients
            ? pageviewController
                .animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                )
                .then((value) => animating = false)
            : itemScrollController
                .scrollTo(
                  index: index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
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

    pageviewController.hasClients
        ? pageviewController.jumpToPage(newDate.difference(minimalDate).inDays)
        : itemScrollController.jumpTo(index: newDate.difference(minimalDate).inDays);
  }
}
