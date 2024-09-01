import 'package:autojidelna/consts.dart';
import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DataCollectionScreen extends StatelessWidget {
  const DataCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.blue, decoration: TextDecoration.underline);

    return Scaffold(
      appBar: AppBar(title: Text(lang.settingsDataCollection)),
      body: ScrollViewColumn(
        children: [
          SectionTitle(lang.settingsDataCollection),
          Selector<Settings, ({bool read, void Function(bool) set})>(
            selector: (_, p1) => (read: p1.analytics, set: p1.setAnalytics),
            builder: (_, data, ___) {
              return SwitchListTile(
                title: Text(lang.settingsStopDataCollection),
                value: data.read,
                onChanged: data.set,
              );
            },
          ),
          const CustomDivider(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              text: TextSpan(
                text: lang.settingsDataCollectionDescription_1,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                children: [
                  TextSpan(
                    text: lang.settingsDataCollectionDescription_2,
                    style: style,
                    recognizer: TapGestureRecognizer()..onTap = () => openDataCollectionUrl(true),
                  ),
                  TextSpan(text: lang.settingsDataCollectionDescription_3),
                  TextSpan(
                    text: lang.settingsDataCollectionDescription_4("1"),
                    style: style,
                    recognizer: TapGestureRecognizer()..onTap = () => openDataCollectionUrl(false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openDataCollectionUrl(bool sourceCode) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    String url = sourceCode ? Links.currentVersionCode(appVersion) : Links.listSbiranychDat(appVersion);
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
