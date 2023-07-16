import 'package:flutter/material.dart';

SnackBar snackbarFunction(String snackBarText) {
  return SnackBar(
    content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(snackBarText),
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
