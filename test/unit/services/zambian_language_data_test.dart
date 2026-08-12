import 'package:flutter_test/flutter_test.dart';
import 'package:zedlingo/services/zambian_language_data.dart';

void main() {
  group('ZambianLanguageData', () {
    test('should have 7 languages', () {
      expect(ZambianLanguageData.languages.length, equals(7));
    });

    test('each language should have required properties', () {
      for (final lang in ZambianLanguageData.languages) {
        expect(lang.code, isNotEmpty);
        expect(lang.name, isNotEmpty);
        expect(lang.nativeName, isNotEmpty);
        expect(lang.flagEmoji, isNotEmpty);
        expect(lang.region, isNotEmpty);
        expect(lang.description, isNotEmpty);
        expect(lang.units, isNotEmpty);
      }
    });

    test('language codes should be unique', () {
      final codes = ZambianLanguageData.languages.map((l) => l.code).toList();
      expect(codes.length, equals(codes.toSet().length));
    });

    test('should get language by code', () {
      final bemba = ZambianLanguageData.getLanguage('bemba');
      expect(bemba, isNotNull);
      expect(bemba!.name, equals('Bemba'));
    });

    test('should return null for invalid code', () {
      final invalid = ZambianLanguageData.getLanguage('invalid');
      expect(invalid, isNull);
    });

    test('should return units for valid language', () {
      final units = ZambianLanguageData.getUnitsForLanguage('bemba');
      expect(units, isNotEmpty);
    });

    test('should return empty list for invalid language', () {
      final units = ZambianLanguageData.getUnitsForLanguage('invalid');
      expect(units, isEmpty);
    });

    test('progress key should be consistent', () {
      final key = ZambianLanguageData.progressKey('bemba', '123');
      expect(key, equals('progress_bemba_123'));
    });

    test('last lesson key should be consistent', () {
      final key = ZambianLanguageData.lastLessonKey('bemba');
      expect(key, equals('last_lesson_bemba'));
    });

    test('should have Bemba, Nyanja, Tonga, Lozi, Lunda, Kaonde, Luvale', () {
      final codes = ZambianLanguageData.languages.map((l) => l.code).toList();
      expect(codes, containsAll(['bemba', 'nyanja', 'tonga', 'lozi', 'lunda', 'kaonde', 'luvale']));
    });

    test('each unit should have lessons', () {
      for (final lang in ZambianLanguageData.languages) {
        for (final unit in lang.units) {
          expect(unit.lessons, isNotEmpty);
          for (final lesson in unit.lessons) {
            expect(lesson.exercises, isNotEmpty);
          }
        }
      }
    });
  });
}
