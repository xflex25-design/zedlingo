import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zedlingo/main.dart';
import 'package:zedlingo/routes/app_routes.dart';

void main() {
  group('HomeDashboard Integration', () {
    testWidgets('should display home dashboard elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Wait for any animations
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Check for ZedLingo branding
      expect(find.text('Zed'), findsOneWidget);
      expect(find.text('lingo'), findsOneWidget);
    });

    testWidgets('should display streak and XP chips', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Check for streak emoji
      expect(find.text('🔥'), findsOneWidget);
      expect(find.text('💎'), findsOneWidget);
    });

    testWidgets('should navigate to Real Zambia screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Tap on Real Zambia in Explore More grid
      await tester.tap(find.text('Real Zambia'));
      await tester.pumpAndSettle();

      expect(find.text('Learn real Zambian life'), findsOneWidget);
    });

    testWidgets('should navigate to Stories screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Stories'));
      await tester.pumpAndSettle();

      expect(find.text('Learn through stories'), findsOneWidget);
    });

    testWidgets('should navigate to Talk to Zambia screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Talk to Zambia'));
      await tester.pumpAndSettle();

      expect(find.text('Practice speaking with AI'), findsOneWidget);
    });

    testWidgets('should navigate to Know Zambia screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Know Zambia'));
      await tester.pumpAndSettle();

      expect(find.text('Understand the culture'), findsOneWidget);
    });

    testWidgets('should navigate to Word of the Day screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Word of the Day'));
      await tester.pumpAndSettle();

      expect(find.text('Word of the Day'), findsOneWidget);
    });
  });
}
