import 'dart:convert';

import 'package:example/util/locale/localization_keys.dart';
import 'package:example/util/locale/localization_overrides.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

//============================================================//
//THIS FILE IS AUTO GENERATED. DO NOT EDIT//
//============================================================//

typedef LocaleFilter = bool Function(String languageCode);

class Localization {
  static LocaleFilter? localeFilter;

  static var _localisedValues = <String, dynamic>{};
  static var _localisedOverrideValues = <String, dynamic>{};

  /// The locale is used to get the correct json locale.
  /// It can later be used to check what the locale is that was used to load this Localization instance.
  static Locale? locale;

  static const defaultLocale = Locale.fromSubtags(
      languageCode: 'en', scriptCode: null, countryCode: null);

  static const _supportedLocales = [
    Locale.fromSubtags(languageCode: 'en', scriptCode: null, countryCode: null),
  ];

  static List<String> get supportedLanguages {
    final supportedLanguageTags =
        _supportedLocales.map((e) => e.toLanguageTag()).toList(growable: false);
    if (localeFilter == null) return supportedLanguageTags;
    return supportedLanguageTags
        .where((element) => localeFilter?.call(element) ?? true)
        .toList();
  }

  static List<Locale> get supportedLocales {
    if (localeFilter == null) return _supportedLocales;
    return _supportedLocales
        .where((element) => localeFilter?.call(element.toLanguageTag()) ?? true)
        .toList();
  }

  static Future<void> load({
    Locale? locale,
    LocalizationOverrides? localizationOverrides,
    bool showLocalizationKeys = false,
    bool useCaching = true,
  }) async {
    final currentLocale = locale ?? defaultLocale;
    Localization.locale = currentLocale;
    if (showLocalizationKeys) {
      _localisedValues.clear();
      _localisedOverrideValues.clear();
      return;
    }
    if (localizationOverrides != null) {
      final overrideLocalizations =
          await localizationOverrides.getOverriddenLocalizations(currentLocale);
      _localisedOverrideValues = overrideLocalizations;
    }
    final jsonContent = await rootBundle.loadString(
        'assets/locale/${currentLocale.toLanguageTag()}.json',
        cache: useCaching);
    _localisedValues = json.decode(jsonContent) as Map<String, dynamic>;
  }

  static String _t(String key, {List<dynamic>? args}) {
    try {
      final value =
          (_localisedOverrideValues[key] ?? _localisedValues[key]) as String?;
      if (value == null) return key;
      if (args == null || args.isEmpty) return value;
      var newValue = value;
      // ignore: avoid_annotating_with_dynamic
      args.asMap().forEach((index, dynamic arg) =>
          newValue = _replaceWith(newValue, arg, index + 1));
      return newValue;
    } catch (e) {
      return '⚠$key⚠';
    }
  }

  static String _nonPositionalT(String key, {List<dynamic>? args}) {
    try {
      final value =
          (_localisedOverrideValues[key] ?? _localisedValues[key]) as String?;
      if (value == null) return key;
      if (args == null || args.isEmpty) return value;
      var newValue = value;
      args.asMap().forEach(
            // ignore: avoid_annotating_with_dynamic
            (index, dynamic arg) => newValue = _replaceFirstWith(newValue, arg),
          );
      return newValue;
    } catch (e) {
      return '⚠$key⚠';
    }
  }

  static String _replaceWith(String value, Object? arg, int argIndex) {
    if (arg == null) return value;
    if (arg is String) {
      return value.replaceAll('%$argIndex\$s', arg);
    } else if (arg is num) {
      return value.replaceAll('%$argIndex\$d', '$arg');
    }
    return value;
  }

  static String _replaceFirstWith(String value, Object? arg) {
    if (arg == null) return value;
    if (arg is String) {
      return value.replaceFirst('%s', arg);
    } else if (arg is num) {
      return value.replaceFirst('%d', '$arg');
    }
    return value;
  }

  /// Translations:
  ///
  /// en:  **'Very good translation inc'**
  static String get someTestKey => _t(LocalizationKeys.someTestKey);

  static String getTranslation(String key, {List<dynamic>? args}) =>
      _t(key, args: args ?? <dynamic>[]);

  static String getTranslationNonPositional(String key,
          {List<dynamic>? args}) =>
      _nonPositionalT(key, args: args ?? <dynamic>[]);
}
