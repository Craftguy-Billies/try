import 'package:flutter_test/flutter_test.dart';
import 'package:french_app/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FrenchApp());
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('FrenchLearn'), findsOneWidget);
  });
}
