import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:french_app/data/french_vocab.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/models/exam_result.dart';
import 'package:french_app/models/vocab_item.dart';
import 'package:french_app/providers/locale_provider.dart';
import 'package:french_app/providers/theme_provider.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:french_app/screens/exam/exam_home_screen.dart';
import 'package:french_app/screens/exam/exam_result_screen.dart';
import 'package:french_app/screens/exam/exam_screen.dart';
import 'package:french_app/screens/home/home_screen.dart';
import 'package:french_app/screens/learn/flashcard_screen.dart';
import 'package:french_app/screens/learn/learn_screen.dart';
import 'package:french_app/screens/learn/vocab_list_screen.dart';
import 'package:french_app/screens/onboarding/onboarding_screen.dart';
import 'package:french_app/screens/profile/profile_screen.dart';
import 'package:french_app/screens/profile/settings_screen.dart';
import 'package:french_app/screens/splash/splash_screen.dart';

List<Map<String, dynamic>> generateExamQuestions(String level, int count) {
  final vocab = getVocabByLevel(level);
  final rng = Random(42);
  final shuffled = List<VocabItem>.from(vocab)..shuffle(rng);
  final selected = shuffled.take(count).toList();
  final allEnglish = vocab.map((v) => v.english).toList();

  final questions = <Map<String, dynamic>>[];
  for (int i = 0; i < selected.length; i++) {
    final item = selected[i];
    final wrongPool = allEnglish.where((e) => e != item.english).toList();
    final wrongOptions = (wrongPool..shuffle(rng)).take(3).toList();
    while (wrongOptions.length < 3) { wrongOptions.add('---'); }
    final options = [...wrongOptions, item.english]..shuffle(rng);

    questions.add({
      'id': item.id,
      'question': item.french,
      'options': options,
      'correctAnswer': item.english,
      'type': 'vocabulary',
    });
  }
  return questions;
}

Widget wrapApp(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => ProgressProvider()),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('fr')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('SplashScreen', () {
    testWidgets('renders app name and tagline', (tester) async {
      await tester.pumpWidget(wrapApp(const SplashScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('FrenchLearn'), findsOneWidget);
      expect(find.text('Master French. Ace the DELF.'), findsOneWidget);

      // Drain the pending timer to avoid teardown failures
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('shows French flag and progress indicator', (tester) async {
      await tester.pumpWidget(wrapApp(const SplashScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('🇫🇷'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('navigates to onboarding on first launch', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(wrapApp(const SplashScreen()));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('navigates to home when onboarding done', (tester) async {
      SharedPreferences.setMockInitialValues({'onboarding_completed': true});

      await tester.pumpWidget(wrapApp(const SplashScreen()));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('Bonjour!'), findsOneWidget);
    });
  });

  group('OnboardingScreen', () {
    testWidgets('renders first page with buttons', (tester) async {
      await tester.pumpWidget(wrapApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('swipe advances page', (tester) async {
      await tester.pumpWidget(wrapApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('navigates through all pages to final button', (tester) async {
      await tester.pumpWidget(wrapApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      // Progress through pages
      for (int i = 0; i < 2; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Page 3 should show Get Started button
      expect(find.text('Get Started'), findsOneWidget);
    });
  });

  group('HomeScreen', () {
    testWidgets('renders greeting', (tester) async {
      await tester.pumpWidget(wrapApp(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Bonjour!'), findsOneWidget);
    });

    testWidgets('has streak and progress indicators', (tester) async {
      await tester.pumpWidget(wrapApp(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Bonjour!'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });
  });

  group('LearnScreen', () {
    testWidgets('renders DELF levels', (tester) async {
      await tester.pumpWidget(wrapApp(const LearnScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(InkWell), findsWidgets);
    });
  });

  group('VocabListScreen', () {
    testWidgets('renders with filter chips', (tester) async {
      final words = getVocabByLevel('A1');
      if (words.isEmpty) return;

      await tester.pumpWidget(wrapApp(VocabListScreen(level: 'A1')));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Mastered'), findsOneWidget);
    });

    testWidgets('search bar exists', (tester) async {
      final words = getVocabByLevel('A1');
      if (words.isEmpty) return;

      await tester.pumpWidget(wrapApp(VocabListScreen(level: 'A1')));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('FlashcardScreen', () {
    testWidgets('renders card with navigation buttons', (tester) async {
      final words = getAllVocab().take(5).toList();
      if (words.isEmpty) return;

      await tester.pumpWidget(wrapApp(FlashcardScreen(words: words)));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(IconButton), findsWidgets);
    });
  });

  group('ExamHomeScreen', () {
    testWidgets('renders exam type selection', (tester) async {
      await tester.pumpWidget(wrapApp(const ExamHomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Exam Type'), findsOneWidget);
    });

    testWidgets('has level selection widgets', (tester) async {
      await tester.pumpWidget(wrapApp(const ExamHomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('ExamScreen', () {
    testWidgets('renders exam header', (tester) async {
      final vocab = getVocabByLevel('A1');
      if (vocab.length < 5) return;

      final questions = generateExamQuestions('A1', 5);

      await tester.pumpWidget(wrapApp(ExamScreen(
        level: 'A1',
        examType: 'Vocabulary',
        questions: questions,
      )));
      await tester.pumpAndSettle();

      expect(find.text('Question 1 of 5'), findsOneWidget);
    });
  });

  group('ExamResultScreen', () {
    testWidgets('renders result screen', (tester) async {
      final vocab = getVocabByLevel('A1');
      if (vocab.length < 5) return;

      final questions = generateExamQuestions('A1', 5);
      final result = ExamResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        level: 'A1',
        examType: 'Vocabulary',
        date: DateTime.now(),
        totalQuestions: questions.length,
        correctAnswers: 4,
        incorrectAnswers: 1,
        timeSpentSeconds: 120,
        percentageScore: 80.0,
        questionResults: questions.map((q) => ExamQuestionResult(
          questionId: q['id'] as String,
          question: q['question'] as String,
          correctAnswer: q['correctAnswer'] as String,
          isCorrect: true,
          timeSpentSeconds: 20,
        )).toList(),
      );

      await tester.pumpWidget(wrapApp(ExamResultScreen(examResult: result)));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('ProfileScreen', () {
    testWidgets('renders profile page', (tester) async {
      await tester.pumpWidget(wrapApp(const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });
  });

  group('SettingsScreen', () {
    testWidgets('renders settings sections', (tester) async {
      await tester.pumpWidget(wrapApp(const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
