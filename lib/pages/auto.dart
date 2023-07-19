import './../every_import.dart';

class AutoPage extends StatelessWidget {
  const AutoPage({super.key, required this.setHomeWidget});
  final Function setHomeWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autojídelna'),
      ),
      body: const Center(
        child: Text('Tato feature není hotová, ale je v pořadí'),
      ),
      drawer: MainAppDrawer(
          setHomeWidget: setHomeWidget,
          page: NavigationDrawerItem.automatickeObjednavky),
    );
  }
}
