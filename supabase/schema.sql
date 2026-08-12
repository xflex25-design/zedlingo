-- ============================================
-- ZEDLINGO SUPABASE SCHEMA
-- Complete database for Zambian language learning
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. PROFILES (extends auth.users)
-- ============================================
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  current_language_code TEXT DEFAULT 'bemba',
  level INTEGER DEFAULT 1,
  total_xp INTEGER DEFAULT 0,
  streak_days INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_active_date DATE,
  daily_goal_minutes INTEGER DEFAULT 10,
  hearts INTEGER DEFAULT 5,
  max_hearts INTEGER DEFAULT 5,
  zed_coins INTEGER DEFAULT 0,
  gems INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- 2. LANGUAGES
-- ============================================
CREATE TABLE public.languages (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  native_name TEXT NOT NULL,
  flag_emoji TEXT DEFAULT '🇿🇲',
  color_hex TEXT DEFAULT '#58CC02',
  region TEXT NOT NULL,
  description TEXT NOT NULL,
  speaker_count TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.languages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Languages are viewable by everyone" ON public.languages
  FOR SELECT USING (true);

-- ============================================
-- 3. UNITS
-- ============================================
CREATE TABLE public.units (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  language_code TEXT NOT NULL REFERENCES public.languages(code) ON DELETE CASCADE,
  unit_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  subtitle TEXT,
  emoji TEXT DEFAULT '📚',
  image_url TEXT,
  xp_reward INTEGER DEFAULT 50,
  is_unlocked BOOLEAN DEFAULT FALSE,
  prerequisites JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(language_code, unit_number)
);

ALTER TABLE public.units ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Units are viewable by everyone" ON public.units
  FOR SELECT USING (true);

-- ============================================
-- 4. LESSONS
-- ============================================
CREATE TABLE public.lessons (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  lesson_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  xp_reward INTEGER DEFAULT 10,
  is_completed BOOLEAN DEFAULT FALSE,
  is_unlocked BOOLEAN DEFAULT FALSE,
  exercise_count INTEGER DEFAULT 5,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(unit_id, lesson_number)
);

ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lessons are viewable by everyone" ON public.lessons
  FOR SELECT USING (true);

-- ============================================
-- 5. EXERCISES
-- ============================================
CREATE TABLE public.exercises (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  exercise_number INTEGER NOT NULL,
  type TEXT NOT NULL CHECK (type IN (
    'multiple_choice',
    'complete_the_chat',
    'tap_the_word',
    'listen_and_pick',
    'match_activity',
    'fill_in_blank',
    'sentence_construction',
    'translation'
  )),
  instruction TEXT NOT NULL,
  question TEXT NOT NULL,
  correct_answer TEXT NOT NULL,
  options JSONB NOT NULL,
  cultural_note TEXT,
  audio_text TEXT,
  mascot_message TEXT,
  word_bank JSONB,
  xp_reward INTEGER DEFAULT 10,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(lesson_id, exercise_number)
);

ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Exercises are viewable by everyone" ON public.exercises
  FOR SELECT USING (true);

-- ============================================
-- 6. USER PROGRESS
-- ============================================
CREATE TABLE public.user_progress (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  language_code TEXT NOT NULL,
  unit_id UUID REFERENCES public.units(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES public.lessons(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE,
  is_correct BOOLEAN,
  attempts INTEGER DEFAULT 1,
  xp_earned INTEGER DEFAULT 0,
  completed_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(user_id, exercise_id)
);

ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own progress" ON public.user_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress" ON public.user_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress" ON public.user_progress
  FOR UPDATE USING (auth.uid() = user_id);

-- ============================================
-- 7. SCENARIOS (Real Zambia Mode)
-- ============================================
CREATE TABLE public.scenarios (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  language_code TEXT NOT NULL,
  title TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  emoji TEXT NOT NULL,
  image_url TEXT,
  description TEXT NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  xp_reward INTEGER DEFAULT 30,
  zed_coins_reward INTEGER DEFAULT 10,
  is_unlocked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.scenarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Scenarios are viewable by everyone" ON public.scenarios
  FOR SELECT USING (true);

-- ============================================
-- 8. SCENARIO STEPS
-- ============================================
CREATE TABLE public.scenario_steps (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  scenario_id UUID NOT NULL REFERENCES public.scenarios(id) ON DELETE CASCADE,
  step_number INTEGER NOT NULL,
  speaker TEXT NOT NULL CHECK (speaker IN ('npc', 'user')),
  text_local TEXT NOT NULL,
  text_english TEXT NOT NULL,
  audio_url TEXT,
  hint TEXT,
  correct_response TEXT,
  UNIQUE(scenario_id, step_number)
);

ALTER TABLE public.scenario_steps ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Scenario steps are viewable by everyone" ON public.scenario_steps
  FOR SELECT USING (true);

-- ============================================
-- 9. USER SCENARIO PROGRESS
-- ============================================
CREATE TABLE public.user_scenario_progress (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  scenario_id UUID NOT NULL REFERENCES public.scenarios(id) ON DELETE CASCADE,
  is_completed BOOLEAN DEFAULT FALSE,
  current_step INTEGER DEFAULT 0,
  xp_earned INTEGER DEFAULT 0,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(user_id, scenario_id)
);

ALTER TABLE public.user_scenario_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own scenario progress" ON public.user_scenario_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own scenario progress" ON public.user_scenario_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own scenario progress" ON public.user_scenario_progress
  FOR UPDATE USING (auth.uid() = user_id);

-- ============================================
-- 10. STORIES
-- ============================================
CREATE TABLE public.stories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  language_code TEXT NOT NULL,
  title TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  emoji TEXT NOT NULL,
  image_url TEXT,
  description TEXT NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  xp_reward INTEGER DEFAULT 40,
  zed_coins_reward INTEGER DEFAULT 15,
  is_unlocked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.stories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Stories are viewable by everyone" ON public.stories
  FOR SELECT USING (true);

-- ============================================
-- 11. STORY PAGES
-- ============================================
CREATE TABLE public.story_pages (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  story_id UUID NOT NULL REFERENCES public.stories(id) ON DELETE CASCADE,
  page_number INTEGER NOT NULL,
  text_local TEXT NOT NULL,
  text_english TEXT NOT NULL,
  audio_url TEXT,
  illustration_url TEXT,
  UNIQUE(story_id, page_number)
);

ALTER TABLE public.story_pages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Story pages are viewable by everyone" ON public.story_pages
  FOR SELECT USING (true);

-- ============================================
-- 12. USER STORY PROGRESS
-- ============================================
CREATE TABLE public.user_story_progress (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  story_id UUID NOT NULL REFERENCES public.stories(id) ON DELETE CASCADE,
  is_completed BOOLEAN DEFAULT FALSE,
  current_page INTEGER DEFAULT 0,
  xp_earned INTEGER DEFAULT 0,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(user_id, story_id)
);

ALTER TABLE public.user_story_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own story progress" ON public.user_story_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own story progress" ON public.user_story_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own story progress" ON public.user_story_progress
  FOR UPDATE USING (auth.uid() = user_id);

-- ============================================
-- 13. ACHIEVEMENTS
-- ============================================
CREATE TABLE public.achievements (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  emoji TEXT NOT NULL,
  icon_url TEXT,
  xp_reward INTEGER DEFAULT 0,
  zed_coins_reward INTEGER DEFAULT 0,
  category TEXT NOT NULL,
  rarity TEXT DEFAULT 'common' CHECK (rarity IN ('common', 'rare', 'epic', 'legendary')),
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Achievements are viewable by everyone" ON public.achievements
  FOR SELECT USING (true);

-- ============================================
-- 14. USER ACHIEVEMENTS
-- ============================================
CREATE TABLE public.user_achievements (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES public.achievements(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(user_id, achievement_id)
);

ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own achievements" ON public.user_achievements
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own achievements" ON public.user_achievements
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================
-- 15. DAILY CHALLENGES
-- ============================================
CREATE TABLE public.daily_challenges (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  challenge_type TEXT NOT NULL,
  target_value INTEGER NOT NULL,
  xp_reward INTEGER DEFAULT 20,
  zed_coins_reward INTEGER DEFAULT 5,
  icon TEXT DEFAULT '🎯',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.daily_challenges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Daily challenges are viewable by everyone" ON public.daily_challenges
  FOR SELECT USING (true);

-- ============================================
-- 16. USER DAILY CHALLENGE PROGRESS
-- ============================================
CREATE TABLE public.user_daily_challenges (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES public.daily_challenges(id) ON DELETE CASCADE,
  current_progress INTEGER DEFAULT 0,
  is_completed BOOLEAN DEFAULT FALSE,
  claimed BOOLEAN DEFAULT FALSE,
  date DATE DEFAULT CURRENT_DATE,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(user_id, challenge_id, date)
);

ALTER TABLE public.user_daily_challenges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own daily challenge progress" ON public.user_daily_challenges
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own daily challenge progress" ON public.user_daily_challenges
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own daily challenge progress" ON public.user_daily_challenges
  FOR UPDATE USING (auth.uid() = user_id);

-- ============================================
-- 17. WORD OF THE DAY
-- ============================================
CREATE TABLE public.word_of_the_day (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  language_code TEXT NOT NULL,
  word_local TEXT NOT NULL,
  word_english TEXT NOT NULL,
  pronunciation TEXT NOT NULL,
  example_sentence_local TEXT NOT NULL,
  example_sentence_english TEXT NOT NULL,
  audio_url TEXT,
  difficulty TEXT DEFAULT 'beginner',
  date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(language_code, date)
);

ALTER TABLE public.word_of_the_day ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Word of the day is viewable by everyone" ON public.word_of_the_day
  FOR SELECT USING (true);

-- ============================================
-- 18. CULTURAL CONTENT (Know Zambia)
-- ============================================
CREATE TABLE public.cultural_content (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  language_code TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN (
    'greetings',
    'respect_norms',
    'family_structures',
    'food_culture',
    'community_life',
    'music_football',
    'education_work',
    'regional_differences'
  )),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  image_url TEXT,
  tips TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.cultural_content ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Cultural content is viewable by everyone" ON public.cultural_content
  FOR SELECT USING (true);

-- ============================================
-- 19. AUDIO FILES
-- ============================================
CREATE TABLE public.audio_files (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  language_code TEXT NOT NULL,
  text TEXT NOT NULL,
  audio_url TEXT NOT NULL,
  voice_type TEXT DEFAULT 'native',
  speed TEXT DEFAULT 'normal' CHECK (speed IN ('slow', 'normal', 'fast')),
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.audio_files ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Audio files are viewable by everyone" ON public.audio_files
  FOR SELECT USING (true);

-- ============================================
-- 20. NOTIFICATIONS
-- ============================================
CREATE TABLE public.notifications (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB DEFAULT '{}'::jsonb,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own notifications" ON public.notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON public.notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- ============================================
-- 21. INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX idx_profiles_user_id ON public.profiles(id);
CREATE INDEX idx_profiles_language ON public.profiles(current_language_code);
CREATE INDEX idx_units_language ON public.units(language_code);
CREATE INDEX idx_lessons_unit ON public.lessons(unit_id);
CREATE INDEX idx_exercises_lesson ON public.exercises(lesson_id);
CREATE INDEX idx_user_progress_user ON public.user_progress(user_id);
CREATE INDEX idx_user_progress_language ON public.user_progress(language_code);
CREATE INDEX idx_scenarios_language ON public.scenarios(language_code);
CREATE INDEX idx_stories_language ON public.stories(language_code);
CREATE INDEX idx_user_scenario_progress_user ON public.user_scenario_progress(user_id);
CREATE INDEX idx_user_story_progress_user ON public.user_story_progress(user_id);
CREATE INDEX idx_user_achievements_user ON public.user_achievements(user_id);
CREATE INDEX idx_notifications_user ON public.notifications(user_id);

-- ============================================
-- 22. SEED DATA: LANGUAGES
-- ============================================
INSERT INTO public.languages (code, name, native_name, color_hex, region, description, speaker_count) VALUES
  ('bemba', 'Bemba', 'Ichibemba', '#58CC02', 'Copperbelt & Northern Province', 'Spoken by over 3.7 million Zambians. The language of the Copperbelt mines and Northern Province highlands.', '3.7M+'),
  ('nyanja', 'Nyanja', 'Chinyanja', '#1CB0F6', 'Lusaka & Eastern Province', 'The lingua franca of Lusaka and Eastern Province. Spoken by over 2.5 million Zambians.', '2.5M+'),
  ('tonga', 'Tonga', 'Chitonga', '#FF9600', 'Southern Province', 'Language of the Southern Province and Gwembe Valley. Rich in cattle-herding and farming vocabulary.', '1.5M+'),
  ('lozi', 'Lozi', 'Silozi', '#FF4B4B', 'Western Province', 'The royal language of Barotseland. Known for the famous Kuomboka ceremony on the Zambezi floodplains.', '800K+'),
  ('lunda', 'Lunda', 'Chilunda', '#9B59B6', 'North-Western Province', 'Language of the ancient Lunda Kingdom. Spoken across North-Western Province and into DRC.', '600K+'),
  ('kaonde', 'Kaonde', 'Chikaonde', '#E74C3C', 'North-Western Province', 'Spoken in North-Western Province. Known for its unique tonal patterns and rich oral traditions.', '400K+'),
  ('luvale', 'Luvale', 'Chiluvale', '#2ECC71', 'North-Western & Western Province', 'Language of the Luvale people. Famous for the Makishi masquerade tradition and vibrant cultural ceremonies.', '300K+');

-- ============================================
-- 23. SEED DATA: ACHIEVEMENTS
-- ============================================
INSERT INTO public.achievements (code, title, description, emoji, xp_reward, zed_coins_reward, category, rarity) VALUES
  ('first_word', 'First Word', 'Learned your first word in a Zambian language', '🗣️', 10, 5, 'learning', 'common'),
  ('first_lesson', 'First Lesson', 'Completed your first lesson', '📚', 20, 10, 'learning', 'common'),
  ('week_streak', '7-Day Streak', 'Practiced for 7 days in a row', '🔥', 50, 25, 'streak', 'rare'),
  ('month_streak', '30-Day Streak', 'Practiced for 30 days in a row', '🌟', 200, 100, 'streak', 'epic'),
  ('first_conversation', 'First Conversation', 'Completed your first conversation practice', '💬', 30, 15, 'speaking', 'common'),
  ('market_master', 'Market Master', 'Completed the Market scenario', '🛒', 40, 20, 'scenario', 'rare'),
  ('minibus_warrior', 'Minibus Warrior', 'Completed the Minibus scenario', '🚌', 40, 20, 'scenario', 'rare'),
  ('cultural_explorer', 'Cultural Explorer', 'Read 5 cultural content articles', '🏛️', 30, 15, 'culture', 'rare'),
  ('vocabulary_100', 'Vocabulary Pro', 'Learned 100 words', '📖', 100, 50, 'learning', 'epic'),
  ('zambian_eagle', 'Zambian Eagle', 'Reached Level 10', '🦅', 150, 75, 'milestone', 'legendary');

-- ============================================
-- 24. SEED DATA: DAILY CHALLENGES
-- ============================================
INSERT INTO public.daily_challenges (title, description, challenge_type, target_value, xp_reward, zed_coins_reward, icon) VALUES
  ('Word Learner', 'Learn 10 new words today', 'words_learned', 10, 20, 5, '📝'),
  ('Lesson Finisher', 'Complete 1 lesson', 'lessons_completed', 1, 30, 10, '✅'),
  ('Scenario Master', 'Complete 1 Real Zambia scenario', 'scenarios_completed', 1, 40, 15, '🇿🇲'),
  ('Conversation Practice', 'Practice speaking for 5 minutes', 'speaking_minutes', 5, 25, 10, '🎤'),
  ('Streak Keeper', 'Maintain your daily streak', 'streak_maintained', 1, 15, 5, '🔥'),
  ('Story Reader', 'Read 1 Zambia Story', 'stories_read', 1, 35, 12, '📖');

-- ============================================
-- 25. ENABLE REALTIME (optional)
-- ============================================
-- Uncomment if you want real-time features
-- ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
-- ALTER PUBLICATION supabase_realtime ADD TABLE public.user_progress;
