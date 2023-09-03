import 'package:autojidelna/every_import.dart';

class JidloDetail extends StatelessWidget {
  JidloDetail(
  {
    super.key,
    required this.datumJidla,
    required this.indexDne,
    required this.widget,
  });
  final ListJidel widget;
  final DateTime datumJidla;
  /// index jídla v jídelníčku dne (0 - první jídlo dne datumJidla)
  final int indexDne;
  final CanteenData canteenData = getCanteenData();

  @override
  Widget build(BuildContext context) {

    Jidlo jidlo = canteenData.jidelnicky[datumJidla]!.jidla[indexDne];
    String text = parseJidlo(jidlo.nazev).plnyNazevJidla;
    return Scaffold(
      appBar: AppBar(
        title: Text(jidlo.varianta),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: HtmlWidget(text, textStyle: const TextStyle(fontSize: 30,height: 1.5),),
              ),
              ObjednatJidloTlacitko(widget: widget, index: indexDne, jidlaListener: widget.jidlaListener)
            ],
          ),
        ),
      ),
    );
  }
}