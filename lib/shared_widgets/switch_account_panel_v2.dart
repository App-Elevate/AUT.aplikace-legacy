import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/pages_new/login.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';

class SwitchAccountPanelV2 extends StatelessWidget {
  const SwitchAccountPanelV2({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<LoggedAccountsInAccountPanel> loggedAccounts =
        ValueNotifier<LoggedAccountsInAccountPanel>(LoggedAccountsInAccountPanel(usernames: [], loggedInID: null));

    // updating the value notifier based on secure storage
    Future<void> updateAccountPanel() async {
      LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
      loggedAccounts.value.usernames.clear();
      for (int i = 0; i < loginData.users.length; i++) {
        loggedAccounts.value.usernames.add(loginData.users[i].username);
      }
      loggedAccounts.value = LoggedAccountsInAccountPanel(usernames: loggedAccounts.value.usernames, loggedInID: loginData.currentlyLoggedInId);
    }

    return Column(
      children: [
        SectionTitle(lang.switchAccountPanelTitle),
        FutureBuilder(
            future: updateAccountPanel(),
            builder: (context, snapshot) {
              return ValueListenableBuilder(
                  valueListenable: loggedAccounts,
                  builder: (context, data, child) {
                    List<Widget> accounts = [];
                    for (int i = 0; i < data.usernames.length; i++) {
                      accounts.add(accountRow(context, i, username: data.usernames[i], currentAccount: i == data.loggedInID));
                    }
                    return Flexible(
                      child: ListView.builder(
                        itemCount: 1, // placeholder
                        itemBuilder: (context, index) => accounts[index],
                      ),
                    );
                  });
            }),
        const CustomDivider(height: 0, isTransparent: false),
        addAccountButton(context)
      ],
    );
  }

  Widget addAccountButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: Text(lang.addAccount, style: Theme.of(context).textTheme.bodyLarge),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreenV2())),
    );
  }

  Widget accountRow(BuildContext context, int id, {String username = "", bool currentAccount = false}) {
    return ListTile(
      //leading: const Icon(Icons.account_circle),
      title: Text(username, style: currentAccount ? const TextStyle(fontWeight: FontWeight.w600) : null),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentAccount) const Icon(Icons.check, size: 30),
          IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.logout, size: 30, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => configuredDialog(context, builder: (BuildContext context) => logoutDialog(context, currentAccount, id))),
        ],
      ),
      onTap: () async {
        if (!currentAccount) {
          await loggedInCanteen.switchAccount(id);
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoggingInWidget()), (route) => false);
          }
        }
      },
    );
  }
}
