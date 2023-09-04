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
    ParsedFoodString jidloString = parseJidlo(jidlo.nazev);
    List<Widget> jidloWidgets = [];
    if(jidloString.polevka != null){
      jidloWidgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: HtmlWidget(
              jidloString.polevka!, textStyle: const TextStyle(
              fontSize: 30,height: 1.5),),
          ),
        ),
      );
    }
    if(jidloString.hlavniJidlo != null){
      jidloWidgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: HtmlWidget(
              jidloString.hlavniJidlo!, textStyle: const TextStyle(
              fontSize: 30,height: 1.5),),
          ),
        ),
      );
    }
    if(jidloString.piti != null){
      jidloWidgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: HtmlWidget(
              jidloString.piti!, textStyle: const TextStyle(
              fontSize: 30,height: 1.5),),
          ),
        ),
      );
    }
    if(jidloString.salatovyBar != null){
      jidloWidgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: HtmlWidget(
              jidloString.salatovyBar!, textStyle: const TextStyle(
              fontSize: 30,height: 1.5),),
          ),
        ),
      );
    }
    if(jidloString.alergeny != null){
      jidloWidgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: HtmlWidget(
              'Alergeny: ${jidloString.alergeny!}', textStyle: const TextStyle(
              fontSize: 30,height: 1.5),),
          ),
        ),
      );
    }
    jidloWidgets.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: ObjednatJidloTlacitko(widget: widget, index: indexDne, jidlaListener: widget.jidlaListener),
      )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(jidlo.varianta),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: jidloWidgets,
          ),
        ),
      ),
    );
  }
}