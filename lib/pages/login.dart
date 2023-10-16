import 'package:autojidelna/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import './../every_import.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
    required this.setHomeWidget,
  });
  final Function(Widget widget) setHomeWidget;
  //static is fix for keyboard disapearing when this screen is pushed (problem with rebuilding the widget)
  static final _formKey = GlobalKey<FormState>();
  //without static the text in the textfields would be deleted for the same reasons.
  static final _usernameController = TextEditingController();
  static final _passwordController = TextEditingController();
  static final _urlController = TextEditingController();
  // first value is error text, second is if it the password is visible
  final ValueNotifier<List<dynamic>> passwordNotifier = ValueNotifier([null, false]);
  final ValueNotifier<String?> urlErrorText = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    if (!loginScreenVisible) {
      setLastUrl();
      _usernameController.text = '';
      _passwordController.text = '';
      loginScreenVisible = true;
    }
    return formScaffold(context);
  }

  Scaffold formScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onBackground),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topCenter,
            height: 85,
            child: const Text(
              'Autojídelna',
              style: TextStyle(fontSize: 60),
            ),
          ),
          loginForm(),
        ],
      ),
    );
  }

  void _setErrorText(String text, LoginFormErrorField field) {
    switch (field) {
      case LoginFormErrorField.password:
        passwordNotifier.value = [text, passwordNotifier.value[1]];
        urlErrorText.value = null;
        break;
      case LoginFormErrorField.url:
        urlErrorText.value = text;
        passwordNotifier.value = [null, passwordNotifier.value[1]];
        break;
    }
  }

  void setLastUrl() async {
    String? lastUrl = await readData('url');
    if (lastUrl != null) {
      _urlController.text = lastUrl;
    }
  }

  Form loginForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 34),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ValueListenableBuilder(
                  valueListenable: urlErrorText,
                  builder: (ctx, value, child) {
                    return TextFormField(
                      controller: _urlController,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Url stránky icanteen  - např. jidelna.trebesin.cz',
                        border: const OutlineInputBorder(),
                        errorText: value,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Zadejte prosím url stránky icanteen - např. jidelna.trebesin.cz';
                        }
                        return null;
                      },
                    );
                  }),
            ),
            AutofillGroup(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      autofillHints: const [AutofillHints.username],
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Uživatelské jméno',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Zadejte prosím své uživatelské jméno';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ValueListenableBuilder(
                        valueListenable: passwordNotifier,
                        builder: (context, value, child) {
                          return TextFormField(
                            controller: _passwordController,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            obscureText: value[1] ? false : true,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'Heslo',
                              border: const OutlineInputBorder(),
                              errorText: value[0],
                              suffixIcon: IconButton(
                                onPressed: () {
                                  passwordNotifier.value = [passwordNotifier.value[0], !passwordNotifier.value[1]];
                                },
                                icon: Icon(value[1] ? Icons.visibility_off : Icons.visibility),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Zadejte prosím své heslo';
                              }
                              return null;
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
            loginSubmitButton(),
            Builder(builder: (context) {
              return RichText(
                text: TextSpan(
                  text: 'Používáním aplikace souhlasíte se zasíláním anonymních dat. ',
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  children: [
                    TextSpan(
                      text: 'Více informací',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AnalyticSettingsPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  final ValueNotifier<bool> loggingIn = ValueNotifier(false);
  Builder loginSubmitButton() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 60,
          width: 400,
          child: ElevatedButton(
            onPressed: loggingIn.value ? null : () => loginFieldCheck(context),
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            child: ValueListenableBuilder(
              valueListenable: loggingIn,
              builder: (context, value, child) {
                if (value) {
                  return SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Přihlásit se',
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    });
  }

  void loginFieldCheck(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, save the form fields.
      _formKey.currentState!.save();
      loggingIn.value = true;
      String url = _urlController.text;
      try {
        Canteen login = await initCanteen(hasToBeNew: true, url: url, username: _usernameController.text, password: _passwordController.text);
        if (login.prihlasen) {
          TextInput.finishAutofillContext();

          LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
          loginData.currentlyLoggedIn = true;
          loginData.currentlyLoggedInId = loginData.users.length;
          loginData.users.add(LoggedInUser(username: _usernameController.text, password: _passwordController.text, url: url));
          try {
            canteenData = null;
            canteenInstance = null;
            changeDate(newDate: DateTime.now());
          } catch (e) {
            //this needs to be done only if we are loggin in the second time
          }
          saveLoginToSecureStorage(loginData);

          saveData('url', _urlController.text);
          if (context.mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
            setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
          } else {
            setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
          }
        } else {
          _setErrorText('Špatné heslo nebo uživatelské jméno', LoginFormErrorField.password);
        }
      } catch (e) {
        bool connected = await InternetConnectionChecker().hasConnection;
        if (!connected) {
          _setErrorText('Nejste připojeni k internetu', LoginFormErrorField.url);
        } else if (e.toString().contains('bad url')) {
          _setErrorText('Nesprávné url', LoginFormErrorField.url);
        } else if (e.toString().contains('login failed')) {
          _setErrorText('Špatné heslo nebo uživatelské jméno', LoginFormErrorField.password);
        } else {
          _setErrorText('Připojení k serveru selhalo.', LoginFormErrorField.url);
        }
      }
    }
    loggingIn.value = false;
    loginScreenVisible = false;
  }
}
