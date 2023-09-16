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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(children: [
            const Text('Pro automatickou instalaci aktualizace je potřeba povolit oprávnění pro instalaci aplikací z neznámých zdrojů. Ta může vypadat takto:', style: TextStyle(fontSize: 20),),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(child: Image.asset('assets/images/install_permission.jpg')),
                  Expanded(child: Image.asset('assets/images/install_permission_danger.jpg')),
                ],
              ),
            ),
            const Text('Toto oprávnění používáme pouze k aktualizaci aplikace a i tak aktualizace vyžaduje vaše potvrzení. Pokud si nepřejete oprávnění povolit můžete stále stáhnout apk z githubu...', style: TextStyle(fontSize: 20),),
            Row(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: () {
                      launchUrl(
                      Uri.parse("https://github.com/tpkowastaken/autojidelna/releases/tag/v${releaseInfo.latestVersion}"),
                      mode: LaunchMode.externalApplication);
                    Navigator.of(context).pop();
                  }, child: const Text('Otevřít Github')),
                )),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                    Permission.requestInstallPackages.request();
                    }, child: const Text('Udělit Opravnění')),
                ))
              ],
            )
          ]),
        ),
      ),
    );
  }
}