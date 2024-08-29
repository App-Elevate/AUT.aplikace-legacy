import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/main.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/widgets_tracking.dart';
import 'package:autojidelna/shared_widgets/snackbar.dart';
import 'package:flutter/material.dart';

Future<void> portableSoftRefresh() async {
  try {
    await loggedInCanteen.getLunchesForDay(dateListener.value, requireNew: true);
  } catch (e) {
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    BuildContext? ctx = MyApp.navigatorKey.currentContext;
    if (ctx != null && ctx.mounted && !snackbarshown.shown) {
      ScaffoldMessenger.of(ctx).showSnackBar(snackbarFunction(lang.errorsUpdatingData)).closed.then(
        (SnackBarClosedReason reason) {
          snackbarshown.shown = false;
        },
      );
    }
  }
}
