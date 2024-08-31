import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';
import 'package:autojidelna/shared_widgets/more/account_overview_card.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Uzivatel user = loggedInCanteen.uzivatel!;
    bool firstName = user.jmeno != null && user.jmeno!.trim().isNotEmpty;
    bool lastName = user.prijmeni != null && user.prijmeni!.trim().isNotEmpty;
    bool category = user.kategorie != null && user.kategorie!.trim().isNotEmpty;
    bool bankAccount = user.ucetProPlatby != null && user.ucetProPlatby!.trim().isNotEmpty;
    bool varSymbol = user.varSymbol != null && user.varSymbol!.trim().isNotEmpty;
    bool specSymbol = user.specSymbol != null && user.specSymbol!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.account),
        actions: [_appBarLogoutButton(context)],
      ),
      body: ListView(
        children: [
          const CustomDivider(height: 30),
          const AccountOverviewCard(),
          const CustomDivider(height: 38),
          if ((firstName && lastName) || category) SectionTitle(lang.personalInfo),
          if (firstName && lastName)
            ListTile(
              title: Text('${user.jmeno!} ${user.prijmeni!}'),
              subtitle: Text(lang.name),
            ),
          if (lastName)
            ListTile(
              title: Text(user.kategorie!),
              subtitle: Text(lang.category),
            ),
          if (bankAccount || varSymbol || specSymbol) SectionTitle(lang.paymentInfo),
          if (bankAccount)
            ListTile(
              title: Text(user.ucetProPlatby!),
              subtitle: Text(lang.paymentAccountNumber),
            ),
          if (varSymbol)
            ListTile(
              title: Text(user.varSymbol!),
              subtitle: Text(lang.variableSymbol),
            ),
          if (specSymbol)
            ListTile(
              title: Text(user.specSymbol!),
              subtitle: Text(lang.specificSymbol),
            ),
        ],
      ),
    );
  }

  Padding _appBarLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        onPressed: () => configuredDialog(context, builder: (BuildContext context) => logoutDialog(context)),
        icon: const Icon(Icons.logout),
      ),
    );
  }
}
