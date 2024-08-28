import 'package:autojidelna/consts.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/notifications.dart';
import 'package:autojidelna/pages_new/canteen.dart';
import 'package:autojidelna/pages_new/more/more.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;

  void changePageIndex(int index) => setState(() => pageIndex = index);

  @override
  initState() {
    loggedInCanteen.readData(Prefs.firstTime).then((value) {
      if (value != '1') {
        initPlatformState().then((value) async {
          await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
            if (!isAllowed) {
              //TODO: less annoying popup for notifications - show a friendly screen before asking
              AwesomeNotifications().requestPermissionToSendNotifications();
            }
            BackgroundFetch.start();
          });
        });
      } else {
        initPlatformState();
      }
      loggedInCanteen.saveData(Prefs.firstTime, '1');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: <PreferredSizeWidget>[
        const CanteenAppBar(),
        const MoreAppBar(),
      ][pageIndex],
      body: <Widget>[
        const CanteenPage(),
        const MorePage(),
      ][pageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        onDestinationSelected: changePageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            selectedIcon: Icon(Icons.menu_book_outlined),
            label: "Canteen",
            tooltip: "Canteen page",
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            selectedIcon: Icon(Icons.more_horiz_outlined),
            label: "More",
            tooltip: "More page",
          ),
        ],
      ),
    );
  }
}
