// Includes all popups used in the app.

// flutter
import 'package:autojidelna/pages_new/login.dart';
import 'package:flutter/material.dart';

import 'package:autojidelna/local_imports.dart';
import 'package:localization/localization.dart';

Widget logoutDialog(BuildContext context) {
  return AlertDialog(
    title: Text(Texts.logoutUSure.i18n()),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    alignment: Alignment.bottomCenter,
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: Text(Texts.logoutConfirm.i18n()),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        style: Theme.of(context).textButtonTheme.style!.copyWith(foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)),
        child: Text(Texts.logoutCancel.i18n()),
      ),
    ],
  );
}

void failedLunchDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(Texts.errorsLoad.i18n()),
        content: Text(message),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.bottomCenter,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoggingInWidget()), (route) => false);
            },
            child: Text(Texts.failedDialogTryAgain.i18n()),
          ),
          TextButton(
            onPressed: () {
              loggedInCanteen.logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => (LoginScreenV2())), (route) => false);
            },
            child: Text(Texts.failedDialogLogOut.i18n()),
          ),
        ],
      );
    },
  );
}

void failedLoginDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        onPopInvoked: (hey) => false,
        child: AlertDialog(
          title: Text(Texts.failedDialogLoginFailed.i18n()),
          content: Text(Texts.failedDialogLoginDetail.i18n([message])),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          alignment: Alignment.bottomCenter,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoggingInWidget()), (route) => false);
              },
              child: Text(Texts.failedDialogTryAgain.i18n()),
            ),
            TextButton(
              onPressed: () {
                loggedInCanteen.logout();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => (LoginScreenV2())), (route) => false);
              },
              child: Text(Texts.failedDialogLogOut.i18n()),
            ),
          ],
        ),
      );
    },
  );
}
