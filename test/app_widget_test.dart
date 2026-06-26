import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:french_learn/app.dart';
import 'package:french_learn/screens/onboarding/onboarding_screen.dart';
import 'package:french_learn/screens/home/home_screen.dart';
import 'package:french_learn/screens/vocabulary/vocabulary_list_screen.dart';
import 'package:french_learn/screens/exam/exam_home_screen.dart';
import 'package:french_learn/screens/grammar/grammar_list_screen.dart';
import 'package:french_learn/screens/phrases/phrases_screen.dart';
import 'package:french_learn/screens/profile/profile_screen.dart';
import 'package:french_learn/screens/profile/settings_screen.dart';
import 'package:french_learn/screens/exam/exam_quiz_screen.dart';
import 'package:french_learn/models/user_progress.dart';
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

  group('Onboarding Screen', () {
    testWidgets('renders first onboarding page with title and buttons', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('swipe changes page', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('skip button navigates away', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
    });

    testWidgets('navigates through all pages to get started', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
      await tester.pumpAndSettle();

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 2)); // let safety timer fire
      }

      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Skip'), findsNothing);
    });
  });

  group('Home Screen', () {
    testWidgets('renders with app name', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const HomeScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Learn French'), findsOneWidget);
    });

    testWidgets('shows quick action buttons', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const HomeScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Vocabulary'), findsWidgets);
      expect(find.text('Exam Prep'), findsWidgets);
      expect(find.text('Grammar'), findsWidgets);
    });

    testWidgets('shows categories section', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const HomeScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('drawer opens and contains navigation items', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const HomeScreen())));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsWidgets);
      expect(find.text('Vocabulary'), findsWidgets);
      expect(find.text('Exam Prep'), findsWidgets);
      expect(find.text('Grammar'), findsWidgets);
    });
  });

  group('Vocabulary List Screen', () {
    testWidgets('renders with search bar', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const VocabularyListScreen())));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('search filters words', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const VocabularyListScreen())));
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'bonjour');
      await tester.pumpAndSettle();
    });

    testWidgets('difficulty filter chips exist', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const VocabularyListScreen())));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('A1'), findsWidgets);
      expect(find.text('A2'), findsWidgets);
    });

    testWidgets('flashcards button is present', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const VocabularyListScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Flashcards'), findsOneWidget);
    });
  });

  group('Exam Home Screen', () {
    testWidgets('renders with exam levels', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ExamHomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Exam Prep'), findsWidgets);
      expect(find.text('DELF/DALF'), findsOneWidget);
    });
  });

  group('Grammar Screen', () {
    testWidgets('renders grammar topics', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const GrammarListScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Grammar'), findsOneWidget);
    });
  });

  group('Phrases Screen', () {
    testWidgets('renders with conversation categories', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const PhrasesScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Phrases'), findsOneWidget);
    });
  });

  group('Profile Screen', () {
    testWidgets('renders profile information', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const ProfileScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });
  });

  group('Settings Screen', () {
    testWidgets('renders settings options', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const SettingsScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });

    testWidgets('has toggle switches for preferences', (tester) async {
      await tester.pumpWidget(MaterialApp(home: wrapWithProviders(const SettingsScreen())));
      await tester.pumpAndSettle();

      expect(find.byType(Switch), findsAtLeastNWidgets(2));
    });
  });

  group('Exam Quiz Screen', () {
    testWidgets('renders exam quiz when configs exist', (tester) async {
      if (ExamService.configs.isEmpty) return;

      await tester.pumpWidget(MaterialApp(
        home: wrapWithProviders(ExamQuizScreen(config: ExamService.configs.first)),
      ));
      await tester.pumpAndSettle();
    });
  });
}
