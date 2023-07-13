import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

enum LoginFormErrorField { password, url }

class JidelnicekListener {
  CanteenData canteenData;
  DateTime currentDate;
  JidelnicekListener(this.canteenData, this.currentDate);
}

String ziskatDenZData(int den) {
  switch (den) {
    case 1:
      return 'Pondělí';
    case 2:
      return 'Úterý';
    case 3:
      return 'Středa';
    case 4:
      return 'Čtvrtek';
    case 5:
      return 'Pátek';
    case 6:
      return 'Sobota';
    case 7:
      return 'Neděle';
    default:
      throw Exception('Invalid day');
  }
}

class CanteenData {
  /// login uživatele
  String username;

  /// url kantýny
  String url;

  /// info o uživateli - např kredit,jméno,příjmení...
  Uzivatel uzivatel;

  /// seznam jídelníčků začínající Od Pondělí tohoto týdne
  Map<DateTime, Jidelnicek> jidelnicky;

  /// seznam jídel, které jsou na burze
  List<Burza> jidlaNaBurze;
  CanteenData({
    required this.username,
    required this.url,
    required this.uzivatel,
    required this.jidelnicky,
    required this.jidlaNaBurze,
  });
}

late Canteen canteenInstance;
late CanteenData canteenData;

/// Returns a [Canteen] instance with logged in user.
/// Has to be called before using [canteen].
/// If [hasToBeNew] is true, it will create a new instance of [Canteen] even if there is already one.
/// If [url], [username] or [password] is null, it will try to get it from storage.
/// Can throw errors if login is not successful or when bad connection.
Future<Canteen> initCanteen(
    {bool hasToBeNew = false,
    String? url,
    String? username,
    String? password}) async {
  url ??= await readData('url');
  try {
    if (canteenInstance.prihlasen && !hasToBeNew) {
      return canteenInstance;
    } else {
      canteenInstance = Canteen(url!);
    }
  } catch (e) {
    canteenInstance = Canteen(url!);
  }
  username ??= await getDataFromSecureStorage('username');
  password ??= await getDataFromSecureStorage('password');
  if (username == null || password == null) {
    throw Exception('No password found');
  }

  await canteenInstance.login(username, password);
  //get last monday
  DateTime currentDate = DateTime.now();
  DateTime lastMonday =
      currentDate.subtract(Duration(days: (currentDate.weekday - 1)));
  DateTime lastMondayWithoutTime =
      DateTime(lastMonday.year, lastMonday.month, lastMonday.day);
  Map<DateTime, Jidelnicek> jidelnicky = {
    lastMondayWithoutTime: await ziskatJidelnicekDen(lastMonday)
  };
  canteenData = CanteenData(
    username: username,
    url: url,
    uzivatel: await canteenInstance.ziskejUzivatele(),
    jidlaNaBurze: await canteenInstance.ziskatBurzu(),
    jidelnicky: jidelnicky,
  );

  preIndexLunches(lastMondayWithoutTime, 14).then((_) => {
        preIndexLunches(
                lastMondayWithoutTime.subtract(const Duration(days: 7)), 7)
            .then((_) => {
                  preIndexLunches(
                          lastMondayWithoutTime.add(const Duration(days: 14)),
                          7)
                      .then((_) {
                    preIndexLunches(
                        lastMondayWithoutTime
                            .subtract(const Duration(days: 14)),
                        7);
                  })
                })
      });
  return canteenInstance;
}

Future<Jidelnicek> ziskatJidelnicekDen(DateTime den) async {
  try {
    return await canteenInstance.jidelnicekDen(den: den);
  } catch (e) {
    if (e == 'Uživatel není přihlášen') {
      await initCanteen(hasToBeNew: true);
      await Future.delayed(const Duration(seconds: 1));
      return await ziskatJidelnicekDen(den);
    } else {
      await Future.delayed(const Duration(seconds: 1));
      return await ziskatJidelnicekDen(den);
    }
  }
}

Future<void> preIndexLunches(DateTime start, int howManyDays) async {
  for (int i = 0; i < howManyDays; i++) {
    canteenData.jidelnicky[start.add(Duration(days: i))] =
        await getLunchesForDay(start.add(Duration(days: i)));
  }
}

