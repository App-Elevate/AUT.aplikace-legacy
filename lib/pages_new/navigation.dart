import 'package:autojidelna/pages_new/account.dart';
import 'package:autojidelna/pages_new/canteen.dart';
import 'package:autojidelna/pages_new/more.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: <PreferredSizeWidget>[
        const CanteenAppBar(),
        const AccountAppBar(),
        const MoreAppBar(),
      ][pageIndex],
      body: <Widget>[
        const CanteenPage(),
        const AccountPage(),
        const MorePage(),
      ][pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        currentIndex: pageIndex,
        onTap: changePageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            activeIcon: Icon(Icons.abc),
            label: "",
            tooltip: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            activeIcon: Icon(Icons.abc),
            label: "",
            tooltip: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            activeIcon: Icon(Icons.abc),
            label: "",
            tooltip: "",
          ),
        ],
      ),
    );
  }
}
