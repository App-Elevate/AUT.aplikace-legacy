import 'package:autojidelna/shared_widgets/configured_bottom_sheet.dart';
import 'package:autojidelna/shared_widgets/lined_card.dart';
import 'package:autojidelna/shared_widgets/switch_account_panel_v2.dart';
import 'package:flutter/material.dart';

class AccountOverviewCard extends StatelessWidget {
  const AccountOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LinedCard(
      title: "Username",
      footer: "Change account",
      onPressed: () => configuredBottomSheet(context, builder: (context) => const SwitchAccountPanelV2()),
      child: const Row(
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
    );
  }
}
