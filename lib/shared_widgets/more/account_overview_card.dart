import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/shared_widgets/configured_bottom_sheet.dart';
import 'package:autojidelna/shared_widgets/lined_card.dart';
import 'package:autojidelna/shared_widgets/switch_account_panel.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';

class AccountOverviewCard extends StatelessWidget {
  const AccountOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    Uzivatel? user = loggedInCanteen.uzivatel;

    return LinedCard(
      title: user!.uzivatelskeJmeno!,
      footer: lang.changeAccount,
      onPressed: () => configuredBottomSheet(context, builder: (context) => const SwitchAccountPanel()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.account_circle, size: 75),
          const VerticalDivider(color: Colors.transparent),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(lang.credit(user.kredit), style: Theme.of(context).textTheme.titleMedium),
              if (user.kategorie != null) Text(user.kategorie!),
            ],
          ),
        ],
      ),
    );
  }
}
