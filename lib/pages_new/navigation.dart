import 'package:autojidelna/pages_new/canteen.dart';
import 'package:autojidelna/pages_new/more/more.dart';
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
