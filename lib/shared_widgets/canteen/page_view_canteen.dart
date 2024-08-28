import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/shared_widgets/canteen/menu_of_the_day.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class PageViewCanteen extends StatelessWidget {
  const PageViewCanteen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: portableSoftRefresh,
      child: PageView.builder(
        controller: pageviewController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) => changeDate(index: value),
        itemBuilder: (context, index) => MenuOfTheDay(index),
      ),
    );
  }
}

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
