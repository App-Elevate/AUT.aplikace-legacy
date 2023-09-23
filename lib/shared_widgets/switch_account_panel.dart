import 'package:autojidelna/every_import.dart';

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

  bool currentAccount = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xff323232) : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Účty",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            //TODO: make the account switch
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.account_circle),
                                    const SizedBox(width: 10),
                                    Text(canteenData.username),
                                  ],
                                ),
                                if (currentAccount) const Icon(Icons.check),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            logout();
                            /*logout();
                                Navigator.of(context).pop(
                                  setHomeWidget(
                                    LoginScreen(
                                      setHomeWidget: setHomeWidget,
                                    ),
                                  ),
                                );*/
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
