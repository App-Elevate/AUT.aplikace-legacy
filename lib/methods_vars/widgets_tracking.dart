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
final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

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
      _animate(newDate.difference(minimalDate).inDays, short: true);
    } catch (e) {
      animating = false;
      rethrow;
    }
  } else if (daysChange != null) {
    newDate = dateListener.value.add(Duration(days: daysChange));
    if (newDate.isWeekend && skipWeekends) {
      return changeDate(daysChange: daysChange > 0 ? daysChange + 1 : daysChange - 1, overflow: overflow + 1);
    }
    loggedInCanteen.smartPreIndexing(newDate);
    _animate(newDate.difference(minimalDate).inDays, short: true);
  } else if (index != null) {
    newDate = convertIndexToDatetime(index);
    bool hasToBeAnimated = false;
    if (newDate.isWeekend && skipWeekends && !animating) {
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
    if (hasToBeAnimated) {
      try {
        _animate(index);
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

void _animate(int index, {bool short = false}) {
  animating = true;
  Duration duration = Duration(milliseconds: short ? 150 : 300);
  Curve curve = Curves.easeIn;

  pageviewController.hasClients
      ? pageviewController.animateToPage(index, duration: duration, curve: curve).then((_) => animating = false)
      : itemScrollController.scrollTo(index: index, duration: duration, curve: curve).then((_) => animating = false);
}