Future<Jidelnicek> getLunchesForDay(DateTime date) async {
  late Jidelnicek jidelnicek;
  if (canteenData.jidelnicky
      .containsKey(DateTime(date.year, date.month, date.day))) {
    jidelnicek =
        canteenData.jidelnicky[DateTime(date.year, date.month, date.day)]!;
  } else {
    jidelnicek = await ziskatJidelnicekDen(date);
  }
  canteenData.jidelnicky[DateTime(date.year, date.month, date.day)] =
      jidelnicek;
  return jidelnicek;
}

CanteenData getCanteenData() {
  return canteenData;
}

void setCanteenData(CanteenData data) {
  canteenData = data;
}

/// save data to secure storage used for storing username and password
void saveDataToSecureStorage(String key, String value) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: key, value: value);
}

/// get data from secure storage used for storing username and password
Future<String?> getDataFromSecureStorage(String key) async {
  const storage = FlutterSecureStorage();
  String? value = await storage.read(key: key);
  return value;
}

/// save data to shared preferences used for storing url and unsecure data
void saveData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

/// get data from shared preferences used for storing url and unsecure data
Future<String?> readData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

void main() async {
  runApp(const MyApp()); // Create an instance of MyApp and pass it to runApp.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final prefs = snapshot.data as SharedPreferences;
          final isLoggedIn = prefs.getString('loggedIn') == '1';
          if (isLoggedIn) {
            return FutureBuilder(
              future: initCanteen(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  late final Canteen canteen;
                  try {
                    canteen = snapshot.data as Canteen;
                    if (canteen.prihlasen) {
                      return const MainAppScreen();
                    }
                    return const LoginPage();
                  } catch (e) {
                    return const LoginPage();
                  }
                } else {
                  return const LoadingLoginPage(
                      textWidget: Text('logging you in'));
                }
              },
            );
          } else {
            return const LoginPage();
          }
        } else {
          return const LoadingLoginPage(textWidget: null);
        }
      },
    );
  }
}

class LoadingLoginPage extends StatelessWidget {
  const LoadingLoginPage({
    super.key,
    required this.textWidget,
  });
  final Widget? textWidget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Text('Autojídelna'),
        ),
        body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CircularProgressIndicator(),
            Padding(
                padding: const EdgeInsets.all(10),
                child: textWidget ?? const Text('')),
          ]),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //unfocus keyboard when tapping outside of textfield
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 148, 18, 148),
            title: const Text('Autojídelna'),
          ),
          body: const LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  String? passwordErrorText;
  String? urlErrorText;
  void _setErrorText(String text, LoginFormErrorField field) {
    switch (field) {
      case LoginFormErrorField.password:
        setState(() {
          passwordErrorText = text;
          urlErrorText = null;
        });
        break;
      case LoginFormErrorField.url:
        setState(() {
          urlErrorText = text;
          passwordErrorText = null;
        });
        break;
    }
  }

  void setLastUrl() async {
    String? lastUrl = await readData('url');
    if (lastUrl != null) {
      _urlController.text = lastUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    setLastUrl();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
              margin:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
              child: TextFormField(
                autofillHints: const [AutofillHints.username],
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Username';
                  }
                  return null;
                },
              )),
          Container(
              margin:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
              child: TextFormField(
                controller: _passwordController,
                autofillHints: const [AutofillHints.password],
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  errorText: passwordErrorText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
              )),
          Container(
              margin:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
              child: TextFormField(
                controller: _urlController,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Url',
                  border: const OutlineInputBorder(),
                  errorText: urlErrorText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the url of the icanteen server';
                  }
                  return null;
                },
              )),
          LoginSubmitButton(
            formKey: _formKey,
            usernameController: _usernameController,
            passwordController: _passwordController,
            urlController: _urlController,
            errorSetter: _setErrorText,
          ),
        ],
      ),
    );
  }
}

class LoginSubmitButton extends StatefulWidget {
  const LoginSubmitButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
    required TextEditingController urlController,
    required Function(String, LoginFormErrorField) errorSetter,
  })  : _formKey = formKey,
        _usernameController = usernameController,
        _passwordController = passwordController,
        _urlController = urlController,
        _errorSetter = errorSetter;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _usernameController;
  final TextEditingController _passwordController;
  final TextEditingController _urlController;
  final Function(String, LoginFormErrorField)? _errorSetter;

  @override
  State<LoginSubmitButton> createState() => _LoginSubmitButtonState();
}

