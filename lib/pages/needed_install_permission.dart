import 'package:autojidelna/every_import.dart';

class NeededInstallPermissionPage extends StatelessWidget {
  const NeededInstallPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potřebné oprávnění pro Instalaci'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pro automatickou instalaci aktualizace je potřeba povolit oprávnění pro instalaci aplikací z neznámých zdrojů.',
              style: TextStyle(fontSize: 17.5),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Ta může vypadat takto:",
                style: TextStyle(fontSize: 17.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(
                      child:
                          Image.asset('assets/images/install_permission.jpg')),
                  Expanded(
                      child: Image.asset(
                          'assets/images/install_permission_danger.jpg')),
                ],
              ),
            ),
            const Text(
              'Toto oprávnění používáme pouze k aktualizaci aplikace. Pokud si nepřejete oprávnění povolit můžete stále stáhnout apk z githubu.',
              style: TextStyle(fontSize: 17.5),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: SizedBox(
                      width: 550,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: const Size.fromWidth(500),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Udělit Opravnění',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.5,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Permission.requestInstallPackages.request();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size.fromWidth(550),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        //color based on brightness
                        backgroundColor:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? const Color.fromARGB(20, 255, 255, 255)
                                : const Color.fromARGB(20, 0, 0, 0),
                      ),
                      child: const Text(
                        'Zobrazit na githubu',
                        style: TextStyle(fontSize: 17.5),
                      ),
                      onPressed: () {
                        launchUrl(
                            Uri.parse(
                                "https://github.com/tpkowastaken/autojidelna/releases/tag/v${releaseInfo.latestVersion}"),
                            mode: LaunchMode.externalApplication);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
