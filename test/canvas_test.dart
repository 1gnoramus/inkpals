import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkpals_app/screens/MainScreen.dart';

void main() {
  testWidgets('Finding Canvas on the Screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final canvasFinder = find.byKey(const Key('canvas_gesture_detector'));
    expect(canvasFinder, findsOneWidget);
  });

  testWidgets('Drawing the line on the canvas', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final canvasFinder = find.byKey(const Key('canvas_gesture_detector'));
    await tester.drag(canvasFinder, const Offset(100, 100));
    await tester.pump();

    final state = tester.state(find.byType(MainScreen)) as MainScreenState;
    expect(state.lines.isNotEmpty, true);
  });

  testWidgets('Deleting lines from the canvas', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final resetBtn = find.byType(IconButton);
    await tester.tap(resetBtn);
    await tester.pump();

    final state = tester.state(find.byType(MainScreen)) as MainScreenState;
    expect(state.lines.isEmpty, true);
  });
}
