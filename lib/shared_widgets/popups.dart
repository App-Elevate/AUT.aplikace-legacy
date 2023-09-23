import 'package:autojidelna/every_import.dart';
import 'package:autojidelna/main.dart';
import 'package:markdown/markdown.dart' as md;
void newUpdateDialog(BuildContext context, {int? tries}) {

  if(tries != null && tries > 5){
    return;
  }
  try{
    if(releaseInfo.isAndroid == false){
      return;
    }
    if(releaseInfo.currentlyLatestVersion!){
      return;
    }
  }
  catch(e){
    Future.delayed(const Duration(seconds: 1), () => newUpdateDialog(context, tries: tries == null?1:tries+1));
  }
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Nová verze aplikace'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                child: Text('Vyšla nová verze aplikace - ${releaseInfo.latestVersion}'),
              ),
              const Text('Nová aktualizace přináší:'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: HtmlWidget(md.markdownToHtml(releaseInfo.changelog ?? 'Changelog není k dispozici'), ),
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  //color based on brightness
                  backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark?const Color.fromARGB(20, 255, 255, 255):const Color.fromARGB(20, 0, 0, 0),
                ),
                child: const Text('Aktualizovat'),
                onPressed: () {
                  Navigator.of(context).pop();

                  PackageInfo.fromPlatform().then((value) {
                    if(analyticsEnabledGlobally && analytics != null){
                      analytics!.logEvent(name: 'updateButtonClicked', parameters: {'oldVersion': value.version, 'newVersion': releaseInfo.currentlyLatestVersion.toString()});
                    }
                  });
                  networkInstallApk(releaseInfo.downloadUrl!, context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  //color based on brightness
                  backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark?const Color.fromARGB(20, 255, 255, 255):const Color.fromARGB(20, 0, 0, 0),
                ),
                onPressed: (() => launchUrl(
                    Uri.parse("https://github.com/tpkowastaken/autojidelna/releases/tag/v${releaseInfo.latestVersion}"),
                    mode: LaunchMode.externalApplication)),
                child: const Text('Zobrazit na githubu'),
              ),
              ElevatedButton(
                //make smaller space after the text
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  //color based on brightness
                  backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark?const Color.fromARGB(20, 255, 255, 255):const Color.fromARGB(20, 0, 0, 0),
                ),
                child: const Text('Teď ne'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
void failedLoginDialog(BuildContext context, String message, Function setHomeWidget) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Přihlašování selhalo'),
        content: Text('Při přihlašování došlo k chybě: $message'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: <Widget>[
          TextButton(onPressed: () {
            Navigator.of(context).pop();
            setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
          },
          child: const Text('Zkusit znovu')
          ),
          TextButton(onPressed: () {
            logout();
            Navigator.of(context).pop();
            setHomeWidget(LoginScreen(setHomeWidget: setHomeWidget));
          },
          child: const Text('Odhlásit se')),
        ],
      );
    },
  );
}

void failedDownload(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Aktualizace aplikace selhala'),
        content: const Text('Při Stahování aplikace došlo k chybě. Ověřte vaše připojení a zkuste znovu...'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: <Widget>[
          TextButton(onPressed: () {
            networkInstallApk(releaseInfo.downloadUrl!, context);
            Navigator.of(context).pop();
          },
          child: const Text('Zkusit znovu')
          ),
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Zrušit')
          ),
        ],
      );
    },
  );
}