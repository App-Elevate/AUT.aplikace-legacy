// Contains the panel that shows up when the user clicks on the account icon in the account drawer

import 'package:autojidelna/local_imports.dart';

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SwitchAccountPanel extends StatefulWidget {
  const SwitchAccountPanel({
    super.key,
    required this.setHomeWidget,
  });
  final Function(Widget widget) setHomeWidget;

  @override
  State<SwitchAccountPanel> createState() => _SwitchAccountPanelState();
}

class _SwitchAccountPanelState extends State<SwitchAccountPanel> {
  // used for dynamic updating of the account panel in case an account is removed or added
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

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: autojidelnaStyles.accountPanelRadius,
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: autojidelnaStyles.accountPanelRadius,
          color: Theme.of(context).colorScheme.surface,
        ),
        child: FutureBuilder(
            future: updateAccountPanel(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ValueListenableBuilder(
                    valueListenable: loggedAccounts,
                    builder: (ctx, value, child) {
                      List<Widget> accounts = [];

                      for (int i = 0; i < value.usernames.length; i++) {
                        accounts.add(accountRow(context, value.usernames[i], i == value.loggedInID, i));
                      }
                      // We want to have the add account button at the bottom.
                      // If there are more than 4 accounts we flip the list
                      // therefore we need to insert the button at the beginning
                      // otherwise we put it at the end
                      // This is so that the scrolling starts at the top
                      if (accounts.length > 4) {
                        accounts.insert(0, addAccountButton(context));
                      } else {
                        accounts.add(addAccountButton(context));
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(consts.texts.accPanelTitle.i18n()),
                            const Divider(),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                addRepaintBoundaries: false,
                                // Here is the flipping of the list
                                reverse: accounts.length > 5 ? true : false,
                                itemCount: accounts.length,
                                itemBuilder: (context, index) => accounts[index],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }

  TextButton addAccountButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () async {
        //close before going to the page
        SwitchAccountVisible().setVisible(false);
        // wait for the animation to finish
        await Future.delayed(Duration(milliseconds: consts.nums.switchAccountPanelDuration));
        // pushing loginPage
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(setHomeWidget: widget.setHomeWidget)));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.add),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              consts.texts.accPanelAddAccount.i18n(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Row accountRow(BuildContext context, String username, bool currentAccount, int id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (!currentAccount) {
                SwitchAccountVisible().setVisible(false);
                await loggedInCanteen.switchAccount(id);
                // wait for the animation to finish
                await Future.delayed(Duration(milliseconds: consts.nums.switchAccountPanelDuration));
                widget.setHomeWidget(LoggingInWidget(setHomeWidget: widget.setHomeWidget));
              } else {
                // if the user clicks on the account that is already logged in
                // we don't have to do any changes so we just close it
                SwitchAccountVisible().setVisible(false);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        username,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 19),
                      ),
                    ),
                  ],
                ),
                if (currentAccount) const Icon(Icons.check),
              ],
            ),
          ),
        ),
        //Logout button
        IconButton(
          icon: Icon(
            Icons.logout,
            size: 30,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () async {
            // popup asking the user if they are sure they want to logout
            try {
              bool confirmation =
                  await showDialog(context: context, barrierDismissible: true, builder: (BuildContext context) => logoutDialog(context)) == true;
              if (!confirmation) {
                return;
              }
            } catch (e) {
              return;
            }
            await loggedInCanteen.logout(id: id);
            // if the account is current it has to reload the main app screen
            if (currentAccount) {
              SwitchAccountVisible().setVisible(false);
              // wait for the animation to finish
              await Future.delayed(Duration(milliseconds: consts.nums.switchAccountPanelDuration));
              widget.setHomeWidget(LoggingInWidget(setHomeWidget: widget.setHomeWidget));
            }
            updateAccountPanel();
          },
        ),
      ],
    );
  }
}
