import 'package:autojidelna/every_import.dart';

class NeededInstallPermissionPage extends StatelessWidget {
  const NeededInstallPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potřebné oprávnění'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pro automatickou instalaci aktualizace je potřeba povolit oprávnění pro instalaci aplikací z neznámých zdrojů.'),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Ta může vypadat takto:"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(child: Image.asset('assets/images/install_permission.jpg')),
                  Expanded(child: Image.asset('assets/images/install_permission_danger.jpg')),
                ],
              ),
            ),
            const Text(
                'Toto oprávnění používáme pouze k aktualizaci aplikace. Pokud si nepřejete oprávnění povolit můžete stále stáhnout apk z githubu.'),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: SizedBox(
                      width: 550,
                      child: ElevatedButton(
                        child: const Text('Udělit Opravnění'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Permission.requestInstallPackages.request();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: SizedBox(
                      width: 550,
                      child: ElevatedButton(
                        child: const Text('Zobrazit na githubu'),
                        onPressed: () {
                          launchUrl(Uri.parse("https://github.com/tpkowastaken/autojidelna/releases/tag/v${releaseInfo.latestVersion}"),
                              mode: LaunchMode.externalApplication);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
