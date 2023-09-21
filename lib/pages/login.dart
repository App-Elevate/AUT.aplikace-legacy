import 'package:flutter/gestures.dart';

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
        appBar: AppBar(
          //backgroundColor of the rest of the app:
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //remove shadow
          elevation: 0,
          //title color
          foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 50.0),
                height: 60,
                //cool title
                child: const Text(
                  'Autojídelna',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              LoginForm(
                setHomeWidget: setHomeWidget,
              ),
            ],
          ),
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
                autofillHints: const [AutofillHints.password],
                obscureText: showPasswd,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Heslo',
                  border: const OutlineInputBorder(),
                  errorText: passwordErrorText,
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.only(right: 10),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        showPasswd = !showPasswd;
                      });
                    },
                    icon: Icon(
                      showPasswd ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xff7F7F7F),
                    ),
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
                style: const TextStyle(
                  fontSize: 12
                ),
                children: [
                  TextSpan(
                    text: 'Více informací',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnalyticSettingsPage()));
                      },
                  ),
                ],
              )
            )
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
          onPressed: loginFieldCheck,
          child: Builder(
            builder: (context) {
              if (loggingIn) {
                return SizedBox(
                  height: 50,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 140, vertical: 10),
                    width: 50,
                    height: 50,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3.5,
                    ),
                  ),
                );
              } else {
                return const SizedBox(
                  height: 60,
                  child: Center(
                      child: Text(
                    'Přihlásit se',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
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
      if (url.contains('http://') || url.contains('https://')) {
        url = url;
      } else {
        url = 'https://$url';
      }
      try {
        await initCanteen(hasToBeNew: true, url: url, username: widget.usernameController.text, password: widget.passwordController.text)
            .then((login) {
          if (login.prihlasen) {
            saveDataToSecureStorage('username', widget.usernameController.text);
            saveDataToSecureStorage('password', widget.passwordController.text);
            saveData('url', url);
            saveData('loggedIn', '1');
            setHomeWidget(MainAppScreen(setHomeWidget: setHomeWidget));
          } else {
            setState(() {
              loggingIn = false;
            });
            widget.errorSetter!('Špatné heslo nebo uživatelské jméno', LoginFormErrorField.password);
          }
        });
      } catch (e) {
        if (e.toString().contains('bad url')) {
          widget.errorSetter!('Nesprávné url', LoginFormErrorField.url);
        } else if (e.toString().contains('login failed')) {
          widget.errorSetter!('Špatné heslo nebo uživatelské jméno', LoginFormErrorField.password);
        } else {
          widget.errorSetter!('Připojení k serveru selhalo', LoginFormErrorField.url);
        }
        setState(() {
          loggingIn = false;
        });
      }
    }
  }
}
