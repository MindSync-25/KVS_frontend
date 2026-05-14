import 'package:flutter/material.dart';

extension LocaleX on BuildContext {
  /// Returns true when the active locale is Kannada.
  bool get isKn => Localizations.localeOf(this).languageCode == 'kn';
}
