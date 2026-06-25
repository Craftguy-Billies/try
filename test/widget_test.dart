import 'package:flutter_test/flutter_test.dart';
import 'package:french_learn/app.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const FrenchLearnApp());
    expect(find.byType(FrenchLearnApp), findsOneWidget);
  });
}
