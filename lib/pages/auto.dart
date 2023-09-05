import './../every_import.dart';

class AutoPage extends StatelessWidget {
  const AutoPage({super.key, required this.setHomeWidget});
  final Function setHomeWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autojídelna'),
        centerTitle: true,
      ),
      //TODO: vytvořit stránku
      body: const Placeholder(),
      drawer: MainAppDrawer(
        setHomeWidget: setHomeWidget,
        page: NavigationDrawerItem.automatickeObjednavky),
    );
  }
}