class _LoginSubmitButtonState extends State<LoginSubmitButton> {
  bool loggingIn = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (widget._formKey.currentState!.validate()) {
          // If the form is valid, save the form fields.
          widget._formKey.currentState!.save();
          setState(() {
            loggingIn = true;
          });
          // Do something with the form fields.
          // Reset the form fields.
          //login code
          String url = widget._urlController.text;
          if (url.contains('http://') || url.contains('https://')) {
            url = url;
          } else {
            url = 'https://$url';
          }
          try {
            await initCanteen(
                    hasToBeNew: true,
                    url: url,
                    username: widget._usernameController.text,
                    password: widget._passwordController.text)
                .then((login) {
              if (login.prihlasen) {
                saveDataToSecureStorage(
                    'username', widget._usernameController.text);
                saveDataToSecureStorage(
                    'password', widget._passwordController.text);
                saveData('url', url);
                saveData('loggedIn', '1');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainAppScreen(),
                    ));
              } else {
                widget._errorSetter!(
                    'Wrong username or password', LoginFormErrorField.password);
              }
            });
          } catch (e) {
            if (e.toString().contains('Failed host lookup: ')) {
              widget._errorSetter!('Invalid url', LoginFormErrorField.url);
            } else {
              widget._errorSetter!(
                  'couln\'t connect to server', LoginFormErrorField.url);
            }
          }
          setState(() {
            loggingIn = false;
          });
        }
      },
      child: Builder(
        builder: (context) {
          return loggingIn
              ? const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 148, 18, 148),
                    strokeWidth: 4.0,
                  ),
                )
              : const Text('Log In');
        },
      ),
    );
  }
}

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Text('Autojídelna Logged In'),
        ),
        body: JidelnicekDenWidget(),
        drawer: const MainAppDrawer(),
      ),
    );
  }
}

class MainAppDrawer extends StatelessWidget {
  const MainAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String username = getCanteenData().username;
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 148, 18, 148),
          title: const Text('Autojídelna'),
        ),
        body: Text('You are logged in as $username'),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            child: const Text('log Out'),
            onPressed: () => {
              saveDataToSecureStorage('username', ''),
              saveDataToSecureStorage('password', ''),
              saveData('loggedIn', '0'),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ))
            },
          ),
        ),
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          saveDataToSecureStorage('username', '');
          saveDataToSecureStorage('password', '');
          saveData('loggedIn', '0');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
        },
        child: const Text('Log out'));
  }
}

class JidelnicekDenWidget extends StatelessWidget {
  //define key
  JidelnicekDenWidget({
    super.key,
  });

  final DateTime currentDate = DateTime.now();
  final ValueNotifier<JidelnicekListener> jidelnicekListener =
      ValueNotifier<JidelnicekListener>(
          JidelnicekListener(getCanteenData(), DateTime.now()));
  final PageController pageviewController = PageController(
      initialPage: DateTime.now().difference(DateTime(2006, 5, 23)).inDays);
  final DateTime minimalDate = DateTime(2006, 5, 23);
  final CanteenData canteenData = getCanteenData();

  void restartCanteen() async {
    final Uzivatel uzivatel = await (await initCanteen()).ziskejUzivatele();
    canteenData.uzivatel = uzivatel;
    setCanteenData(canteenData);
    jidelnicekListener.value =
        JidelnicekListener(canteenData, jidelnicekListener.value.currentDate);
  }

