// Includes all popups used in the app.

// flutter
import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/pages_new/login.dart';
import 'package:flutter/material.dart';

import 'package:autojidelna/local_imports.dart';

Widget logoutDialog(BuildContext context, {bool currentAccount = true, int? id}) {
  return AlertDialog(
    title: Text(lang.logoutUSure),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    alignment: Alignment.bottomCenter,
    actions: <Widget>[
      TextButton(
        onPressed: () async {
          await loggedInCanteen.logout(id: id);
          // if the account is current it has to reload the main app screen
          if (currentAccount && context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoggingInWidget()), (route) => false);
          } else if (context.mounted) {
            Navigator.of(context).pop(true);
          }
        },
        child: Text(lang.logoutConfirm),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        style: Theme.of(context).textButtonTheme.style!.copyWith(foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)),
        child: Text(lang.cancel),
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
        title: Text(lang.errorsLoad),
        content: Text(message),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.bottomCenter,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoggingInWidget()), (route) => false);
            },
            child: Text(lang.tryAgain),
          ),
          TextButton(
            onPressed: () {
              loggedInCanteen.logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => (LoginScreen())), (route) => false);
            },
            child: Text(lang.logoutConfirm),
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
          title: Text(lang.errorsLoginFailed),
          content: Text(lang.errorsLoginFailedDetail(message)),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          alignment: Alignment.bottomCenter,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoggingInWidget()), (route) => false);
              },
              child: Text(lang.tryAgain),
            ),
            TextButton(
              onPressed: () {
                loggedInCanteen.logout();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => (LoginScreen())), (route) => false);
              },
              child: Text(lang.logoutConfirm),
            ),
          ],
        ),
      );
    },
  );
}
