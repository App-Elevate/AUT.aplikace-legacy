import 'package:autojidelna/consts.dart';
import 'package:autojidelna/main.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/widgets_tracking.dart';
import 'package:autojidelna/shared_widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

Future<void> portableSoftRefresh() async {
  try {
    await loggedInCanteen.getLunchesForDay(dateListener.value, requireNew: true);
  } catch (e) {
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    BuildContext? ctx = MyApp.navigatorKey.currentContext;
    if (ctx != null && ctx.mounted && !snackbarshown.shown) {
      ScaffoldMessenger.of(ctx).showSnackBar(snackbarFunction(Texts.errorsUpdatingData.i18n())).closed.then(
        (SnackBarClosedReason reason) {
          snackbarshown.shown = false;
        },
      );
    }
  }
}
