
class Phrase {
  final String id;
  final String french;
  final String english;
  final String? pronunciation;
  final String category;
  final String? context;
  final String? formality; // formal, informal, neutral

  const Phrase({
    required this.id, required this.french, required this.english,
    this.pronunciation, required this.category, this.context, this.formality,
  });
}

class Conversation {
  final String id;
  final String titleEn;
  final String titleFr;
  final String scenarioEn;
  final String scenarioFr;
  final List<ConversationLine> lines;

  const Conversation({
    required this.id, required this.titleEn, required this.titleFr,
    required this.scenarioEn, required this.scenarioFr, required this.lines,
  });
}

class ConversationLine {
  final String speaker;
  final String french;
  final String english;
  final String? note;

  const ConversationLine({
    required this.speaker, required this.french, required this.english, this.note,
  });
}
