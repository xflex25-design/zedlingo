import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zedlingo/widgets/scenario_illustration.dart';

void main() {
  group('ScenarioIllustration', () {
    testWidgets('should render minibus illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.minibus),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render market illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.market),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render shop illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.shop),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render elder illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.elder),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render family illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.family),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render football illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.football),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render clinic illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.clinic),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render mobile money illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.mobileMoney),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render work illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.work),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render school illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.school),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should render story illustration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.story),
          ),
        ),
      );

      expect(find.byType(ScenarioIllustration), findsOneWidget);
    });

    testWidgets('should respect custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScenarioIllustration(type: ScenarioType.minibus, size: 300),
          ),
        ),
      );

      final widget = tester.widget<ScenarioIllustration>(find.byType(ScenarioIllustration));
      expect(widget.size, equals(300));
    });
  });
}
