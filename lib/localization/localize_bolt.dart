import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class LocalizedBolt {
  late final Locale locale;
  LocalizedBolt(this.locale);
  static LocalizedBolt? of(BuildContext context) {
    return Localizations.of<LocalizedBolt>(context, LocalizedBolt);
  }
  Map<String, String>? _localizedValues;
  Future load() async {
    String jsonStringValues = await rootBundle.loadString('lib/lang/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }
  String? getTranslatedValue(String key) {
    return _localizedValues![key];
  }
  static const LocalizationsDelegate<LocalizedBolt> delegate = _BoltLocalizationDeligate();
}

class _BoltLocalizationDeligate extends LocalizationsDelegate<LocalizedBolt> {
  const _BoltLocalizationDeligate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'de'].contains(locale.languageCode);
  }

  @override
  Future<LocalizedBolt> load(Locale locale) async {
    LocalizedBolt localization = new LocalizedBolt(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_BoltLocalizationDeligate old) => false;
  //
}