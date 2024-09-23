import 'package:autojidelna/lang/output/texts.dart';
import 'package:flutter/material.dart';

Texts get lang => _lang!; // helper function to avoid typing '!' all the time
Texts? _lang; // global variable

class AppTranslations {
  static init(BuildContext context) {
    _lang = Texts.of(context);
  }
}

extension AppLocalizationsX on BuildContext {
  Texts get l10n => Texts.of(this);
}
