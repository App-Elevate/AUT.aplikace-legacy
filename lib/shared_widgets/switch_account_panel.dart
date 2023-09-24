import 'package:autojidelna/every_import.dart';
import 'package:autojidelna/main.dart';

class SwitchAccountPanel extends StatefulWidget {
  const SwitchAccountPanel({
    super.key,
    required this.setHomeWidget,
  });
  final Function setHomeWidget;

  @override
  State<SwitchAccountPanel> createState() => _SwitchAccountPanelState();
}

class _SwitchAccountPanelState extends State<SwitchAccountPanel> {
  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(16.0),
    topRight: Radius.circular(16.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xff323232) : Colors.white,
        ),
        child: FutureBuilder(
          future: getLoginDataFromSecureStorage(),
          builder: (context, snapshot) {
            List<Widget> accounts = [
              const Text(
                "Účty",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
              ),
              const Divider(),
            ];
            if(snapshot.connectionState == ConnectionState.done){
              final loginData = snapshot.data as LoginData;
              for(int i = 0;i<loginData.users.length;i++){
                LoggedInUser account = loginData.users[i];
                accounts.add(accountRow(context, account.username, i == loginData.currentlyLoggedInId, i));
              }
              accounts.add(
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      widget.setHomeWidget(LoginScreen(setHomeWidget: widget.setHomeWidget));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.add, size: 31),
                        SizedBox(width: 10),
                        Text(
                          "Přidat účet",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: accounts
              ),
            );
          }
        ),
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
              if(!currentAccount){
                LoginData loginData = await getLoginDataFromSecureStorage();
                loginData.currentlyLoggedInId = id;
                saveLoginToSecureStorage(loginData);
                SwitchAccountVisible().setVisible(false);
                await Future.delayed(const Duration(milliseconds: 500));
                widget.setHomeWidget(
                  LoggingInWidget(setHomeWidget: widget.setHomeWidget)
                );
              }
              else{
                SwitchAccountVisible().setVisible(false);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                if (currentAccount) const Icon(Icons.check, size: 30),
              ],
            ),
          ),
        ),
        //Logout button
        IconButton(
          icon: const Icon(Icons.logout, size: 30),
          onPressed: () async {
            await logout(id: id);
            if(currentAccount){
              SwitchAccountVisible().setVisible(false);
              await Future.delayed(const Duration(milliseconds: 500));
              widget.setHomeWidget(
                LoggingInWidget(setHomeWidget: widget.setHomeWidget)
              );
            }
              SwitchAccountVisible().setVisible(true);

          },
        ),
      ],
    );
  }
}
