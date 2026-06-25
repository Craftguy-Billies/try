class VerbConjugation {
  final String infinitive;
  final String meaning;
  final String group; // 'er', 'ir', 're', 'irregular'
  final Map<String, Map<String, String>> conjugations; // tense -> pronoun -> form

  const VerbConjugation({
    required this.infinitive,
    required this.meaning,
    required this.group,
    required this.conjugations,
  });

  static const pronouns = ['je', 'tu', 'il/elle/on', 'nous', 'vous', 'ils/elles'];
  static const tenses = ['Présent', 'Imparfait', 'Futur Simple', 'Passé Composé'];

  String conjugated(String pronoun, String tense) {
    return conjugations[tense]?[pronoun] ?? '—';
  }

  String get presentJe => conjugations['Présent']?['je'] ?? '—';
  String get presentTu => conjugations['Présent']?['tu'] ?? '—';
  String get presentIl => conjugations['Présent']?['il/elle/on'] ?? '—';
  String get presentNous => conjugations['Présent']?['nous'] ?? '—';
  String get presentVous => conjugations['Présent']?['vous'] ?? '—';
  String get presentIls => conjugations['Présent']?['ils/elles'] ?? '—';
}

class GrammarLesson {
  final String id;
  final String title;
  final String category;
  final String content;
  final List<String> examples;
  final String? tip;

  const GrammarLesson({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    this.examples = const [],
    this.tip,
  });
}
