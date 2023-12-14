// Purpose: stores constants used throughout the app.

/// Shared Preferences Ids
class Prefs {
  final String theme = 'themeMode';
}

// Strings shown to the user
class Texts {
  final String toastsExit = 'toasts-exit';
}

class Consts {
  Prefs prefs = Prefs();
  Texts texts = Texts();
}

Consts consts = Consts();
