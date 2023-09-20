/*zde jsou nastavení:
přeskočit víkendy při browsdání (při mačkání tlačítek)
notifikace:
dnešní jídlo (v kolik hodin zaslat)
dochází kredit
burzaCatcher notifikace
nemáte objednáno na příští týden
autoObjednávky případné zeptání se na objednání
 */

//TODO: skip weekends while browsing
//TODO: Notifications: todays food, credit is low, burzacatcher, didnt order for next week, autoBojednavky,

import './../every_import.dart';

/*zde se budou nacházet nastavení a možnost zakoupit pro a vidět statistiky profilu Icanteen. Zároveň zde bude systém pro měnění účtů */
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.setHomeWidget});
  final Function setHomeWidget;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool collectData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nastavení"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Shromažďování údajů',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    title: const Text(
                      'Zastavit sledování analytických služeb',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Switch.adaptive(
                      value: collectData,
                      onChanged: (value) => setState(() => collectData = value),
                      splashRadius: 0,
                      activeColor: const Color.fromARGB(255, 148, 18, 148),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
