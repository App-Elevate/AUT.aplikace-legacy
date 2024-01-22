// Soubor pro automatickou aktualizaci aplikace. Tento soubor získá informace z githubu a následně zobrazí popup

import 'dart:convert';
import 'dart:io';

import 'package:autojidelna/local_imports.dart';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:localization/localization.dart';

import 'package:package_info_plus/package_info_plus.dart';

ReleaseInfo? releaseInfo;

///gets the latest release info from github
Future<ReleaseInfo> getLatestRelease() async {
  try {
    if (kDebugMode) {
      bool isAndroid = false;
      if (Platform.isAndroid) {
        isAndroid = true;
      }
      releaseInfo = ReleaseInfo(isAndroid: isAndroid, currentlyLatestVersion: true);
      return releaseInfo!;
    }
    bool isAndroid = false;
    if (Platform.isAndroid) {
      isAndroid = true;
    }
    Uri url = Uri.parse(Links.latestVersionApi);
    const Map<String, String> headers = {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };
    final response = await http.get(url, headers: headers);
    dynamic isOnAppstoreJson;
    try {
      final isOnAppstore = await http.get(Uri.parse(Links.appStore));
      //decode isOnAppstore as json
      isOnAppstoreJson = jsonDecode(isOnAppstore.body);
    } catch (e) {
      // just ignore it
    }
    var json = jsonDecode(response.body);
    String version = json['tag_name'].replaceAll('v', '');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    if (!isAndroid) {
      releaseInfo = ReleaseInfo(isAndroid: isAndroid, currentlyLatestVersion: version == appVersion);
      return releaseInfo!;
    }
    String? patchNotes;
    String? downloadUrl;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    try {
      patchNotes = utf8.decode((await http.get(Uri.parse(Links.currentChangelog(version)))).bodyBytes);
      patchNotes = patchNotes.split('## $appVersion')[0];
      patchNotes = patchNotes.trim();
    } catch (e) {
      patchNotes = Texts.errorsChangelog.i18n();
    }
    if (patchNotes == '404: Not Found') {
      patchNotes = Texts.errorsChangelog.i18n();
    }

    for (int i = 0; i < json['assets'].length; i++) {
      String apkname = json['assets'][i]['browser_download_url'].split('/').last;
      if (apkname.contains('.apk')) {
        apkname.replaceAll('.apk', '');
      }
      for (int k = 0; k < androidInfo.supportedAbis.length; k++) {
        if (downloadUrl != null) {
          break;
        }
        // either download the smaller package or every abi if the system hasn't been found
        if (apkname.contains(androidInfo.supportedAbis[k]) || i == json['assets'].length - 2) {
          downloadUrl = json['assets'][i]['browser_download_url'];
        }
      }
    }
    //get current app version
    try {
      releaseInfo = ReleaseInfo(
        isAndroid: isAndroid,
        latestVersion: version,
        downloadUrl: downloadUrl,
        changelog: patchNotes,
        currentlyLatestVersion: version == appVersion,
        isOnGooglePlay: bool.tryParse(isOnAppstoreJson?['onGooglePlay']) ?? false,
        googlePlayUrl: isOnAppstoreJson?['GooglePlayUrl'],
        appStoreUrl: isOnAppstoreJson?['AppStoreUrl'],
        isOnAppstore: bool.tryParse(isOnAppstoreJson?['onAppStore']) ?? false,
      );
    } catch (e) {
      releaseInfo = ReleaseInfo(
        isAndroid: isAndroid,
        latestVersion: version,
        downloadUrl: downloadUrl,
        changelog: patchNotes,
        currentlyLatestVersion: version == appVersion,
      );
    }
    return releaseInfo!;
  } catch (e) {
    //having the last version isn't so important so we can just ignore it if it goes wrong
    bool isAndroid = false;
    if (Platform.isAndroid) {
      isAndroid = true;
    }
    releaseInfo = ReleaseInfo(isAndroid: isAndroid, currentlyLatestVersion: true);
    return releaseInfo!;
  }
}
