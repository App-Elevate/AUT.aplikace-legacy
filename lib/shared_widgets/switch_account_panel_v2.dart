import 'package:autojidelna/classes_enums/spacing.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';

class SwitchAccountPanelV2 extends StatelessWidget {
  const SwitchAccountPanelV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionTitle("Accounts"),
        Flexible(
          child: ListView.builder(
            itemCount: 1, // placeholder
            itemBuilder: (context, index) {
              return accountRow(context, "Placeholder", false, 0);
            },
          ),
        ),
        CustomDivider(height: Spacing.zero, isTransparent: false),
        addAccountButton(context)
      ],
    );
  }

  Widget addAccountButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: Text("Add account", style: Theme.of(context).textTheme.bodyLarge),
      onTap: () {},
    );
  }

  Widget accountRow(BuildContext context, String username, bool currentAccount, int id) {
    return ListTile(
      //leading: const Icon(Icons.account_circle),
      title: Text(username, style: currentAccount ? const TextStyle(fontWeight: FontWeight.w600) : null),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentAccount) const Icon(Icons.check),
          IconButton(icon: const Icon(Icons.logout, size: 30), onPressed: () {}),
        ],
      ),
      onTap: () {},
    );
  }
}