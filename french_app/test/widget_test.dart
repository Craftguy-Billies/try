import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:french_app/main.dart';
import 'package:french_app/providers/locale_provider.dart';
import 'package:french_app/providers/theme_provider.dart';
import 'package:french_app/providers/progress_provider.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ],
        child: const FrenchApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('FrenchLearn'), findsOneWidget);

    // Drain pending SplashScreen timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
