import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class StreakGoalScreen extends StatefulWidget {
  const StreakGoalScreen({super.key});

  @override
  State<StreakGoalScreen> createState() => _StreakGoalScreenState();
}

class _StreakGoalScreenState extends State<StreakGoalScreen>
    with TickerProviderStateMixin {
  int? _selectedGoalIndex;

  late AnimationController _mascotController;
  late AnimationController _confettiController;
  late AnimationController _buttonController;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;

  late Animation<double> _mascotBounce;
  late Animation<double> _buttonScale;

  static const List<Map<String, dynamic>> _goals = [
    {
      'days': 7,
      'gems': 35,
      'label': '7 days',
      'emoji': '🌱',
      'color': Color(0xFF58CC02),
    },
    {
      'days': 14,
      'gems': 140,
      'label': '14 days',
      'emoji': '🌿',
      'color': Color(0xFF1CB0F6),
    },
    {
      'days': 30,
      'gems': 210,
      'label': '30 days',
      'emoji': '🌳',
      'color': Color(0xFFFF9600),
    },
    {
      'days': 50,
      'gems': 350,
      'label': '50 days',
      'emoji': '🏆',
      'color': Color(0xFFFF4B4B),
    },
  ];

  @override
  void initState() {
    super.initState();

    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _mascotBounce = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeInOut),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _cardControllers = List.generate(
      _goals.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _cardAnimations = _cardControllers.map((c) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic));
    }).toList();

    // Stagger card entrance
    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 + i * 100), () {
        if (mounted) _cardControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _confettiController.dispose();
    _buttonController.dispose();
    for (final c in _cardControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectGoal(int index) {
    HapticFeedback.selectionClick();
    setState(() => _selectedGoalIndex = index);
    _confettiController.forward(from: 0);
  }

  void _onCommitToGoal() {
    if (_selectedGoalIndex == null) return;
    HapticFeedback.mediumImpact();
    _buttonController.forward().then((_) {
      _buttonController.reverse().then((_) {
        _showGoalCommittedDialog();
      });
    });
  }

  void _showGoalCommittedDialog() {
    final goal = _goals[_selectedGoalIndex!];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1A1F2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                goal['emoji'] as String,
                style: const TextStyle(fontSize: 56),
              ),
              const SizedBox(height: 12),
              Text(
                'Goal Set! 🎉',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${goal['days']}-day streak goal committed!\nEarn ${goal['gems']} 💎 gems when you complete it!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.go(AppRoutes.homeScreen);
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF58CC02), Color(0xFF2E8B00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
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
                      "LET'S GO! 🦅",
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2F3E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white60,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Speech bubble
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2F3E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        "Let's commit to learning\nwith a Streak Goal! 🇿🇲",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: CustomPaint(
                        size: const Size(20, 12),
                        painter: _BubbleTailPainter(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Mascot + Calendar illustration
                    AnimatedBuilder(
                      animation: _mascotBounce,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _mascotBounce.value),
                        child: child,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Flame calendar
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B00),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF3D00),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 6,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 62,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '7',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFFFF3D00),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Mascot overlapping
                          Positioned(
                            right: -10,
                            bottom: 0,
                            child: Image.asset(
                              'assets/images/zambian_fish_eagle_mascot.png',
                              width: 70,
                              height: 70,
                              fit: BoxFit.contain,
                              semanticLabel:
                                  'Zam-Eagle mascot peeking at a flame calendar showing streak goal selection',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Goal cards
                    ...List.generate(_goals.length, (index) {
                      final goal = _goals[index];
                      final isSelected = _selectedGoalIndex == index;
                      return AnimatedBuilder(
                        animation: _cardAnimations[index],
                        builder: (context, child) => Transform.translate(
                          offset: Offset(
                            0,
                            30 * (1 - _cardAnimations[index].value),
                          ),
                          child: Opacity(
                            opacity: _cardAnimations[index].value,
                            child: child,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => _selectGoal(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (goal['color'] as Color).withAlpha(40)
                                  : const Color(0xFF2A2F3E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? (goal['color'] as Color)
                                    : Colors.white12,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  goal['emoji'] as String,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    goal['label'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Earn ${goal['gems']} gems',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: isSelected
                                            ? (goal['color'] as Color)
                                            : Colors.white54,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      '💎',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: goal['color'] as Color,
                                    size: 22,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // COMMIT TO MY GOAL button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: AnimatedBuilder(
                animation: _buttonScale,
                builder: (context, child) =>
                    Transform.scale(scale: _buttonScale.value, child: child),
                child: GestureDetector(
                  onTap: _selectedGoalIndex != null ? _onCommitToGoal : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _selectedGoalIndex != null
                          ? AppTheme.primary
                          : const Color(0xFF2A2F3E),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _selectedGoalIndex != null
                          ? [
                              BoxShadow(
                                color: AppTheme.primary.withAlpha(80),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        'COMMIT TO MY GOAL',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: _selectedGoalIndex != null
                              ? Colors.white
                              : Colors.white38,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A2F3E)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
