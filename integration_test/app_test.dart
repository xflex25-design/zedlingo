import 'package:flutter_test/flutter_test.dart';
import 'package:zedlingo/main.dart' as app;

void main() {
  testWidgets('ZedLingo loads without crashing', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(Widget), findsWidgets);
  });
}
