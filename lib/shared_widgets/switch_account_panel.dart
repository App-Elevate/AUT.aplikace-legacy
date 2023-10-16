import 'package:autojidelna/every_import.dart';
import 'package:autojidelna/main.dart';

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
  final ValueNotifier<LoggedAccountsInAccountPanel> loggedAccounts =
      ValueNotifier<LoggedAccountsInAccountPanel>(LoggedAccountsInAccountPanel(usernames: [], loggedInID: null));
  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(16.0),
    topRight: Radius.circular(16.0),
  );
  void updateAccountPanel(LoginDataAutojidelna loginData) {
    loggedAccounts.value.usernames.clear();
    for (int i = 0; i < loginData.users.length; i++) {
      loggedAccounts.value.usernames.add(loginData.users[i].username);
    }
    loggedAccounts.value = LoggedAccountsInAccountPanel(usernames: loggedAccounts.value.usernames, loggedInID: loginData.currentlyLoggedInId);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          color: Theme.of(context).colorScheme.surface,
        ),
        child: FutureBuilder(
            future: getLoginDataFromSecureStorage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final loginData = snapshot.data as LoginDataAutojidelna;
                updateAccountPanel(loginData);
                return ValueListenableBuilder(
                    valueListenable: loggedAccounts,
                    builder: (ctx, value, child) {
                      List<Widget> accounts = [];
                      for (int i = 0; i < value.usernames.length; i++) {
                        accounts.add(accountRow(context, value.usernames[i], i == value.loggedInID, i));
                      }
                      Widget addAccountButton = TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          //close before going to the page
                          SwitchAccountVisible().setVisible(false);
                          await Future.delayed(const Duration(milliseconds: 300));
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
                                "Přidat účet",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      );
                      if (accounts.length > 4) {
                        accounts.insert(0, addAccountButton);
                      } else {
                        accounts.add(addAccountButton);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Účty"),
                            const Divider(),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                addRepaintBoundaries: false,
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
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
              }
            }),
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
                await Future.delayed(const Duration(milliseconds: 500));
                LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
                loginData.currentlyLoggedInId = id;
                saveLoginToSecureStorage(loginData);
                try {
                  canteenData = null;
                  canteenInstance = null;
                  changeDate(newDate: DateTime.now());
                } catch (e) {
                  //not needed
                }
                widget.setHomeWidget(LoggingInWidget(setHomeWidget: widget.setHomeWidget));
              } else {
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
            await logout(id: id);
            if (currentAccount) {
              SwitchAccountVisible().setVisible(false);
              await Future.delayed(const Duration(milliseconds: 500));
              widget.setHomeWidget(LoggingInWidget(setHomeWidget: widget.setHomeWidget));
            }
            updateAccountPanel(await getLoginDataFromSecureStorage());
          },
        ),
      ],
    );
  }
}
