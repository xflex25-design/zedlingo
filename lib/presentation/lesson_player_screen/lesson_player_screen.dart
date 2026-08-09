import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../services/sound_service.dart';
import './widgets/lesson_answer_options_widget.dart';
import './widgets/lesson_check_button_widget.dart';
import './widgets/lesson_exercise_widget.dart';
import './widgets/lesson_feedback_drawer_widget.dart';
import './widgets/lesson_top_bar_widget.dart';
import './widgets/complete_the_chat_widget.dart';
import './widgets/tap_the_word_widget.dart';
import './widgets/listen_and_pick_widget.dart';
import './widgets/celebration_overlay_widget.dart';

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen>
    with TickerProviderStateMixin {
  int _currentExerciseIndex = 0;
  String? _selectedAnswer;
  bool _hasChecked = false;
  bool _isCorrect = false;
  bool _showFeedback = false;
  bool _showCelebration = false;
  int _hearts = 5;
  final int _streakCount = 7;
  int _xpEarned = 0;
  bool _isSlangMode = false;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackSlide;
  late AnimationController _mascotController;
  late Animation<double> _mascotBounce;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  final _sound = SoundService();

  // Rich exercise data with multiple types
  static const List<Map<String, dynamic>> _exercisesMaps = [
    {
      'type': 'multiple_choice',
      'instruction': 'Translate to Bemba',
      'question': 'Hello, how are you?',
      'correct_answer': 'Muli shani?',
      'options': ['Muli shani?', 'Muli bwanji?', 'Nuli bwino?', 'Natotela?'],
      'cultural_note':
          'In Bemba culture, greetings show respect and build connection. "Muli shani?" is the standard greeting among equals.',
      'xp_reward': 10,
      'perfect_bonus': 5,
      'is_slang': false,
    },
    {
      'type': 'complete_the_chat',
      'instruction': 'Complete the chat',
      'mascot_message': 'Muli shani, mukwai? Mwabuka bwino?',
      'question': 'Zam-Eagle greets you in the morning. How do you reply?',
      'correct_answer': 'Nili bwino, natotela! Mwabuka bwino?',
      'options': [
        'Nili bwino, natotela! Mwabuka bwino?',
        'Twende ku market lelo.',
        'Nshikwete ndalama.',
      ],
      'cultural_note':
          'Responding to a morning greeting with "Mwabuka bwino?" (Did you wake up well?) shows you care about the other person\'s wellbeing — a key Bemba cultural value.',
      'xp_reward': 15,
      'perfect_bonus': 7,
      'is_slang': false,
    },
    {
      'type': 'tap_the_word',
      'instruction': 'Arrange the words',
      'question': 'Build the Bemba sentence for: "I want to go to the market"',
      'correct_answer': 'Nfuna ukwenda ku market',
      'word_bank': ['Nfuna', 'ukwenda', 'ku', 'market', 'ndalama', 'bwino'],
      'options': [],
      'cultural_note':
          '"Nfuna" means "I want" in Bemba. Markets (amasoko) are the heart of Zambian community life — from Soweto Market in Lusaka to Chisokone in Kitwe.',
      'xp_reward': 12,
      'perfect_bonus': 6,
      'is_slang': false,
    },
    {
      'type': 'listen_and_pick',
      'instruction': 'Listen and pick',
      'question': 'What does this Bemba phrase mean?',
      'audio_text': 'Natotela sana, mukwai',
      'correct_answer': 'Thank you very much, sir/madam',
      'options': [
        'Thank you very much, sir/madam',
        'Good morning, how are you?',
        'I am going to the market',
        'Please help me',
      ],
      'cultural_note':
          '"Mukwai" is a respectful address used for elders and strangers in Bemba. Always use it when speaking to someone older than you.',
      'xp_reward': 12,
      'perfect_bonus': 6,
      'is_slang': false,
    },
    {
      'type': 'multiple_choice',
      'instruction': 'Kopala Street Slang — Translate',
      'question': 'What\'s up, friend?',
      'correct_answer': 'Bonde, chalo?',
      'options': [
        'Bonde, chalo?',
        'Muli shani, mukwai?',
        'Twende amapano',
        'Nili bwino',
      ],
      'cultural_note':
          '"Bonde" is Kopala slang for "friend/bro". "Chalo" means "dude/guy" in Copperbelt street language. This is how youth greet on the streets of Kitwe.',
      'xp_reward': 15,
      'perfect_bonus': 7,
      'is_slang': true,
    },
    {
      'type': 'complete_the_chat',
      'instruction': 'Complete the chat',
      'mascot_message': 'Bonde! Uya kuti lelo?',
      'question':
          'Your friend asks where you\'re going. Reply in Kopala slang.',
      'correct_answer': 'Naya ku chisokone, tukopele!',
      'options': [
        'Naya ku chisokone, tukopele!',
        'Nili ku sukulu lelo.',
        'Muli shani, mukwai?',
      ],
      'cultural_note':
          '"Tukopele" is Kopala slang meaning "let\'s go/let\'s hustle". Chisokone Market in Kitwe is the biggest market on the Copperbelt.',
      'xp_reward': 15,
      'perfect_bonus': 7,
      'is_slang': true,
    },
  ];

  double get _progressValue =>
      (_currentExerciseIndex + 1) / _exercisesMaps.length;

  Map<String, dynamic> get _currentExercise =>
      _exercisesMaps[_currentExerciseIndex];

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _feedbackSlide = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeOutCubic),
    );
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _mascotBounce = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.elasticOut),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _mascotController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onAnswerSelected(String answer) {
    if (_hasChecked) return;
    setState(() => _selectedAnswer = answer);
    _sound.playTap();
  }

  void _onCheck() {
    if (_selectedAnswer == null) return;
    final exercise = _currentExercise;
    final correct = _selectedAnswer == exercise['correct_answer'];

    setState(() {
      _hasChecked = true;
      _isCorrect = correct;
      _showFeedback = true;
      if (correct) {
        _xpEarned += (exercise['xp_reward'] as int);
        _showCelebration = true;
      } else {
        if (_hearts > 0) _hearts--;
      }
    });

    if (correct) {
      _sound.playCorrect();
      _mascotController.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _showCelebration = false);
      });
    } else {
      _sound.playIncorrect();
      _shakeController.forward(from: 0);
    }

    _feedbackController.forward();
  }

  void _onContinue() {
    _feedbackController.reset();
    if (_currentExerciseIndex < _exercisesMaps.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _selectedAnswer = null;
        _hasChecked = false;
        _isCorrect = false;
        _showFeedback = false;
        _showCelebration = false;
      });
    } else {
      _sound.playLessonComplete();
      _showLessonCompleteDialog();
    }
  }

  void _showLessonCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🦅', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 12),
              Text(
                'Lesson Complete!',
                style: GoogleFonts.nunitoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.zambiaBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mwabomba bwino! (Well done!)',
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B6B6B),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      label: 'MaKopala',
                      value: '+$_xpEarned',
                      emoji: '🪙',
                    ),
                    _StatChip(
                      label: 'Hearts',
                      value: '$_hearts/5',
                      emoji: '❤️',
                    ),
                    _StatChip(
                      label: 'Moto',
                      value: '${_streakCount + 1}🔥',
                      emoji: '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isCheckEnabled {
    if (_hasChecked) return false;
    final type = _currentExercise['type'] as String;
    if (type == 'tap_the_word') {
      return _selectedAnswer != null && _selectedAnswer!.isNotEmpty;
    }
    return _selectedAnswer != null;
  }

  Widget _buildExerciseContent(Map<String, dynamic> exercise) {
    final type = exercise['type'] as String;

    switch (type) {
      case 'complete_the_chat':
        return CompleteTheChatWidget(
          mascotMessage: exercise['mascot_message'] as String,
          options: List<String>.from(exercise['options'] as List),
          selectedAnswer: _selectedAnswer,
          correctAnswer: _hasChecked
              ? exercise['correct_answer'] as String
              : null,
          hasChecked: _hasChecked,
          onSelected: _onAnswerSelected,
        );

      case 'tap_the_word':
        return TapTheWordWidget(
          instruction: exercise['instruction'] as String,
          question: exercise['question'] as String,
          wordBank: List<String>.from(exercise['word_bank'] as List),
          correctAnswer: exercise['correct_answer'] as String,
          hasChecked: _hasChecked,
          onAnswerChanged: (answer) {
            setState(() => _selectedAnswer = answer);
          },
        );

      case 'listen_and_pick':
        return ListenAndPickWidget(
          audioText: exercise['audio_text'] as String,
          options: List<String>.from(exercise['options'] as List),
          selectedAnswer: _selectedAnswer,
          correctAnswer: _hasChecked
              ? exercise['correct_answer'] as String
              : null,
          hasChecked: _hasChecked,
          onSelected: _onAnswerSelected,
        );

      default: // multiple_choice
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LessonExerciseWidget(
              instruction: exercise['instruction'] as String,
              question: exercise['question'] as String,
              isSlang: exercise['is_slang'] as bool? ?? false,
            ),
            const SizedBox(height: 28),
            LessonAnswerOptionsWidget(
              options: List<String>.from(exercise['options'] as List),
              selectedAnswer: _selectedAnswer,
              correctAnswer: _hasChecked
                  ? exercise['correct_answer'] as String
                  : null,
              hasChecked: _hasChecked,
              onSelected: _onAnswerSelected,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final exercise = _currentExercise;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 560 : double.infinity,
                ),
                child: Column(
                  children: [
                    // Top bar
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (context, child) {
                        final shake = _shakeController.isAnimating
                            ? (_shakeAnim.value *
                                      8 *
                                      ((_shakeAnim.value * 4).floor() % 2 == 0
                                          ? 1
                                          : -1))
                                  .clamp(-8.0, 8.0)
                            : 0.0;
                        return Transform.translate(
                          offset: Offset(shake, 0),
                          child: child,
                        );
                      },
                      child: LessonTopBarWidget(
                        progress: _progressValue,
                        hearts: _hearts,
                        streak: _streakCount,
                        isSlangMode: _isSlangMode,
                        isSlangExercise: exercise['is_slang'] as bool? ?? false,
                        onClose: () => context.pop(),
                        onSlangToggle: () =>
                            setState(() => _isSlangMode = !_isSlangMode),
                      ),
                    ),

                    // Exercise type indicator pill
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                      child: _ExerciseTypePill(
                        type: exercise['type'] as String,
                        isSlang: exercise['is_slang'] as bool? ?? false,
                      ),
                    ),

                    // Exercise content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _buildExerciseContent(exercise),
                      ),
                    ),

                    // CHECK button
                    LessonCheckButtonWidget(
                      isEnabled: _isCheckEnabled,
                      onCheck: _onCheck,
                    ),
                  ],
                ),
              ),
            ),

            // Feedback drawer overlay
            if (_showFeedback)
              LessonFeedbackDrawerWidget(
                isCorrect: _isCorrect,
                correctAnswer: exercise['correct_answer'] as String,
                culturalNote: exercise['cultural_note'] as String,
                xpEarned: exercise['xp_reward'] as int,
                perfectBonus: exercise['perfect_bonus'] as int,
                slideAnimation: _feedbackSlide,
                onContinue: _onContinue,
              ),

            // Celebration overlay
            if (_showCelebration)
              CelebrationOverlayWidget(
                xpEarned: exercise['xp_reward'] as int,
                onDismiss: () {
                  if (mounted) setState(() => _showCelebration = false);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseTypePill extends StatelessWidget {
  final String type;
  final bool isSlang;

  const _ExerciseTypePill({required this.type, required this.isSlang});

  String get _label {
    switch (type) {
      case 'complete_the_chat':
        return '💬 Complete the Chat';
      case 'tap_the_word':
        return '👆 Tap the Word';
      case 'listen_and_pick':
        return '🎧 Listen & Pick';
      default:
        return isSlang ? '🗣️ Kopala Slang' : '📝 Translate';
    }
  }

  Color get _color {
    switch (type) {
      case 'complete_the_chat':
        return const Color(0xFF0077B6);
      case 'tap_the_word':
        return const Color(0xFF7B2FBE);
      case 'listen_and_pick':
        return const Color(0xFFFF6B35);
      default:
        return isSlang ? const Color(0xFF7B1FA2) : AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _color.withAlpha(25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _color.withAlpha(80)),
        ),
        child: Text(
          _label,
          style: GoogleFonts.nunitoSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _color,
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StatChip({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$emoji$value',
          style: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppTheme.zambiaBlack,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B6B6B),
          ),
        ),
      ],
    );
  }
}
