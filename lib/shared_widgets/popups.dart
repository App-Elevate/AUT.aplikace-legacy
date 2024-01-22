// Includes all popups used in the app.

// Used for determining platform
import 'dart:io';

// flutter
import 'package:flutter/material.dart';

import 'package:autojidelna/local_imports.dart';
import 'package:localization/localization.dart';

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
        title: Text(consts.texts.popupNewVersion.i18n([releaseInfo!.latestVersion.toString()])),
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
                      consts.texts.popupNewUpdateInfo.i18n(),
                      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 0),
                    child: HtmlWidget(
                      textStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      md.markdownToHtml(releaseInfo!.changelog ?? consts.texts.popupChangeLogNotAvailable.i18n()),
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
                      child: Text(consts.texts.popupUpdate.i18n()),
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
                                name: consts.analyticsEventIds.updateButtonClicked,
                                parameters: {
                                  consts.analyticsEventIds.oldVer: value.version,
                                  consts.analyticsEventIds.newVer: releaseInfo!.currentlyLatestVersion.toString()
                                },
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
                      onPressed: (() => launchUrl(Uri.parse(consts.links.latestRelease), mode: LaunchMode.externalApplication)),
                      child: Text(consts.texts.popupShowOnGithub.i18n()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 500,
                    child: ElevatedButton(
                      child: Text(consts.texts.popupNotNow.i18n()),
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
    title: Text(consts.texts.logoutUSure.i18n()),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    alignment: Alignment.bottomCenter,
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: Text(consts.texts.logoutConfirm.i18n()),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        style: Theme.of(context).textButtonTheme.style!.copyWith(foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)),
        child: Text(consts.texts.logoutCancel.i18n()),
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
        title: Text(consts.texts.errorsLoad),
        content: Text(message),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.bottomCenter,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
            },
            child: Text(consts.texts.failedDialogTryAgain),
          ),
          TextButton(
            onPressed: () {
              loggedInCanteen.logout();
              Navigator.of(context).pop();
              setHomeWidget(LoginScreen(setHomeWidget: setHomeWidget));
            },
            child: Text(consts.texts.failedDialogLogOut),
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
        title: Text(consts.texts.failedDialogLoginFailed.i18n()),
        content: Text(consts.texts.failedDialogLoginDetail.i18n([message])),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.bottomCenter,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
            },
            child: Text(consts.texts.failedDialogTryAgain.i18n()),
          ),
          TextButton(
            onPressed: () {
              loggedInCanteen.logout();
              Navigator.of(context).pop();
              setHomeWidget(LoginScreen(setHomeWidget: setHomeWidget));
            },
            child: Text(consts.texts.failedDialogLogOut.i18n()),
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
        title: Text(consts.texts.failedDialogDownload.i18n()),
        content: Text(consts.texts.failedDialogDownloadDetail.i18n()),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.bottomCenter,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              networkInstallApk(releaseInfo!.downloadUrl!, context);
              Navigator.of(context).pop();
            },
            child: Text(consts.texts.failedDialogTryAgain.i18n()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(consts.texts.faliedDialogCancel.i18n()),
          ),
        ],
      );
    },
  );
}
