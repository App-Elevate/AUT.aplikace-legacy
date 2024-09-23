import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/pages_new/login.dart';
import 'package:autojidelna/shared_widgets/configured_dialog.dart';
import 'package:autojidelna/shared_widgets/popups.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:autojidelna/shared_widgets/settings/section_title.dart';
import 'package:flutter/material.dart';

class SwitchAccountPanel extends StatefulWidget {
  const SwitchAccountPanel({super.key});

  @override
  State<SwitchAccountPanel> createState() => _SwitchAccountPanelState();
}

class _SwitchAccountPanelState extends State<SwitchAccountPanel> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoggedAccountsInAccountPanel>(
      future: _fetchLoggedAccounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        LoggedAccountsInAccountPanel data = snapshot.data!;

        List<Widget> accounts = [];
        for (int i = 0; i < data.usernames.length; i++) {
          accounts.add(accountRow(context, i, username: data.usernames[i], currentAccount: i == data.loggedInID));
        }

        return Column(
          children: [
            SectionTitle(lang.switchAccountPanelTitle),
            Flexible(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) => accounts[index],
              ),
            ),
            const CustomDivider(height: 0, isTransparent: false),
            addAccountButton(context),
          ],
        );
      },
    );
  }

  Future<LoggedAccountsInAccountPanel> _fetchLoggedAccounts() async {
    LoginDataAutojidelna loginData = await loggedInCanteen.getLoginDataFromSecureStorage();
    return LoggedAccountsInAccountPanel(
      usernames: loginData.users.map((user) => user.username).toList(),
      loggedInID: loginData.currentlyLoggedInId,
    );
  }

  Widget addAccountButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: Text(lang.addAccount, style: Theme.of(context).textTheme.bodyLarge),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen())),
    );
  }

  Widget accountRow(BuildContext context, int id, {String username = '', bool currentAccount = false}) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(username, style: currentAccount ? const TextStyle(fontWeight: FontWeight.w600) : null),
          if (currentAccount) const Icon(Icons.check, size: 30),
        ],
      ),
      trailing: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.logout, size: 30, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () async {
            if (currentAccount && context.mounted) {
              configuredDialog(
                context,
                builder: (BuildContext context) => logoutDialog(context, currentAccount: currentAccount, id: id),
              );
            } else if (context.mounted) {
              await loggedInCanteen.logout(id: id);
              setState(() {});
            }
          }),
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
