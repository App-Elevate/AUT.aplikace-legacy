// Includes all popups used in the app.

// Used for determining platform
import 'dart:io';

// flutter
import 'package:flutter/material.dart';

import 'package:autojidelna/local_imports.dart';

import 'package:markdown/markdown.dart' as md;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// getting the current version of the app
import 'package:package_info_plus/package_info_plus.dart';

import 'package:url_launcher/url_launcher.dart';

void newUpdateDialog(BuildContext context, {int? tries}) {
  if (tries != null && tries > 5) {
    return;
  }
  try {
    if (releaseInfo!.currentlyLatestVersion) {
      return;
    }
  } catch (e) {
    getLatestRelease();
    Future.delayed(
      const Duration(seconds: 1),
      () => newUpdateDialog(context, tries: tries == null ? 1 : tries + 1),
    );
    return;
  }
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Nová verze aplikace - ${releaseInfo!.latestVersion}'),
        content: SizedBox(
          height: 200,
          child: Scrollbar(
            trackVisibility: true,
            radius: const Radius.circular(20),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Nová aktualizace přináší:',
                      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 0),
                    child: HtmlWidget(
                      textStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      md.markdownToHtml(releaseInfo!.changelog ?? 'Changelog není k dispozici'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (releaseInfo!.isAndroid || (releaseInfo?.isOnAppstore ?? false))
                  SizedBox(
                    width: 500,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: const Text('Aktualizovat'),
                      onPressed: () {
                        if (Platform.isAndroid && (releaseInfo?.isOnGooglePlay ?? false)) {
                          launchUrl(Uri.parse(releaseInfo!.googlePlayUrl!), mode: LaunchMode.externalApplication);
                          return;
                        } else if (Platform.isIOS && (releaseInfo?.isOnAppstore ?? false)) {
                          launchUrl(Uri.parse(releaseInfo!.appStoreUrl!), mode: LaunchMode.externalApplication);
                          return;
                        }
                        Navigator.of(context).pop();

                        PackageInfo.fromPlatform().then(
                          (value) {
                            if (analyticsEnabledGlobally && analytics != null) {
                              analytics!.logEvent(
                                name: 'updateButtonClicked',
                                parameters: {'oldVersion': value.version, 'newVersion': releaseInfo!.currentlyLatestVersion.toString()},
                              );
                            }
                          },
                        );
                        networkInstallApk(releaseInfo!.downloadUrl!, context);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: 500,
                    child: ElevatedButton(
                      onPressed: (() => launchUrl(
                          Uri.parse("https://github.com/tpkowastaken/autojidelna/releases/tag/v${releaseInfo!.latestVersion}"),
                          mode: LaunchMode.externalApplication)),
                      child: const Text('Zobrazit na githubu'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 500,
                    child: ElevatedButton(
                      child: const Text('Teď ne'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Widget logoutDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Opravdu se chcete odhlásit?'),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    alignment: Alignment.bottomCenter,
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: const Text('Odhlásit se'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        style: Theme.of(context).textButtonTheme.style!.copyWith(foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)),
        child: const Text('Zrušit'),
      ),
    ],
  );
}

void failedLunchDialog(BuildContext context, String message, Function(Widget widget) setHomeWidget) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Selhalo načítání jídelníčku'),
        content: Text(message),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.bottomCenter,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
            },
            child: const Text('Zkusit znovu'),
          ),
          TextButton(
            onPressed: () {
              loggedInCanteen.logout();
              Navigator.of(context).pop();
              setHomeWidget(LoginScreen(setHomeWidget: setHomeWidget));
            },
            child: const Text('Odhlásit se'),
          ),
        ],
      );
    },
  );
}

void failedLoginDialog(BuildContext context, String message, Function(Widget widget) setHomeWidget) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Přihlašování selhalo'),
        content: Text('Při přihlašování došlo k chybě: $message'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.bottomCenter,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
            },
            child: const Text('Zkusit znovu'),
          ),
          TextButton(
            onPressed: () {
              loggedInCanteen.logout();
              Navigator.of(context).pop();
              setHomeWidget(LoginScreen(setHomeWidget: setHomeWidget));
            },
            child: const Text('Odhlásit se'),
          ),
        ],
      );
    },
  );
}

void failedDownload(BuildContext context, {int? tries}) async {
  if (tries != null && tries > 5) {
    return;
  }
  try {
    if (releaseInfo!.currentlyLatestVersion) {
      return;
    }
  } catch (e) {
    getLatestRelease();
    Future.delayed(
      const Duration(seconds: 1),
      () => newUpdateDialog(context, tries: tries == null ? 1 : tries + 1),
    );
    return;
  }
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Aktualizace aplikace selhala'),
        content: const Text('Při Stahování aplikace došlo k chybě. Ověřte vaše připojení a zkuste znovu.'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.bottomCenter,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              networkInstallApk(releaseInfo!.downloadUrl!, context);
              Navigator.of(context).pop();
            },
            child: const Text('Zkusit znovu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Zrušit'),
          ),
        ],
      );
    },
  );
}
