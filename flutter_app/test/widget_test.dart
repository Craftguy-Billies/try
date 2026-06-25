import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App renders with navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(const FrenchApp());
    await tester.pumpAndSettle();

    // Verify navigation bar is present with the 5 tabs
    expect(find.text('Learn'), findsWidgets);
    expect(find.text('Practice'), findsWidgets);
    expect(find.text('Verbs'), findsWidgets);
    expect(find.text('Grammar'), findsWidgets);
    expect(find.text('Progress'), findsWidgets);
  });
}
