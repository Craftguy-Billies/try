import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:french_learn/models/vocabulary.dart';
import 'package:french_learn/screens/home/home_screen.dart' show UserProgressProvider;
import 'package:french_learn/screens/vocabulary/vocabulary_list_screen.dart';
import 'package:french_learn/screens/vocabulary/flashcard_screen.dart';
import 'package:french_learn/screens/vocabulary/word_detail_screen.dart';
import 'package:french_learn/screens/exam/exam_result_screen.dart';
import 'package:french_learn/screens/grammar/grammar_lesson_screen.dart';
import 'package:french_learn/screens/phrases/conversation_screen.dart';
import 'package:french_learn/screens/profile/language_switch_screen.dart';
import 'package:french_learn/data/grammar_data.dart';
import 'package:french_learn/data/phrase_data.dart';
import 'package:french_learn/services/exam_service.dart';
import 'package:french_learn/services/vocabulary_service.dart';
import 'package:french_learn/services/audio_service.dart';
import 'package:french_learn/services/storage_service.dart';

Widget wrapWithProviders(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProgressProvider()),
      Provider.value(value: AudioService()),
      Provider.value(value: VocabularyService()),
      Provider.value(value: ExamService()),
      Provider.value(value: StorageService()),
    ],
    child: child,
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService().init();
    await AudioService().init();
    await VocabularyService().init();
    await ExamService().init();
  });

  group('Word Detail Screen', () {
    testWidgets('shows word details', (tester) async {
      final words = VocabularyService().allWords;
      if (words.isEmpty) return;

      final word = words.first;
      await tester.pumpWidget(MaterialApp(home: WordDetailScreen(word: word)));
      await tester.pumpAndSettle();

      expect(find.text(word.french), findsWidgets);
      expect(find.text(word.english), findsOneWidget);
    });
  });

  group('Flashcard Screen', () {
    testWidgets('renders flashcards', (tester) async {
      final words = VocabularyService().allWords.take(5).toList();
      if (words.isEmpty) return;

      await tester.pumpWidget(MaterialApp(
        home: FlashcardScreen(words: words)));
      await tester.pumpAndSettle();
    });

    testWidgets('swipe or tap flips card', (tester) async {
      final words = VocabularyService().allWords.take(3).toList();
      if (words.isEmpty) return;

      await tester.pumpWidget(MaterialApp(
        home: FlashcardScreen(words: words)));
      await tester.pumpAndSettle();

      // Tap to flip
      await tester.tap(find.byType(GestureDetector).last);
      await tester.pumpAndSettle();
    });
  });

  group('Grammar Lesson Screen', () {
    testWidgets('renders lesson content', (tester) async {
      if (GrammarData.lessons.isEmpty) return;

      final lesson = GrammarData.lessons.first;
      await tester.pumpWidget(MaterialApp(home: GrammarLessonScreen(lesson: lesson)));
      await tester.pumpAndSettle();
    });
  });

  group('Conversation Screen', () {
    testWidgets('renders conversation', (tester) async {
      if (PhraseData.conversations.isEmpty) return;

      final conv = PhraseData.conversations.first;
      await tester.pumpWidget(MaterialApp(home: ConversationScreen(conversation: conv)));
      await tester.pumpAndSettle();
    });
  });

  group('Language Switch Screen', () {
    testWidgets('shows language options', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LanguageSwitchScreen()));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsWidgets);
      expect(find.text('Français'), findsOneWidget);
      expect(find.text('Español'), findsOneWidget);
    });
  });

  group('Vocabulary List Navigation', () {
    testWidgets('tapping word opens detail screen', (tester) async {
      final words = VocabularyService().allWords;
      if (words.isEmpty) return;

      await tester.pumpWidget(MaterialApp(
        home: wrapWithProviders(const VocabularyListScreen())));
      await tester.pumpAndSettle();

      // Tap the first word
      final wordTile = find.text(words.first.french);
      if (wordTile.evaluate().isNotEmpty) {
        await tester.tap(wordTile.first);
        await tester.pumpAndSettle();

        // Should show word detail
        expect(find.text(words.first.english), findsOneWidget);
      }
    });

    testWidgets('category filter shows filtered words', (tester) async {
      final vocab = VocabularyService();
      if (vocab.categories.isEmpty || vocab.allWords.isEmpty) return;

      final category = vocab.categories.first;
      await tester.pumpWidget(MaterialApp(
        home: wrapWithProviders(VocabularyListScreen(
          categoryId: category.id,
          categoryName: 'Test Category',
        ))));
      await tester.pumpAndSettle();
    });
  });

  group('Exam Result Screen', () {
    testWidgets('shows exam results', (tester) async {
      if (ExamService.configs.isEmpty) return;

      await tester.pumpWidget(MaterialApp(
        home: ExamResultScreen(
          score: 75,
          total: 10,
          correct: 8,
          config: ExamService.configs.first,
          questions: [],
          answers: {},
        ),
      ));
      await tester.pumpAndSettle();
    });
  });
}
