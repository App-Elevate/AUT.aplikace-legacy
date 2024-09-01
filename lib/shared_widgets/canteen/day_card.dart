import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/methods_vars/canteenwrapper.dart';
import 'package:autojidelna/methods_vars/datetime_wrapper.dart';
import 'package:autojidelna/methods_vars/string_extention.dart';
import 'package:autojidelna/methods_vars/get_correct_date_string.dart';
import 'package:autojidelna/providers.dart';
import 'package:autojidelna/shared_widgets/canteen/error_loading_data.dart';
import 'package:autojidelna/shared_widgets/canteen/food_section_list_tile.dart';
import 'package:autojidelna/shared_widgets/settings/custom_divider.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayCard extends StatefulWidget {
  const DayCard(this.dayIndex, {super.key});
  final int dayIndex;

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  Future<Jidelnicek>? _futureMenu;

  @override
  void initState() {
    super.initState();
    // Fetch the data in initState to avoid context issues
    _futureMenu = loggedInCanteen.getLunchesForDay(convertIndexToDatetime(widget.dayIndex));
    _futureMenu!.then((menu) {
      if (mounted) context.read<DishesOfTheDay>().setMenu(widget.dayIndex, menu);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Jidelnicek>(
      future: _futureMenu,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const ErrorLoadingData();
        if (snapshot.connectionState == ConnectionState.done) return _DayCard(widget.dayIndex);

        return SizedBox(
          height: MediaQuery.sizeOf(context).height * .4,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard(this.dayIndex);
  final int dayIndex;
  @override
  Widget build(BuildContext context) {
    return Consumer<DishesOfTheDay>(
      builder: (context, data, ___) {
        Jidelnicek? menu = data.getMenu(dayIndex);
        if (menu == null) return const Center(child: CircularProgressIndicator());

        Map<String, List<Jidlo>> sortedDishes = mapDishesByVarianta(menu.jidla);
        return Card.outlined(
          elevation: 0.6,
          color: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).dividerTheme.color!)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              DayCardheader(date: menu.den),
              if (menu.jidla.isNotEmpty) ...[const CustomDivider(isTransparent: false, height: 0), const SizedBox(height: 8)],
              ...sortedDishes.entries.map((e) => FoodSectionListTile(title: e.key.toUpperCase(), selection: e.value)),
            ],
          ),
        );
      },
    );
  }
}

// Using regular expression to remove digits and extra spaces ['OBĚD 1' => 'OBĚD']
String normalizeVarianta(String varianta) => varianta.replaceAll(RegExp(r'\d'), '').trim();

// Group dishes by normalized `varianta`
Map<String, List<Jidlo>> mapDishesByVarianta(List<Jidlo> dishes) {
  Map<String, List<Jidlo>> mappedDishes = {};

  for (Jidlo dish in dishes) {
    String normalizedVarianta = normalizeVarianta(dish.varianta);

    if (mappedDishes.containsKey(normalizedVarianta)) {
      mappedDishes[normalizedVarianta]!.add(dish);
    } else {
      mappedDishes[normalizedVarianta] = [dish];
    }
  }

  return mappedDishes;
}

class DayCardheader extends StatelessWidget {
  const DayCardheader({required this.date, super.key});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Selector<Settings, DateFormatOptions>(
        selector: (p0, p1) => p1.dateFormat,
        builder: (context, format, ___) {
          String day = DateFormat('EEEE', Localizations.localeOf(context).toLanguageTag()).format(date).capitalize();
          return Text(
            '$day - ${getCorrectDateString(format, date: date)}',
            style: Theme.of(context).textTheme.titleMedium,
          );
        },
      ),
    );
  }
}
