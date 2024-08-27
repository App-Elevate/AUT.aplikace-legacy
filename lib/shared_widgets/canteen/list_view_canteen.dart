import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/datetime_wrapper.dart';
import 'package:autojidelna/shared_widgets/canteen/day_card.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';

class ListViewCanteen extends StatelessWidget {
  const ListViewCanteen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Jidelnicek>(
      future: loggedInCanteen.getLunchesForDay(convertIndexToDatetime(6678)),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('data');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        Jidelnicek jidelnicek = snapshot.data as Jidelnicek;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) => DayCard(jidelnicek: jidelnicek),
        );
      },
    );
  }
}
