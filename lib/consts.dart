// Purpose: stores constants used throughout the app.

/// Shared Preferences Ids
class Prefs {
  final String theme = 'themeMode';
}

// Strings shown to the user
class Texts {
  final String toastsExit = 'toasts-exit';

  final String errorsBadLogin = 'errors-bad-login';
  final String errorsBadUrl = 'errors-bad-url';
  final String errorsBadConnection = 'errors-bad-connection';
  final String errorsNoInternet = 'errors-no-internet';

  final String loggingIn = 'logging-in';
}

class Consts {
  Prefs prefs = Prefs();
  Texts texts = Texts();
}

Consts consts = Consts();
