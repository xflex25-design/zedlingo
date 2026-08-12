import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zedlingo/widgets/zambian_eagle_mascot.dart';

void main() {
  group('ZambianEagleMascot', () {
    testWidgets('should render with default emotion', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZambianEagleMascot(),
          ),
        ),
      );

      expect(find.byType(ZambianEagleMascot), findsOneWidget);
    });

    testWidgets('should render with custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZambianEagleMascot(size: 200),
          ),
        ),
      );

      expect(find.byType(ZambianEagleMascot), findsOneWidget);
    });

    testWidgets('should respond to tap when onTap is provided', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZambianEagleMascot(
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ZambianEagleMascot));
      expect(tapped, isTrue);
    });

    testWidgets('should render all emotion types', (WidgetTester tester) async {
      for (final emotion in MascotEmotion.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ZambianEagleMascot(emotion: emotion),
            ),
          ),
        );

        expect(find.byType(ZambianEagleMascot), findsOneWidget);
      }
    });
  });
}
