import './../every_import.dart';

/*zde se budou nacházet nastavení a možnost zakoupit pro a vidět statistiky profilu Icanteen. Zároveň zde bude systém pro měnění účtů */
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.setHomeWidget});
  final Function setHomeWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: const Center(
        child: Text('Tato feature není hotová, ale je v pořadí'),
      ),
    );
  }
}
