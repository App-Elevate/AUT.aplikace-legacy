// Code that automatically downloads and installs a new release of the app (once the user has pressed the update button in popup)
import 'package:autojidelna/pages/needed_install_permission.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:permission_handler/permission_handler.dart';

/// Stáhne novou verzi aplikace a nainstaluje ji
void networkInstallApk(String fileUrl, BuildContext context) async {
  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ValueNotifier valueNotifier = ValueNotifier(-1);
  bool neededInstallPermissionPageShown = false;
  BuildContext? neededInstallPermissionPageContext;
  var status = await Permission.requestInstallPackages.status;
  while (status.isDenied) {
    if (context.mounted && !neededInstallPermissionPageShown) {
      neededInstallPermissionPageShown = true;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        neededInstallPermissionPageContext = context;
        return const NeededInstallPermissionPage();
      }));
    }
    await Future.delayed(const Duration(seconds: 1));
    status = await Permission.requestInstallPackages.status;
  }
  if (context.mounted && !snackbarshown.shown) {
    ScaffoldMessenger.of(context)
        .showSnackBar(dynamicSnackbarFunction('aktualizace', context, valueNotifier))
        .closed
        .then((SnackBarClosedReason reason) {
      snackbarshown.shown = false;
    });
  }
  if (neededInstallPermissionPageShown && neededInstallPermissionPageContext!.mounted) {
    // ignore: use_build_context_synchronously
    Navigator.of(neededInstallPermissionPageContext!).pop();
  }
  var tempDownloadDir = await getTemporaryDirectory();
  String savePath = "${tempDownloadDir.path}/${fileUrl.substring(fileUrl.lastIndexOf("/") + 1)}";
  try {
    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      final value = count / total;
      if (valueNotifier.value != value) {
        valueNotifier.value = value;
      }
    });
  } catch (e) {
    valueNotifier.value = -2;
    return;
  }
  final value = await PackageInfo.fromPlatform();

  try {
    if (analyticsEnabledGlobally && analytics != null) {
      analytics!.logEvent(
          name: 'updateDownloaded', parameters: {'oldVersion': value.version, 'newVersion': releaseInfo!.currentlyLatestVersion.toString()});
    }
  } catch (e) {
    //this shouldn't crash but we'll just ignore it if it does. Analytics isn't that important
  }
  await InstallPlugin.install(savePath);
}
