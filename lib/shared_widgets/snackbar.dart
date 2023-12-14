// Snackbar widgets
import 'package:autojidelna/local_imports.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

SnackBar snackbarFunction(String snackBarText) {
  return SnackBar(
    //light or dark theme
    content: Text(snackBarText),
  );
}

SnackBar dynamicSnackbarFunction(String snackBarText, BuildContext context, ValueListenable valueListenable) {
  return SnackBar(
    //light or dark theme
    duration: const Duration(days: 1),
    content: ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (ctx, value, child) {
        if (value == -1) {
          return const Text('Aktualizace - Čeká se na oprávnění');
        }
        if (value == -2) {
          Future.delayed(const Duration(seconds: 4), () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          });
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  //light or dark theme
                  child: Text('Došlo k chybě při stahování. Ověřte připojení a zkuste to znovu'),
                ),
              ),
              Flexible(
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      networkInstallApk(releaseInfo!.downloadUrl!, context);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text('Zkusit znovu'),
                  );
                }),
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Icon(Icons.close),
                  );
                },
              ),
            ],
          );
        }
        if (value == 1) {
          Future.delayed(
            const Duration(seconds: 4),
            () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }
            },
          );
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  //light or dark theme
                  child: Text('Aktualizace byla stažena, instalování'),
                ),
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Icon(Icons.close),
                  );
                },
              ),
            ],
          );
        }
        return Text('Nová aktualizace se stahuje - ${(value * 100).toInt()}%');
      },
    ),
  );
}
