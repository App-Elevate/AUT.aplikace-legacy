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
    final String username = getCanteenData().username;
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Text('Autojídelna'),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      setHomeWidget: setHomeWidget,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      color: MediaQuery.of(context).platformBrightness == Brightness.dark?const Color(0xff2e2e2e):const Color(0xfffafafa),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark?Colors.black:Colors.black,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    setHomeWidget: setHomeWidget,
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark?Colors.white:Colors.white,
                              Icons.person),
                          ),
                        ),
                        Center(
                          child: Text(username),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Jídelníček'),
              leading: const Icon(Icons.restaurant),
              selected: page == NavigationDrawerItem.jidelnicek,
              onTap: () async {
                if (page == NavigationDrawerItem.jidelnicek) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 200));
                  setHomeWidget(MainAppScreen(
                    setHomeWidget: setHomeWidget,
                  ));
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => {
                  logout(),
                  setHomeWidget(LoginScreen(
                    setHomeWidget: setHomeWidget,
                  ))
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Odhlásit se'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
