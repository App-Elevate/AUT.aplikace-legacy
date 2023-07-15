import 'package:flutter/material.dart';

import '../methods/icanteen.dart';
import './all.dart';

enum LoginFormErrorField { password, url }

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
          title: const Text('Přihlášení'),
        ),
        body: LoginForm(
          setHomeWidget: setHomeWidget,
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
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              //cool title
              child: Text('Autojídelna',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  )),
            ),
            Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 2, right: 2),
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
                )),
            Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 2, right: 2),
                child: TextFormField(
                  controller: _passwordController,
                  autofillHints: const [AutofillHints.password],
                  obscureText: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Heslo',
                    border: const OutlineInputBorder(),
                    errorText: passwordErrorText,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Zadejte prosím své heslo';
                    }
                    return null;
                  },
                )),
            Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 2, right: 2),
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
                      return 'zadejte prosím url stránky icanteen';
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
              setHomeWidget: setHomeWidget,
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
    return ElevatedButton(
      onPressed: () async {
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
            await initCanteen(
                    hasToBeNew: true,
                    url: url,
                    username: widget.usernameController.text,
                    password: widget.passwordController.text)
                .then((login) {
              if (login.prihlasen) {
                saveDataToSecureStorage(
                    'username', widget.usernameController.text);
                saveDataToSecureStorage(
                    'password', widget.passwordController.text);
                saveData('url', url);
                saveData('loggedIn', '1');
                setHomeWidget(MainAppScreen(setHomeWidget: setHomeWidget));
              } else {
                widget.errorSetter!('Špatné heslo nebo uživatelské jméno',
                    LoginFormErrorField.password);
              }
            });
          } catch (e) {
            if (e.toString().contains('Failed host lookup: ')) {
              widget.errorSetter!('Nesprávné url', LoginFormErrorField.url);
            } else if (e.toString().contains('Login failed')) {
              widget.errorSetter!('Špatné heslo nebo uživatelské jméno',
                  LoginFormErrorField.password);
            } else {
              widget.errorSetter!(
                  'Připojení k serveru selhalo', LoginFormErrorField.url);
            }
          }
          setState(() {
            loggingIn = false;
          });
        }
      },
      child: Builder(
        builder: (context) {
          if (loggingIn) {
            return SizedBox(
              width: 45,
              height: 45,
              child: Container(
                margin: const EdgeInsets.all(7.0),
                child: const CircularProgressIndicator(
                  color: Color.fromARGB(255, 11, 194, 11),
                  strokeWidth: 3.5,
                ),
              ),
            );
          } else {
            return const SizedBox(
              width: 100,
              height: 45,
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
    );
  }
}
