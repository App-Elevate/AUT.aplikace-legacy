import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/pages_new/about.dart';
import 'package:autojidelna/pages_new/account.dart';
import 'package:autojidelna/pages_new/settings.dart';
import 'package:autojidelna/shared_widgets/more/account_overview_card.dart';
import 'package:autojidelna/shared_widgets/more/location_picker_card.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          const AccountOverviewCard(),
          const CustomDivider(),
          const LocationPickerCard(),
          CustomDivider(height: Spacing.s24),
          const SectionTitle("Something"),
          //CustomDivider(height: Spacing.short1),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Account"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AccountScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutScreen())),
          ),
        ],
      ),
    );
  }
}
