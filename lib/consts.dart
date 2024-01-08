// Purpose: stores constants used throughout the app.

/// Shared Preferences Ids
class Prefs {
  final String themeMode = 'themeMode';
  final String themeStyle = 'themeStyle';
}

class Texts {
  final String appName = 'Autojídelna';
}

class Consts {
  Prefs prefs = Prefs();
  Texts texts = Texts();
}

Consts consts = Consts();
