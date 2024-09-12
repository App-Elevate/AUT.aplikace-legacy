// Purpose: Login screen for the app

import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/pages_new/navigation.dart';
import 'package:autojidelna/pages_new/settings/data_collection.dart';
import 'package:autojidelna/shared_prefs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:autojidelna/local_imports.dart';

class LoginScreenV2 extends StatelessWidget {
  LoginScreenV2({super.key});
  // Static is fix for keyboard disapearing when this screen is pushed (problem with rebuilding the widget)
  static final _formKey = GlobalKey<FormState>();
  // Without static the text in the textfields would be deleted for the same reasons.
  static final _usernameController = TextEditingController();
  static final _passwordController = TextEditingController();
  static final _urlController = TextEditingController();

  /// First value is error text, second is if it the password is visible
  final ValueNotifier<List<dynamic>> passwordNotifier = ValueNotifier([null, false]);
  final ValueNotifier<String?> urlErrorText = ValueNotifier(null);
  final ValueNotifier<bool> loggingIn = ValueNotifier(false);

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).appBarTheme.iconTheme?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height - MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(top: AppBar().preferredSize.height),
                child: Text(
                  lang.appName,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              loginForm(context),
            ],
          ),
        ),
      ),
    );
  }

  void _setErrorText(String text, LoginFormErrorField? field) {
    switch (field) {
      case LoginFormErrorField.password:
        passwordNotifier.value = [text, passwordNotifier.value[1]];
        urlErrorText.value = null;
        break;
      case LoginFormErrorField.url:
        urlErrorText.value = text;
        passwordNotifier.value = [null, passwordNotifier.value[1]];
        break;
      default:
        urlErrorText.value = null;
        passwordNotifier.value = [null, passwordNotifier.value[1]];
    }
  }

  void setLastUrl() async {
    _urlController.text = await readStringFromSharedPreferences(Prefs.url) ?? "";
  }

  Form loginForm(context) {
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
                        labelText: lang.loginUrlFieldLabel,
                        errorText: value,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return lang.loginUrlFieldHint;
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
                      decoration: InputDecoration(labelText: lang.loginUserFieldLabel),
                      validator: (value) {
                        if (value == null || value.isEmpty) return lang.loginUserFieldHint;
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
                            labelText: lang.loginPasswordFieldLabel,
                            errorText: value[0],
                            suffixIcon: IconButton(
                              onPressed: () => passwordNotifier.value = [passwordNotifier.value[0], !passwordNotifier.value[1]],
                              icon: Icon(value[1] ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return lang.loginPasswordFieldHint;
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            loginSubmitButton(context),
            RichText(
              text: TextSpan(
                text: lang.dataCollectionAgreement,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                children: [
                  TextSpan(
                    text: lang.moreInfo,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const DataCollectionScreen()),
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

  Container loginSubmitButton(context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 60,
      width: 400,
      child: ValueListenableBuilder(
        valueListenable: loggingIn,
        builder: (context, value, child) {
          return ElevatedButton(
            onPressed: value ? null : () => loginFieldCheck(context),
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            child: value ? CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary) : Text(lang.loginButton),
          );
        },
      ),
    );
  }

  void loginFieldCheck(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, save the form fields.
      _formKey.currentState!.save();
      _setErrorText('', null);
      loggingIn.value = true;
      String url = _urlController.text;
      try {
        await loggedInCanteen.addAccount(_urlController.text, _usernameController.text, _passwordController.text);
        saveStringToSharedPreferences(Prefs.url, url);
        try {
          changeDate(newDate: DateTime.now());
          MyApp.navigatorKey.currentState!.popUntil((route) => route.isFirst);
        } catch (e) {
          //if it is not connected we don't have to do anything
        }
        MyApp.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const NavigationScreen()), (route) => false);
      } catch (e) {
        switch (e) {
          case ConnectionErrors.noInternet:
            _setErrorText(lang.errorsNoInternet, LoginFormErrorField.url);
            break;
          case ConnectionErrors.wrongUrl:
            _setErrorText(lang.errorsBadUrl, LoginFormErrorField.url);
            break;
          case ConnectionErrors.badLogin:
            _setErrorText(lang.errorsBadLogin, LoginFormErrorField.password);
            break;
          default:
            _setErrorText(lang.errorsBadConnection, LoginFormErrorField.url);
            break;
        }
      }
      loggingIn.value = false;
      loginScreenVisible = false;
    }
  }
}
