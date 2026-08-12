import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zedlingo/services/tts_service.dart';

class MockFlutterTts extends Mock implements FlutterTts {}

void main() {
  group('TTSService', () {
    late TTSService ttsService;
    late MockFlutterTts mockFlutterTts;

    setUp(() {
      mockFlutterTts = MockFlutterTts();
      ttsService = TTSService();
    });

    test('should initialize without errors', () async {
      SharedPreferences.setMockInitialValues({});
      await ttsService.initialize();
    });

    test('should speak text without errors', () async {
      SharedPreferences.setMockInitialValues({});
      await ttsService.initialize();
      await ttsService.speak('Hello World');
    });

    test('should stop speaking without errors', () async {
      SharedPreferences.setMockInitialValues({});
      await ttsService.initialize();
      await ttsService.stop();
    });

    test('should set speed without errors', () async {
      SharedPreferences.setMockInitialValues({});
      await ttsService.initialize();
      await ttsService.setSpeed(0.5);
    });

    test('should dispose without errors', () async {
      SharedPreferences.setMockInitialValues({});
      await ttsService.initialize();
      await ttsService.dispose();
    });
  });
}
