class Language {
  late final int id;
  late final String name;
  late final String flag;
  late final String languageCode;

  Language({required this.name, required this.id, required this.flag, required this.languageCode});

  static List<Language> languageList() {
    return <Language> [
      Language(name: 'English', id: 1, flag: 'πΊπΈ', languageCode: 'en'),
      Language(name: 'German', id: 2, flag: 'π©πͺ', languageCode: 'de'),
    ];
  }
}