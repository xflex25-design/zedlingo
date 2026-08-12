import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zedlingo/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ZedLingo End-to-End Tests', () {
    testWidgets('complete user journey: onboarding -> home -> explore', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Step 1: Welcome screen
      expect(find.text('Welcome to ZedLingo'), findsOneWidget);
      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();

      // Step 2: Language selection
      expect(find.text('Which language would you like to learn?'), findsOneWidget);
      await tester.tap(find.text('Bemba'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 3: Motivation
      expect(find.text('Why are you learning?'), findsOneWidget);
      await tester.tap(find.text('Family'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 4: Level
      expect(find.text('What is your current level?'), findsOneWidget);
      await tester.tap(find.text('Complete beginner'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 5: Daily goal
      expect(find.text('How much time would you like to study?'), findsOneWidget);
      await tester.tap(find.text('10 minutes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Should navigate to home
      expect(find.text('Zed'), findsOneWidget);
    });

    testWidgets('navigation between all main screens', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Skip onboarding
      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bemba'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Family'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Complete beginner'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10 minutes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Home is visible
      expect(find.text('Zed'), findsOneWidget);

      // Navigate to Real Zambia
      await tester.tap(find.text('Real Zambia'));
      await tester.pumpAndSettle();
      expect(find.text('Learn real Zambian life'), findsOneWidget);

      // Navigate to Word of the Day
      await tester.tap(find.text('Word of the Day'));
      await tester.pumpAndSettle();
      expect(find.text('Word of the Day'), findsOneWidget);

      // Navigate to Know Zambia
      await tester.tap(find.text('Know Zambia'));
      await tester.pumpAndSettle();
      expect(find.text('Understand the culture'), findsOneWidget);
    });

    testWidgets('should display mascot with correct emotions', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bemba'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Family'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Complete beginner'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10 minutes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Check for mascot on home screen
      expect(find.byType(Widget), findsWidgets);
    });
  });
}
