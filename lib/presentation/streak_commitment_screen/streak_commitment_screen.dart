import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class StreakCommitmentScreen extends StatefulWidget {
  const StreakCommitmentScreen({super.key});

  @override
  State<StreakCommitmentScreen> createState() => _StreakCommitmentScreenState();
}

class _StreakCommitmentScreenState extends State<StreakCommitmentScreen>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late AnimationController _flameController;
  late AnimationController _numberController;
  late AnimationController _buttonController;
  late AnimationController _bgController;

  late Animation<double> _mascotBounce;
  late Animation<double> _flamePulse;
  late Animation<double> _numberScale;
  late Animation<double> _buttonScale;
  late Animation<double> _bgAnim;

  final int _streakDays = 1;
  final List<String> _weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  final int _completedDayIndex = 0;

  @override
  void initState() {
    super.initState();

    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _mascotBounce = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeInOut),
    );

    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _flamePulse = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _flameController, curve: Curves.easeInOut),
    );

    _numberController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _numberScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _numberController, curve: Curves.elasticOut),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _numberController.forward();
    });

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _bgAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _flameController.dispose();
    _numberController.dispose();
    _buttonController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _onCommit() {
    HapticFeedback.mediumImpact();
    _buttonController.forward().then((_) {
      _buttonController.reverse().then((_) {
        context.push(AppRoutes.streakGoalScreen);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnim,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(
                    const Color(0xFFFF6B00),
                    const Color(0xFFFF9600),
                    _bgAnim.value,
                  )!,
                  Color.lerp(
                    const Color(0xFFFF4500),
                    const Color(0xFFFF6B00),
                    _bgAnim.value,
                  )!,
                  const Color(0xFF1A0A00),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
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
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withAlpha(40)),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Zambia flag badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withAlpha(40)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🇿🇲', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            'Zedlingo',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Speech bubble
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        'Mungapanga nsiku yonse? 🦅\nCan you practice every day?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.zambiaBlack,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Speech bubble tail
                    Center(
                      child: CustomPaint(
                        size: const Size(20, 12),
                        painter: _BubbleTailPainter(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Mascot with flame
                    AnimatedBuilder(
                      animation: _mascotBounce,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _mascotBounce.value),
                        child: child,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow ring
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withAlpha(30),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Flame
                          AnimatedBuilder(
                            animation: _flamePulse,
                            builder: (context, child) => Transform.scale(
                              scale: _flamePulse.value,
                              child: child,
                            ),
                            child: const Text(
                              '🔥',
                              style: TextStyle(fontSize: 90),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withAlpha(100),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withAlpha(40),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/zambian_fish_eagle_mascot.png',
                                  fit: BoxFit.cover,
                                  semanticLabel:
                                      'Zam-Eagle mascot sitting on a flame streak icon, Zambian Fish Eagle national bird',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Streak number
                    AnimatedBuilder(
                      animation: _numberScale,
                      builder: (context, child) => Transform.scale(
                        scale: _numberScale.value,
                        child: child,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$_streakDays',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 88,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withAlpha(60),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'day streak 🔥',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withAlpha(220),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Weekly calendar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withAlpha(40)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _weekDays.map((day) {
                                final isCompleted =
                                    _weekDays.indexOf(day) ==
                                    _completedDayIndex;
                                return Text(
                                  day,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isCompleted
                                        ? Colors.white
                                        : Colors.white.withAlpha(120),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(_weekDays.length, (
                                index,
                              ) {
                                final isCompleted = index == _completedDayIndex;
                                return Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isCompleted
                                        ? const LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Color(0xFFFFF0D0),
                                            ],
                                          )
                                        : null,
                                    color: isCompleted
                                        ? null
                                        : Colors.white.withAlpha(20),
                                    border: Border.all(
                                      color: isCompleted
                                          ? Colors.white
                                          : Colors.white.withAlpha(40),
                                      width: 1.5,
                                    ),
                                    boxShadow: isCompleted
                                        ? [
                                            BoxShadow(
                                              color: Colors.white.withAlpha(60),
                                              blurRadius: 10,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: isCompleted
                                        ? const Text(
                                            '🔥',
                                            style: TextStyle(fontSize: 16),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _buttonScale,
                      builder: (context, child) => Transform.scale(
                        scale: _buttonScale.value,
                        child: child,
                      ),
                      child: GestureDetector(
                        onTap: _onCommit,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(40),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            'Eya! I\'m committed! 🦅',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.streakOrange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'Not now',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withAlpha(180),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
