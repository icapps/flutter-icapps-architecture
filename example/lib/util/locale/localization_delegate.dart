import 'dart:async';

import 'package:flutter/material.dart';
import 'package:example/util/locale/localization.dart';

//============================================================//
//THIS FILE IS AUTO GENERATED. DO NOT EDIT//
//============================================================//

typedef LocaleFilter = bool Function(String languageCode);

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  static LocaleFilter? localeFilter;
  static const defaultLocale = Locale('en');
  static const _supportedLanguages = [
    'en',
  ];

  static const _supportedLocales = [
    Locale('en'),
  ];

  static List<String> get supportedLanguages {
    if (localeFilter == null) return _supportedLanguages;
    return _supportedLanguages
        .where((element) => localeFilter?.call(element) ?? true)
        .toList();
  }

  static List<Locale> get supportedLocales {
    if (localeFilter == null) return _supportedLocales;
    return _supportedLocales
        .where((element) => localeFilter?.call(element.languageCode) ?? true)
        .toList();
  }

  Locale? newLocale;
  Locale? activeLocale;
  bool showLocalizationKeys;

  LocalizationDelegate({this.newLocale, this.showLocalizationKeys = false}) {
    if (newLocale != null) {
      activeLocale = newLocale;
    }
  }

  @override
  bool isSupported(Locale locale) =>
      supportedLanguages.contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) async {
    final newActiveLocale = newLocale ?? locale;
    activeLocale = newActiveLocale;
    return Localization.load(newActiveLocale,
        showLocalizationKeys: showLocalizationKeys);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => true;
}
