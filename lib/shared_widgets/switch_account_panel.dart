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
                    child: GestureDetector(
                      //TODO: make the account switch
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.account_circle, size: 30),
                              const SizedBox(width: 10),
                              Text(
                                canteenData.username,
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
                  IconButton(
                    icon: const Icon(Icons.logout, size: 30),
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
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  splashFactory: NoSplash.splashFactory,
                  foregroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                ),
                onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
