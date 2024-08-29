import 'package:autojidelna/main.dart';
import 'package:autojidelna/methods_vars/widgets_tracking.dart';
import 'package:autojidelna/shared_widgets/snackbar.dart';
import 'package:flutter/material.dart';

void snackBarMessage(String message) {
  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  // toto je upozornění dole (Snackbar)
  // snackbarshown je aby se snackbar nezobrazil vícekrát
  BuildContext? ctx = MyApp.navigatorKey.currentContext;
  if (ctx != null && snackbarshown.shown == false) {
    snackbarshown.shown = true;
    ScaffoldMessenger.of(ctx).showSnackBar(snackbarFunction(message)).closed.then(
      (SnackBarClosedReason reason) {
        snackbarshown.shown = false;
      },
    );
  }
}
