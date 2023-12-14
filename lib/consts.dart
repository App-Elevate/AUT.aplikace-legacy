// Purpose: stores constants used throughout the app.

/// Shared Preferences Ids
class Prefs {
  final String theme = 'themeMode';
}

class Nums {
  final int switchAccountPanelDuration = 300;
}

// Strings shown to the user
class Texts {
  final String toastsExit = 'toasts-exit';

  final String errorsBadLogin = 'errors-bad-login';
  final String errorsBadUrl = 'errors-bad-url';
  final String errorsBadConnection = 'errors-bad-connection';
  final String errorsNoInternet = 'errors-no-internet';

  final String accPanelAddAccount = 'switch-account-panel-add-account';
  final String accPanelTitle = 'switch-account-panel-title';
}

class Consts {
  Prefs prefs = Prefs();
  Texts texts = Texts();
  Nums nums = Nums();
}

Consts consts = Consts();
