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
