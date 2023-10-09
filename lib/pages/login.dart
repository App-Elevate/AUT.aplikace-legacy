import 'package:autojidelna/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import './../every_import.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    required this.setHomeWidget,
  });
  final Function setHomeWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 85,
              child: Text(
                'Autojídelna',
                style: TextStyle(fontSize: 60),
              ),
            ),
            LoginForm(
              setHomeWidget: setHomeWidget,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.setHomeWidget}) : super(key: key);
  final Function setHomeWidget;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  late final Function setHomeWidget;
  String? passwordErrorText;
  String? urlErrorText;
  bool showPasswd = true;

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
    setHomeWidget = widget.setHomeWidget;
    setLastUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 34),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                controller: _urlController,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Url stránky icanteen  - např. jidelna.trebesin.cz',
                  border: const OutlineInputBorder(),
                  errorText: urlErrorText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Zadejte prosím url stránky icanteen - např. jidelna.trebesin.cz';
                  }
                  return null;
                },
              ),
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
                    child: TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      obscureText: showPasswd,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Heslo',
                        border: const OutlineInputBorder(),
                        errorText: passwordErrorText,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPasswd = !showPasswd;
                            });
                          },
                          icon: Icon(showPasswd ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Zadejte prosím své heslo';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            LoginSubmitButton(
              formKey: _formKey,
              usernameController: _usernameController,
              passwordController: _passwordController,
              urlController: _urlController,
              errorSetter: _setErrorText,
              setHomeWidget: setHomeWidget,
            ),
            RichText(
              text: TextSpan(
                text: 'Používáním aplikace souhlasíte se zasíláním anonymních dat. ',
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
            ),
          ],
        ),
      ),
    );
  }
}

class LoginSubmitButton extends StatefulWidget {
  const LoginSubmitButton({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.urlController,
    required this.errorSetter,
    required this.setHomeWidget,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController urlController;
  final Function(String, LoginFormErrorField)? errorSetter;
  final Function setHomeWidget;

  @override
  State<LoginSubmitButton> createState() => _LoginSubmitButtonState();
}

class _LoginSubmitButtonState extends State<LoginSubmitButton> {
  bool loggingIn = false;
  late final Function setHomeWidget;
  @override
  void initState() {
    setHomeWidget = widget.setHomeWidget;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 60,
        width: 400,
        child: ElevatedButton(
          onPressed: loggingIn ? null : loginFieldCheck,
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
          child: Builder(
            builder: (context) {
              if (loggingIn) {
                return const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(strokeWidth: 3.5),
                );
              } else {
                return const SizedBox(
                  height: 60,
                  child: Center(
                    child: Text('Přihlásit se'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void loginFieldCheck() async {
    if (widget.formKey.currentState!.validate()) {
      // If the form is valid, save the form fields.
      widget.formKey.currentState!.save();
      setState(() {
        loggingIn = true;
      });
      // Do something with the form fields.
      // Reset the form fields.
      //login code
      String url = widget.urlController.text;
      try {
        Canteen login =
            await initCanteen(hasToBeNew: true, url: url, username: widget.usernameController.text, password: widget.passwordController.text);
        if (login.prihlasen) {
          TextInput.finishAutofillContext();

          LoginData loginData = await getLoginDataFromSecureStorage();
          loginData.currentlyLoggedIn = true;
          loginData.currentlyLoggedInId = loginData.users.length;
          loginData.users.add(LoggedInUser(username: widget.usernameController.text, password: widget.passwordController.text, url: url));
          saveLoginToSecureStorage(loginData);

          saveData('url', widget.urlController.text);
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
            setHomeWidget(LoggingInWidget(setHomeWidget: setHomeWidget));
          } else {
            setHomeWidget(MainAppScreen(setHomeWidget: setHomeWidget));
          }
        } else {
          setState(() {
            loggingIn = false;
          });
          widget.errorSetter!('Špatné heslo nebo uživatelské jméno', LoginFormErrorField.password);
        }
      } catch (e) {
        if (e.toString().contains('bad url')) {
          widget.errorSetter!('Nesprávné url', LoginFormErrorField.url);
        } else if (e.toString().contains('login failed')) {
          widget.errorSetter!('Špatné heslo nebo uživatelské jméno', LoginFormErrorField.password);
        } else {
          //TODO: check internet connection according to device
          widget.errorSetter!('Připojení k serveru selhalo', LoginFormErrorField.url);
        }
        setState(() {
          loggingIn = false;
        });
      }
    }
  }
}
