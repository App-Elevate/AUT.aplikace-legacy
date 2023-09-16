import 'package:flutter/foundation.dart';

import './../every_import.dart';

SnackBar snackbarFunction(String snackBarText, BuildContext context) {

  return SnackBar(
    //light or dark theme
    backgroundColor: MediaQuery.of(context).platformBrightness ==
            Brightness.dark
        ? const Color(0xff323232)
        : const Color(0xff323232),
    content: Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
    //light or dark theme
        child: Text(snackBarText, style: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.dark?const Color.fromRGBO(255, 255, 255, 1):const Color(0xFFFFFFFF)),),
      )),
      Builder(builder: (context) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 40, 40, 40)),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          child: const Icon(Icons.close),
        );
      }),
    ]),
  );
}
SnackBar dynamicSnackbarFunction(String snackBarText, BuildContext context, ValueListenable valueListenable) {
  final Color color = MediaQuery.of(context).platformBrightness == Brightness.dark?const Color.fromRGBO(255, 255, 255, 1):const Color(0xFFFFFFFF);
  return SnackBar(
    //light or dark theme
    duration: const Duration(days: 1),
    backgroundColor: MediaQuery.of(context).platformBrightness ==
            Brightness.dark
        ? const Color(0xff323232)
        : const Color(0xff323232),
    content: ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (ctx, value, child) {
        if(value == -1){
          return Text('Aktualizace - Čeká se na oprávnění...', style: TextStyle(color: color),);
        }
        if(value == -2){
          Future.delayed(const Duration(seconds: 4), () {
            if(context.mounted){
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          });
          return Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
          //light or dark theme
              child: Text('Došlo k chybě při stahování... Ověřte připojení a zkuste to znovu', style: TextStyle(color: color),),
            )),
            Flexible(child: Builder(builder: (context) {
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 40, 40, 40)),
                ),
                onPressed: () {
                  networkInstallApk(releaseInfo.downloadUrl!, context);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Text('Zkusit znovu'),
              );
            })),
            Builder(builder: (context) {
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 40, 40, 40)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Icon(Icons.close),
              );
            }),
          ]);
        }
        if(value == 1){
          Future.delayed(const Duration(seconds: 4), () {
            if(context.mounted){
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          });
          return Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
          //light or dark theme
              child: Text('Aktualizace byla stažena, instalování...', style: TextStyle(color: color),),
            )),
            Builder(builder: (context) {
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 40, 40, 40)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Icon(Icons.close),
              );
            }),
          ]);
        }
        return Text('Nová aktualizace se stahuje - ${(value * 100).toInt()}%', style: TextStyle(color: color),);
      }
    ),
  );
}
