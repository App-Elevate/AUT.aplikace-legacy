import 'package:autojidelna/every_import.dart';

class JidloDetail extends StatelessWidget {
  JidloDetail(
  {
    super.key,
    required this.datumJidla,
    required this.indexDne,
  });
  final DateTime datumJidla;
  /// index jídla v jídelníčku dne (0 - první jídlo dne datumJidla)
  final int indexDne;
  final CanteenData canteenData = getCanteenData();

  @override
  Widget build(BuildContext context) {
    Jidlo jidlo = canteenData.jidelnicky[datumJidla]!.jidla[indexDne];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail '),
      ),
      body: const Center(
        child: Text('Detail jídla'),
      ),
    );
  }
}