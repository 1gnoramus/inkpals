import 'package:flutter_test/flutter_test.dart';

import 'package:inkpals_app/main.dart';

void main() {
  testWidgets('Router working tester', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('InkPals'), findsOneWidget);

    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Canvas'), findsOneWidget);
  });
}
