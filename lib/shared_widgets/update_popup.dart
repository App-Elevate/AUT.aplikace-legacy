import 'package:autojidelna/every_import.dart';
import 'package:markdown/markdown.dart' as md;
newUpdateDialog(BuildContext context) async {
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
