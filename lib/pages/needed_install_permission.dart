// Page that opens when the user hasn't granted the permission to install apps from unknown sources

import 'package:autojidelna/local_imports.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class NeededInstallPermissionPage extends StatelessWidget {
  const NeededInstallPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potřebné oprávnění'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pro automatickou instalaci aktualizace je potřeba povolit oprávnění pro instalaci aplikací z neznámých zdrojů.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Ta může vypadat takto:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
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
              Text(
                'Toto oprávnění používáme pouze k aktualizaci aplikace. Pokud si nepřejete oprávnění povolit můžete stále stáhnout apk z githubu.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
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
                          onPressed: () async {
                            Navigator.of(context).pop();
                            ReleaseInfo? localReleaseInfo = releaseInfo;
                            localReleaseInfo ??= await getLatestRelease();
                            launchUrl(Uri.parse("https://github.com/tpkowastaken/autojidelna/releases/tag/v${localReleaseInfo.latestVersion}"),
                                mode: LaunchMode.externalApplication);
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
      ),
    );
  }
}