  void changeDate({DateTime? newDate, int? daysChange, int? index}) {
    if (daysChange != null) {
      newDate = currentDate.add(Duration(days: daysChange));
      if (daysChange < 0) {
        preIndexLunches(newDate.subtract(const Duration(days: 7)), 7);
      } else {
        preIndexLunches(newDate, 7);
      }
      jidelnicekListener.value =
          JidelnicekListener(jidelnicekListener.value.canteenData, newDate);
      pageviewController
          .jumpToPage(pageviewController.page!.toInt() + daysChange);
    } else if (index != null) {
      newDate = minimalDate.add(Duration(days: index));
      preIndexLunches(newDate, 7).then((_) =>
          preIndexLunches(newDate!.subtract(const Duration(days: 7)), 7));
      jidelnicekListener.value =
          JidelnicekListener(jidelnicekListener.value.canteenData, newDate);
    } else if (newDate != null) {
      preIndexLunches(newDate, 7).then((_) =>
          preIndexLunches(newDate!.subtract(const Duration(days: 7)), 7));
      jidelnicekListener.value =
          JidelnicekListener(jidelnicekListener.value.canteenData, newDate);
      pageviewController.jumpToPage(newDate.difference(minimalDate).inDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    //bool isWeekend = dayOfWeek == 'Sobota' || dayOfWeek == 'Neděle'; //to be implemented...

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: ValueListenableBuilder(
              valueListenable: jidelnicekListener,
              builder: (ctx, value, child) {
                final DateTime currentDate = value.currentDate;
                CanteenData canteenData = value.canteenData;
                String dayOfWeek = ziskatDenZData(currentDate.weekday);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Obědy'),
                    ElevatedButton(
                      onPressed: () async {
                        var datePicked = await showDatePicker(
                          context: context,
                          helpText: 'Vyberte datum Jídelníčku',
                          initialDate: currentDate,
                          currentDate: DateTime.now(),
                          firstDate: minimalDate,
                          lastDate:
                              currentDate.add(const Duration(days: 365 * 2)),
                        );
                        if (datePicked == null) return;
                        changeDate(newDate: datePicked);
                      },
                      child: Text(
                          "${currentDate.day}. ${currentDate.month}. ${currentDate.year} - $dayOfWeek"),
                    ),
                    Text('kredit: ${canteenData.uzivatel.kredit.round()}Kč'),
                  ],
                );
              })),
      body: PageView.builder(
        controller: pageviewController,
        onPageChanged: (value) {
          changeDate(index: value);
        },
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return JidelnicekWidget(
            minimalDate: minimalDate,
            widget: this,
            index: index,
          );
        },
      ),
    );
  }
}

class JidelnicekWidget extends StatelessWidget {
  const JidelnicekWidget(
      {super.key,
      required this.minimalDate,
      required this.widget,
      required this.index});

  final DateTime minimalDate;
  final JidelnicekDenWidget widget;
  final int index;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: getLunchesForDay(minimalDate.add(Duration(days: index))),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return ListJidel(
                  widget: widget,
                  errorWidget: HtmlWidget(snapshot.error.toString()));
            } else if (snapshot.data == null) {
              return const Center(child: Text('No lunches for this day'));
            }

            Jidelnicek jidelnicek = snapshot.data as Jidelnicek;
            return ListJidel(
              jidelnicek: jidelnicek,
              widget: widget,
            );
          }),
    );
  }
}

class ListJidel extends StatelessWidget {
  final Jidelnicek? jidelnicek;
  final JidelnicekDenWidget widget;
  final Widget? errorWidget;
  const ListJidel({
    this.jidelnicek,
    super.key,
    required this.widget,
    this.errorWidget,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(builder: (_) {
          if (this.jidelnicek == null) {
            return errorWidget!;
          }
          Jidelnicek jidelnicek = this.jidelnicek!;

          if (jidelnicek.jidla.isEmpty) {
            return const Expanded(
                child: Center(child: Text('Žádná Jídla pro tento den')));
          }
          return Expanded(
            child: ListView.builder(
              itemCount: jidelnicek.jidla.length,
              itemBuilder: (context, index) {
                String jidlo = jidelnicek.jidla[index].nazev;
                return ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                          child: ObjednatJidloTlacitko(
                            widget: this,
                            index: index,
                          ),
                        ),
                        Builder(builder: (_) {
                          if (jidlo.contains('<span')) {
                            List<String> listJidel = jidlo.split('<span');
                            String cistyNazevJidla = listJidel[0];
                            listJidel.removeAt(0);
                            String alergeny = '<span${listJidel.join('<span')}';
                            String htmlString =
                                '$cistyNazevJidla<br> alergeny: $alergeny';
                            return HtmlWidget(htmlString);
                          } else if (jidelnicek
                              .jidla[index].alergeny.isNotEmpty) {
                            return HtmlWidget(
                                '$jidlo<br> alergeny: ${jidelnicek.jidla[index].alergeny}');
                          } else {
                            return HtmlWidget(jidlo);
                          }
                        })
                      ]),
                );
              },
            ),
          );
        }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    widget.changeDate(daysChange: -1);
                  },
                  child: const Icon(Icons.arrow_left)),
              ElevatedButton(
                  onPressed: () {
                    widget.changeDate(daysChange: 1);
                  },
                  child: const Icon(Icons.arrow_right)),
            ],
          ),
        ),
      ],
    );
  }
}

