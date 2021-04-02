import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:example/util/locale/localization_keys.dart';

//============================================================//
//THIS FILE IS AUTO GENERATED. DO NOT EDIT//
//============================================================//
class Localization {
  Map<String, dynamic> _localisedValues = <String, dynamic>{};

  static Localization of(BuildContext context) =>
      Localizations.of<Localization>(context, Localization)!;

  static Future<Localization> load(Locale locale,
      {bool showLocalizationKeys = false}) async {
    final localizations = Localization();
    if (showLocalizationKeys) {
      return localizations;
    }
    final jsonContent = await rootBundle
        .loadString('assets/locale/${locale.languageCode}.json');
    localizations._localisedValues =
        json.decode(jsonContent) as Map<String, dynamic>; // ignore: avoid_as
    return localizations;
  }

  String _t(String key, {List<dynamic>? args}) {
    try {
      final value = _localisedValues[key] as String?; // ignore: avoid_as
      if (value == null) return '$key';
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

  String _replaceWith(String value, Object? arg, int argIndex) {
    if (arg == null) return value;
    if (arg is String) {
      return value.replaceAll('%$argIndex\$s', arg);
    } else if (arg is num) {
      return value.replaceAll('%$argIndex\$d', '$arg');
    }
    return value;
  }

  /// Translations:
  ///
  /// en:  **'Very good translation inc'**
  String get someTestKey => _t(LocalizationKeys.someTestKey);

  String getTranslation(String key, {List<dynamic>? args}) =>
      _t(key, args: args ?? <dynamic>[]);
}
