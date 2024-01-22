// Page that opens when the user hasn't granted the permission to install apps from unknown sources

import 'package:autojidelna/local_imports.dart';

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:url_launcher/url_launcher.dart';

class NeededInstallPermissionPage extends StatelessWidget {
  const NeededInstallPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Texts.neededPermission.i18n()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Texts.neededPermissionDescription.i18n(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  Texts.neededPermissionDescription2.i18n(),
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
                Texts.neededPermissionDescription3.i18n(),
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
                          child: Text(Texts.allowPermission.i18n()),
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
                          child: Text(Texts.popupShowOnGithub.i18n()),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            launchUrl(Uri.parse(Links.latestRelease), mode: LaunchMode.externalApplication);
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
