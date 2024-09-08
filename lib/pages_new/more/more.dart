import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/pages_new/about.dart';
import 'package:autojidelna/pages_new/more/account.dart';
import 'package:autojidelna/pages_new/settings/settings.dart';
import 'package:autojidelna/pages_new/more/statistics.dart';
import 'package:autojidelna/shared_widgets/more/account_overview_card.dart';
import 'package:autojidelna/shared_widgets/more/location_picker_card.dart';
import 'package:autojidelna/shared_widgets/scroll_view_column.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MoreAppBar({super.key});

  @override
  Widget build(BuildContext context) => AppBar(automaticallyImplyLeading: false, forceMaterialTransparency: true);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollViewColumn(
      children: [
        const AccountOverviewCard(),
        const CustomDivider(),
        const LocationPickerCard(),
        const CustomDivider(height: 38),
        const CustomDivider(isTransparent: false),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(lang.account),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AccountScreen())),
        ),
        /* TODO: make the page
        ListTile(
          leading: const Icon(Icons.analytics_outlined),
          title: Text(lang.statistics),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StatisticsScreen())),
        ),*/
        const CustomDivider(isTransparent: false),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: Text(lang.settings),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(lang.about),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.share_outlined),
          title: Text(lang.shareApp),
          onTap: () async => await Share.share("https://autojidelna.cz/", subject: lang.appName),
        ),
      ],
    );
  }
}
