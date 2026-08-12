import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zedlingo/main.dart';
import 'package:zedlingo/routes/app_routes.dart';

void main() {
  group('OnboardingFlow Integration', () {
    testWidgets('should display onboarding screen on app start', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Welcome to ZedLingo'), findsOneWidget);
    });

    testWidgets('should navigate through onboarding steps', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Step 1: Welcome
      expect(find.text('Welcome to ZedLingo'), findsOneWidget);
      
      // Tap Start Learning
      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();

      // Step 2: Language selection
      expect(find.text('Which language would you like to learn?'), findsOneWidget);
    });

    testWidgets('should display all 7 Zambian languages', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to language selection
      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();

      expect(find.text('Bemba'), findsOneWidget);
      expect(find.text('Nyanja'), findsOneWidget);
      expect(find.text('Tonga'), findsOneWidget);
      expect(find.text('Lozi'), findsOneWidget);
      expect(find.text('Lunda'), findsOneWidget);
      expect(find.text('Kaonde'), findsOneWidget);
      expect(find.text('Luvale'), findsOneWidget);
    });

    testWidgets('should allow language selection with audio preview', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();

      // Tap on Bemba
      await tester.tap(find.text('Bemba'));
      await tester.pumpAndSettle();

      // Should show audio button
      expect(find.byIcon(Icons.volume_up_rounded), findsWidgets);
    });
  });
}
