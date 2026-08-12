import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient client;

  Future<void> initialize() async {
    client = Supabase.instance.client;
  }

  // Auth
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithGoogle() async {
    await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'zedlingo://login-callback/',
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  bool get isAuthenticated => client.auth.currentUser != null;
  String? get currentUserId => client.auth.currentUser?.id;

  // Profile
  Future<Map<String, dynamic>?> getProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;

    final response = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final userId = currentUserId;
    if (userId == null) return;

    await client
        .from('profiles')
        .update(data)
        .eq('id', userId);
  }

  Future<void> switchLanguage(String languageCode) async {
    final userId = currentUserId;
    if (userId == null) return;

    await client
        .from('profiles')
        .update({'current_language_code': languageCode})
        .eq('id', userId);
  }

  // Progress
  Future<void> saveProgress({
    required String languageCode,
    required String exerciseId,
    required bool isCorrect,
    required int xpEarned,
  }) async {
    final userId = currentUserId;
    if (userId == null) return;

    await client.from('user_progress').upsert({
      'user_id': userId,
      'language_code': languageCode,
      'exercise_id': exerciseId,
      'is_correct': isCorrect,
      'xp_earned': xpEarned,
      'completed_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id,exercise_id');
  }

  Future<List<Map<String, dynamic>>> getUserProgress(String languageCode) async {
    final userId = currentUserId;
    if (userId == null) return [];

    final response = await client
        .from('user_progress')
        .select()
        .eq('user_id', userId)
        .eq('language_code', languageCode);

    return List<Map<String, dynamic>>.from(response);
  }

  // Scenarios
  Future<List<Map<String, dynamic>>> getScenarios(String languageCode) async {
    final response = await client
        .from('scenarios')
        .select()
        .eq('language_code', languageCode)
        .order('difficulty');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getScenarioSteps(String scenarioId) async {
    final response = await client
        .from('scenario_steps')
        .select()
        .eq('scenario_id', scenarioId)
        .order('step_number');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> saveScenarioProgress({
    required String scenarioId,
    required int currentStep,
    bool isCompleted = false,
  }) async {
    final userId = currentUserId;
    if (userId == null) return;

    await client.from('user_scenario_progress').upsert({
      'user_id': userId,
      'scenario_id': scenarioId,
      'current_step': currentStep,
      'is_completed': isCompleted,
      'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
    }, onConflict: 'user_id,scenario_id');
  }

  // Stories
  Future<List<Map<String, dynamic>>> getStories(String languageCode) async {
    final response = await client
        .from('stories')
        .select()
        .eq('language_code', languageCode)
        .order('difficulty');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getStoryPages(String storyId) async {
    final response = await client
        .from('story_pages')
        .select()
        .eq('story_id', storyId)
        .order('page_number');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> saveStoryProgress({
    required String storyId,
    required int currentPage,
    bool isCompleted = false,
  }) async {
    final userId = currentUserId;
    if (userId == null) return;

    await client.from('user_story_progress').upsert({
      'user_id': userId,
      'story_id': storyId,
      'current_page': currentPage,
      'is_completed': isCompleted,
      'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
    }, onConflict: 'user_id,story_id');
  }

  // Achievements
  Future<List<Map<String, dynamic>>> getAchievements() async {
    final response = await client
        .from('achievements')
        .select()
        .order('rarity');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getUserAchievements() async {
    final userId = currentUserId;
    if (userId == null) return [];

    final response = await client
        .from('user_achievements')
        .select('*, achievements(*)')
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> unlockAchievement(String achievementId) async {
    final userId = currentUserId;
    if (userId == null) return;

    await client.from('user_achievements').insert({
      'user_id': userId,
      'achievement_id': achievementId,
    }).onConflict('user_id,achievement_id').doNothing();
  }

  // Daily Challenges
  Future<List<Map<String, dynamic>>> getDailyChallenges() async {
    final response = await client
        .from('daily_challenges')
        .select()
        .eq('is_active', true)
        .limit(5);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getUserDailyChallenges() async {
    final userId = currentUserId;
    if (userId == null) return [];

    final response = await client
        .from('user_daily_challenges')
        .select('*, daily_challenges(*)')
        .eq('user_id', userId)
        .eq('date', DateTime.now().toIso8601String().split('T').first);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateDailyChallengeProgress({
    required String challengeId,
    required int currentProgress,
    bool isCompleted = false,
  }) async {
    final userId = currentUserId;
    if (userId == null) return;

    await client.from('user_daily_challenges').upsert({
      'user_id': userId,
      'challenge_id': challengeId,
      'current_progress': currentProgress,
      'is_completed': isCompleted,
      'date': DateTime.now().toIso8601String().split('T').first,
    }, onConflict: 'user_id,challenge_id,date');
  }

  // Word of the Day
  Future<Map<String, dynamic>?> getWordOfTheDay(String languageCode) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final response = await client
        .from('word_of_the_day')
        .select()
        .eq('language_code', languageCode)
        .eq('date', today)
        .maybeSingle();

    return response;
  }

  // Cultural Content
  Future<List<Map<String, dynamic>>> getCulturalContent(
    String languageCode,
    String category,
  ) async {
    final response = await client
        .from('cultural_content')
        .select()
        .eq('language_code', languageCode)
        .eq('category', category);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getAllCulturalContent(
    String languageCode,
  ) async {
    final response = await client
        .from('cultural_content')
        .select()
        .eq('language_code', languageCode);

    return List<Map<String, dynamic>>.from(response);
  }

  // Notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final userId = currentUserId;
    if (userId == null) return [];

    final response = await client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(20);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> markNotificationRead(String notificationId) async {
    await client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  // Languages
  Future<List<Map<String, dynamic>>> getLanguages() async {
    final response = await client
        .from('languages')
        .select()
        .eq('is_active', true)
        .order('name');

    return List<Map<String, dynamic>>.from(response);
  }

  // Units & Lessons
  Future<List<Map<String, dynamic>>> getUnits(String languageCode) async {
    final response = await client
        .from('units')
        .select()
        .eq('language_code', languageCode)
        .order('unit_number');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getLessons(String unitId) async {
    final response = await client
        .from('lessons')
        .select()
        .eq('unit_id', unitId)
        .order('lesson_number');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getExercises(String lessonId) async {
    final response = await client
        .from('exercises')
        .select()
        .eq('lesson_id', lessonId)
        .order('exercise_number');

    return List<Map<String, dynamic>>.from(response);
  }

  // Audio
  Future<String?> getAudioUrl(String text, String languageCode) async {
    final response = await client
        .from('audio_files')
        .select('audio_url')
        .eq('language_code', languageCode)
        .eq('text', text)
        .maybeSingle();

    return response?['audio_url'];
  }
}
