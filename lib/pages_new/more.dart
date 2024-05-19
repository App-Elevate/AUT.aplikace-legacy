import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/pages_new/about.dart';
import 'package:autojidelna/pages_new/settings.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/switch_account_panel_v2.dart';
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
          Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(horizontal: Spacing.shortMedium),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Spacing.shortMedium, vertical: Spacing.short1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Text("username", style: TextStyle(color: Colors.white54)),
                      Flexible(child: CustomDivider(isTransparent: false, hasEndIndent: false)),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.account_circle, size: 75),
                      VerticalDivider(color: Colors.transparent),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Credit: 2000 kč"),
                          Text("Category: Students"),
                        ],
                      ),
                    ],
                  ),
                  MaterialButton(
                    visualDensity: const VisualDensity(vertical: -4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    textColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        clipBehavior: Clip.hardEdge,
                        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .6),
                        builder: (context) => const SwitchAccountPanelV2(),
                      );
                    },
                    child: const Row(
                      children: [
                        Flexible(child: CustomDivider(isTransparent: false, hasIndent: false)),
                        Text("Change account", style: TextStyle(color: Colors.white54)),
                        Flexible(child: CustomDivider(isTransparent: false, hasEndIndent: false)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const CustomDivider(),
          Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(horizontal: Spacing.shortMedium),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Spacing.shortMedium, vertical: Spacing.short1),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text("Location", style: TextStyle(color: Colors.white54)),
                      Flexible(child: CustomDivider(isTransparent: false, hasEndIndent: false)),
                    ],
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity(vertical: -4),
                    title: Text("unknown"),
                  ),
                  MaterialButton(
                    visualDensity: const VisualDensity(vertical: -4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    textColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Flexible(child: CustomDivider(isTransparent: false, hasIndent: false)),
                        Text("Change location", style: TextStyle(color: Colors.white54)),
                        Flexible(child: CustomDivider(isTransparent: false, hasEndIndent: false)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomDivider(height: Spacing.medium2),
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
