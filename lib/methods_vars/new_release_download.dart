import 'package:autojidelna/pages/needed_install_permission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:autojidelna/every_import.dart';
void showResMsg(String msg) {
    print(msg);
  }
double _progressValue = 0.0;
void networkInstallApk(String fileUrl, BuildContext context) async {
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ValueNotifier valueNotifier = ValueNotifier(-1);
    if (context.mounted && !snackbarshown.shown) {
      ScaffoldMessenger.of(context)
          .showSnackBar(dynamicSnackbarFunction(
              'aktualizace',context, valueNotifier))
          .closed
          .then((SnackBarClosedReason reason) {
        snackbarshown.shown = false;
      });
    }
    bool neededInstallPermissionPageShown = false;
    BuildContext? neededInstallPermissionPageContext;
    var status = await Permission.requestInstallPackages.status;
    while(status.isDenied){
      if(context.mounted && !neededInstallPermissionPageShown){
        neededInstallPermissionPageShown = true;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              neededInstallPermissionPageContext = context;
              return const NeededInstallPermissionPage();}));
      }
      await Future.delayed(const Duration(seconds: 1));
      status = await Permission.requestInstallPackages.status;
    }
    if(neededInstallPermissionPageShown && neededInstallPermissionPageContext!.mounted){
      Navigator.of(neededInstallPermissionPageContext!).pop();
    }
    var tempDownloadDir = await getTemporaryDirectory();
    String savePath = "${tempDownloadDir.path}/${fileUrl.substring(fileUrl.lastIndexOf("/") + 1)}";
    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      final value = count / total;
      if (valueNotifier.value != value) {
        valueNotifier.value = value;
        print("${(valueNotifier.value * 100).toStringAsFixed(0)}%");
      }
    });

    final res = await InstallPlugin.install(savePath);
    showResMsg(
        "install apk ${res['isSuccess'] == true ? 'success' : 'fail: ${res['errorMessage'] ?? ''}'}");
  }
