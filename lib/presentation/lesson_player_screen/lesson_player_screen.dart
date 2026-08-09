import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../services/sound_service.dart';
import '../../services/zambian_language_data.dart';
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
  bool _showComboOverlay = false;
  bool _showGemDrop = false;
  int _hearts = 5;
  final int _streakCount = 7;
  int _xpEarned = 0;
  bool _isSlangMode = false;
  int _comboCount = 0; // consecutive correct answers
  int _totalGems = 0;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackSlide;
  late AnimationController _mascotController;
  late Animation<double> _mascotBounce;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;
  late AnimationController _xpCounterController;
  late Animation<double> _xpCounterAnim;
  late AnimationController _comboController;
  late Animation<double> _comboScale;
  late AnimationController _gemDropController;
  late Animation<double> _gemDropAnim;
  late AnimationController _progressController;
  late Animation<double> _progressAnim;

  final _sound = SoundService();

  // Use rich exercise data from ZambianLanguageData
  static final List<Map<String, dynamic>> _exercisesMaps = () {
    final bemba = ZambianLanguageData.languages.firstWhere(
      (l) => l.code == 'bemba',
    );
    final unit1 = bemba.units.first;
    final lesson1 = unit1.lessons.first;
    return lesson1.exercises
        .map(
          (e) => {
            'type': e.type,
            'instruction': e.instruction,
            'question': e.question,
            'correct_answer': e.correctAnswer,
            'options': e.options,
            'cultural_note': e.culturalNote ?? '',
            'audio_text': e.audioText ?? '',
            'mascot_message': e.mascotMessage ?? '',
            'word_bank': e.wordBank ?? <String>[],
            'xp_reward': e.xpReward,
            'perfect_bonus': 5,
            'is_slang': false,
          },
        )
        .toList();
  }();

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
    _xpCounterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _xpCounterAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _xpCounterController, curve: Curves.easeOutCubic),
    );
    _comboController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _comboScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _comboController, curve: Curves.elasticOut),
    );
    _gemDropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _gemDropAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _gemDropController, curve: Curves.easeOutCubic),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _progressAnim = Tween<double>(begin: 0, end: _progressValue).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _mascotController.dispose();
    _shakeController.dispose();
    _xpCounterController.dispose();
    _comboController.dispose();
    _gemDropController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _onAnswerSelected(String answer) {
    if (_hasChecked) return;
    HapticFeedback.selectionClick();
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
        _comboCount++;

        // Surprise gem drop on every 2nd correct answer
        if (_comboCount % 2 == 0) {
          _totalGems += 5;
          _showGemDrop = true;
          _gemDropController.forward(from: 0);
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) setState(() => _showGemDrop = false);
          });
        }

        // "You're on fire!" combo at 3+ correct in a row
        if (_comboCount >= 3) {
          _showComboOverlay = true;
          _comboController.forward(from: 0);
          HapticFeedback.heavyImpact();
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (mounted) setState(() => _showComboOverlay = false);
          });
        }
      } else {
        if (_hearts > 0) _hearts--;
        _comboCount = 0; // reset combo on wrong answer
      }
    });

    if (correct) {
      _sound.playCorrect();
      _mascotController.forward(from: 0);
      _xpCounterController.forward(from: 0);
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
      // Animate progress bar
      final nextProgress = (_currentExerciseIndex + 2) / _exercisesMaps.length;
      _progressAnim = Tween<double>(begin: _progressValue, end: nextProgress)
          .animate(
            CurvedAnimation(
              parent: _progressController,
              curve: Curves.easeOutCubic,
            ),
          );
      _progressController.forward(from: 0);

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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A2E1A), Color(0xFF0D1A0D)],
            ),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated medal
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) =>
                    Transform.scale(scale: value, child: child),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFB800).withAlpha(30),
                    border: Border.all(
                      color: const Color(0xFFFFB800),
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Text('🏅', style: TextStyle(fontSize: 52)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Lesson Complete! 🎉',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Mwabomba bwino! (Well done!)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 20),
              // Stats row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.primary.withAlpha(60)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      label: 'XP Earned',
                      value: '+$_xpEarned',
                      emoji: '⭐',
                    ),
                    _StatChip(
                      label: 'Hearts',
                      value: '$_hearts/5',
                      emoji: '❤️',
                    ),
                    _StatChip(
                      label: 'Gems',
                      value: '+$_totalGems',
                      emoji: '💎',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Streak info
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9600).withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      '${_streakCount + 1} day streak!',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFF9600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.pop();
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withAlpha(80),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'CONTINUE',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2F3E),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.share_rounded,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ),
                ],
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
          onAnswerChanged: (answer) => setState(() => _selectedAnswer = answer),
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
      default:
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                      child: _ExerciseTypePill(
                        type: exercise['type'] as String,
                        isSlang: exercise['is_slang'] as bool? ?? false,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _buildExerciseContent(exercise),
                      ),
                    ),
                    LessonCheckButtonWidget(
                      isEnabled: _isCheckEnabled,
                      onCheck: _onCheck,
                    ),
                  ],
                ),
              ),
            ),

            // Feedback drawer
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

            // XP counter pop animation
            if (_isCorrect && _hasChecked)
              _XpCounterPopWidget(
                xp: exercise['xp_reward'] as int,
                animation: _xpCounterAnim,
              ),

            // "You're on fire!" combo overlay
            if (_showComboOverlay)
              _ComboOverlayWidget(
                comboCount: _comboCount,
                scaleAnimation: _comboScale,
              ),

            // Surprise gem drop
            if (_showGemDrop) _GemDropWidget(animation: _gemDropAnim),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DOPAMINE MICRO-INTERACTION WIDGETS
// ============================================================

class _XpCounterPopWidget extends StatelessWidget {
  final int xp;
  final Animation<double> animation;

  const _XpCounterPopWidget({required this.xp, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      right: 24,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, -40 * animation.value),
          child: Opacity(
            opacity: animation.value < 0.8
                ? animation.value / 0.8
                : (1 - animation.value) / 0.2,
            child: child,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB800),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFB800).withAlpha(100),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            '+$xp XP ⭐',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ComboOverlayWidget extends StatelessWidget {
  final int comboCount;
  final Animation<double> scaleAnimation;

  const _ComboOverlayWidget({
    required this.comboCount,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: AnimatedBuilder(
            animation: scaleAnimation,
            builder: (context, child) =>
                Transform.scale(scale: scaleAnimation.value, child: child),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B00).withAlpha(230),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B00).withAlpha(120),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥🔥🔥', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text(
                    "You're on fire!",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$comboCount correct in a row!',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GemDropWidget extends StatelessWidget {
  final Animation<double> animation;

  const _GemDropWidget({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 120,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Opacity(
            opacity: animation.value < 0.7 ? 1.0 : (1 - animation.value) / 0.3,
            child: Transform.translate(
              offset: Offset(0, 60 * animation.value),
              child: child,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1CB0F6),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1CB0F6).withAlpha(100),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💎', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'Surprise! +5 Gems!',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}