class ObjednatJidloTlacitko extends StatefulWidget {
  const ObjednatJidloTlacitko({
    super.key,
    required this.widget,
    required this.index,
  });

  final ListJidel widget;
  final int index;

  @override
  State<ObjednatJidloTlacitko> createState() => _ObjednatJidloTlacitkoState();
}

class _ObjednatJidloTlacitkoState extends State<ObjednatJidloTlacitko> {
  bool snackBarShown = false;
  Color buttonColor = const Color.fromRGBO(17, 201, 11, 1);
  Widget? icon;
  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    final Jidelnicek jidelnicek = widget.widget.jidelnicek!;
    final jidlo = jidelnicek.jidla[index];
    if (jidlo.objednano) {
      buttonColor = const Color.fromRGBO(17, 201, 11, 1);
      if (!jidlo.lzeObjednat) {
        icon = const Icon(
          Icons.block,
          color: Color.fromRGBO(0, 0, 0, 1),
        );
      }
    } else if (jidlo.lzeObjednat) {
      buttonColor = const Color.fromRGBO(173, 165, 52, 1);
    } else {
      //pokud jidlo nelze objednat
      buttonColor = const Color.fromARGB(255, 247, 75, 75);
      icon = const Icon(
        Icons.block,
        color: Color.fromRGBO(0, 0, 0, 1),
      );
    }
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () async {
        setState(() {
          buttonColor = const Color.fromARGB(255, 235, 223, 12);
          icon = const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 148, 18, 148),
              strokeWidth: 2.0,
            ),
          );
        });
        Canteen canteen = await initCanteen();
        if (!jidlo.lzeObjednat) {
          final snackBar = SnackBar(
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    if (jidlo.objednano) {
                      return const Expanded(
                        child: Text('Oběd nelze zrušit'),
                      );
                    } else {
                      return const Expanded(
                        child: Text('Oběd nelze objednat'),
                      );
                    }
                  }),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 40, 40, 40)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Icon(Icons.close),
                  ),
                ]),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          if (context.mounted && snackBarShown == false) {
            snackBarShown = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBar)
                .closed
                .then((SnackBarClosedReason reason) {
              snackBarShown = false;
            });
          }
        }
        try {
          canteenData.jidelnicky[jidelnicek.den]!.jidla[index] =
              await canteen.objednat(jidelnicek.jidla[index]);
          widget.widget.widget.restartCanteen();
        } catch (e) {
          setState(() {
            buttonColor = const Color.fromRGBO(255, 0, 0, 1);
            icon = const Icon(
              Icons.close,
              color: Color.fromRGBO(0, 0, 0, 1),
            );
          });
          return;
        }
        if (jidelnicek.jidla[index].objednano) {
          widget.widget.widget.restartCanteen();
          setState(() {
            buttonColor = const Color.fromRGBO(17, 201, 11, 1);
            icon = const Icon(
              Icons.check,
              color: Color.fromRGBO(0, 0, 0, 1),
            );
          });
        } else {
          setState(() {
            buttonColor = const Color.fromRGBO(255, 0, 0, 1);
            icon = const Icon(
              Icons.close,
              color: Color.fromRGBO(0, 0, 0, 1),
            );
          });
        }
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Builder(builder: (context) {
          if (jidelnicek.jidla[index].objednano) {
            return Text(
                'Objednáno ${jidelnicek.jidla[index].varianta} za ${jidelnicek.jidla[index].cena} Kč');
          }
          if (!widget.widget.jidelnicek!.jidla[widget.index].lzeObjednat) {
            return Text(
                'nelze objednat ${jidelnicek.jidla[index].varianta} za ${jidelnicek.jidla[index].cena} Kč');
          }
          return Text(
              'Objednat ${jidelnicek.jidla[index].varianta} za ${jidelnicek.jidla[index].cena} Kč');
        }),
        icon == null ? const Icon(null) : icon!,
      ]),
    );
  }
}
