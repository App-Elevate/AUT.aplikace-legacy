import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/consts.dart';
import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DataCollectionScreen extends StatelessWidget {
  const DataCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Collection")),
      body: ScrollViewColumn(
        children: [
          const SectionTitle("Data Collection"),
          SwitchListTile(
            title: const Text("Sell your data"),
            value: true,
            onChanged: (value) {},
          ),
          CustomDivider(height: Spacing.s8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.s16),
            child: RichText(
              text: TextSpan(
                text: Texts.settingsDataCollectionDescription1.i18n(),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                children: [
                  TextSpan(
                    text: Texts.settingsDataCollectionDescription2.i18n(),
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () => openDataCollectionUrl(true),
                  ),
                  TextSpan(
                    text: Texts.settingsDataCollectionDescription3.i18n(),
                  ),
                  TextSpan(
                    text: Texts.settingsDataCollectionDescription4.i18n(),
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
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
