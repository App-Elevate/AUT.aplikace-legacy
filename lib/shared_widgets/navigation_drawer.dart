import './../every_import.dart';

class MainAppDrawer extends StatelessWidget {
  const MainAppDrawer({
    super.key,
    required this.setHomeWidget,
    required this.page,
  });
  final Function setHomeWidget;
  final NavigationDrawerItem page;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Text('Autojídelna'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  title: const Text(
                    'Jídelníček',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(
                    Icons.restaurant,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : const Color(0xff323232),
                    size: 30,
                  ),
                  selected: page == NavigationDrawerItem.jidelnicek,
                  onTap: () async {
                    if (page == NavigationDrawerItem.jidelnicek) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 200));
                      setHomeWidget(
                        MainAppScreen(
                          setHomeWidget: setHomeWidget,
                        ),
                      );
                    }
                  },
                ),
              ),
              /*
              ListTile(
                title: const Text('Automatické objednávky'),
                //icon that signilizes automatization
                leading: const Icon(Icons.autorenew),
                selected: page == NavigationDrawerItem.automatickeObjednavky,
                onTap: () async {
                  if (page == NavigationDrawerItem.automatickeObjednavky) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 200));
                    setHomeWidget(AutoPage(
                      setHomeWidget: setHomeWidget,
                    ));
                  }
                },
              ),
              ListTile(
                title: const Text('Burza Catcher'),
                //ikonka blesku
                leading: const Icon(Icons.flash_on),
                selected: page == NavigationDrawerItem.burzaCatcher,
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "Tato Feature není hotová",
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(255, 48, 48, 48),
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
