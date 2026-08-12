import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zedlingo/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ZedLingo E2E: Full user flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Complete onboarding
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
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify home screen
    expect(find.text('Zed'), findsOneWidget);
  });
}
