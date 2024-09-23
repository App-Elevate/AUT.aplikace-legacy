import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> portableSoftRefresh() async {
  BuildContext? ctx = MyApp.navigatorKey.currentContext;
  DateTime day = dateListener.value;
  if (ctx != null) {
    try {
      ctx.read<DishesOfTheDay>().setMenu(convertDateTimeToIndex(day), await loggedInCanteen.getLunchesForDay(day, requireNew: true));
    } catch (e) {
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      if (ctx.mounted && !snackbarshown.shown) {
        ScaffoldMessenger.of(ctx).showSnackBar(snackbarFunction(lang.errorsUpdatingData)).closed.then(
          (SnackBarClosedReason reason) {
            snackbarshown.shown = false;
          },
        );
      }
    }
  }
}
