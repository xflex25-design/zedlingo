import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zedlingo/services/supabase_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockUser extends Mock implements User {}

void main() {
  group('SupabaseService', () {
    late SupabaseService supabaseService;
    late MockSupabaseClient mockClient;

    setUp(() {
      mockClient = MockSupabaseClient();
      supabaseService = SupabaseService();
    });

    test('should initialize service', () {
      expect(supabaseService, isNotNull);
    });

    test('should check authentication status', () {
      final isAuth = supabaseService.isAuthenticated;
      expect(isAuth, isA<bool>());
    });

    test('should get current user id', () {
      final userId = supabaseService.currentUserId;
      expect(userId, isA<String?>());
    });
  });
}
