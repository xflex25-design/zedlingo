import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingWelcomeWidget extends StatefulWidget {
  const OnboardingWelcomeWidget({super.key});

  @override
  State<OnboardingWelcomeWidget> createState() =>
      _OnboardingWelcomeWidgetState();
}

class _OnboardingWelcomeWidgetState extends State<OnboardingWelcomeWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _staggerController;
  late AnimationController _orbController;
  late AnimationController _pulseController;

  late Animation<double> _floatAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _orbAnim;
  late Animation<double> _pulseAnim;

  // Staggered entry animations
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _mascotFade;
  late Animation<Offset> _mascotSlide;
  late Animation<double> _taglineFade;
  late Animation<double> _chipsFade;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: -14).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
    _orbAnim = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _orbController, curve: Curves.linear));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
          ),
        );
    _mascotFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    _mascotSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
          ),
        );
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );
    _chipsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _shimmerController.dispose();
    _staggerController.dispose();
    _orbController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        // Hero card
        SlideTransition(
          position: _logoSlide,
          child: FadeTransition(opacity: _logoFade, child: _buildHeroCard()),
        ),
        const SizedBox(height: 24),
        // Welcome text
        FadeTransition(opacity: _taglineFade, child: _buildWelcomeText()),
        const SizedBox(height: 20),
        // Language chips
        FadeTransition(opacity: _chipsFade, child: _buildLanguageChips()),
        const SizedBox(height: 24),
        // Stats row
        FadeTransition(opacity: _chipsFade, child: _buildStatsRow()),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3D00), Color(0xFF1A5C00), Color(0xFF2E8B00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(100),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Animated orb background
            AnimatedBuilder(
              animation: _orbAnim,
              builder: (context, child) {
                return Positioned(
                  top: -40 + 20 * math.sin(_orbAnim.value),
                  right: -40 + 15 * math.cos(_orbAnim.value),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(15),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _orbAnim,
              builder: (context, child) {
                return Positioned(
                  bottom: -30 + 15 * math.cos(_orbAnim.value + 1),
                  left: -30 + 20 * math.sin(_orbAnim.value + 2),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.zambiaOrange.withAlpha(35),
                    ),
                  ),
                );
              },
            ),
            // Zambia flag accent strip on right
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.zambiaGreen,
                      AppTheme.zambiaRed,
                      AppTheme.zambiaBlack,
                      AppTheme.zambiaOrange,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 34, 24),
              child: Column(
                children: [
                  // Logo with shimmer
                  _buildShimmerLogo(),
                  const SizedBox(height: 6),
                  Text(
                    'Learn Zambian Languages the Fun Way',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withAlpha(210),
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  // Floating mascot
                  SlideTransition(
                    position: _mascotSlide,
                    child: FadeTransition(
                      opacity: _mascotFade,
                      child: AnimatedBuilder(
                        animation: _floatAnim,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnim.value),
                            child: child,
                          );
                        },
                        child: _buildMascot(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Zambian badge
                  _buildZambianBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLogo() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white.withAlpha(200),
                Colors.white,
                Colors.white.withAlpha(200),
              ],
              stops: [
                (_shimmerAnim.value - 0.5).clamp(0.0, 1.0),
                _shimmerAnim.value.clamp(0.0, 1.0),
                (_shimmerAnim.value + 0.5).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child!,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withAlpha(60)),
            ),
            child: const Center(
              child: Text('🦅', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Zed',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'lingo',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.zambiaOrange,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascot() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) =>
          Transform.scale(scale: _pulseAnim.value, child: child),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow ring
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primary.withAlpha(60),
                  AppTheme.primary.withAlpha(0),
                ],
              ),
            ),
          ),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(80), width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withAlpha(80),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/zambian_fish_eagle_mascot.png',
                fit: BoxFit.cover,
                semanticLabel:
                    'Zam-Eagle mascot, Zambian Fish Eagle with white head and brown wings, national bird of Zambia, perched proudly',
              ),
            ),
          ),
          // Floating badge
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.zambiaOrange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.zambiaOrange.withAlpha(80),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Text('🇿🇲', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZambianBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🇿🇲', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            'Zambia\'s #1 Language App',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Text('🦅', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Mwaiseni ku ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.zambiaBlack,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: 'Zedlingo',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: '! 🦅',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.zambiaBlack,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Master Bemba, Nyanja, Tonga & more\nwith fun daily lessons',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: const Color(0xFF666666),
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLanguageChips() {
    final languages = [
      {'emoji': '🇿🇲', 'name': 'Bemba', 'color': const Color(0xFF198A00)},
      {'emoji': '🇿🇲', 'name': 'Nyanja', 'color': const Color(0xFF1CB0F6)},
      {'emoji': '🇿🇲', 'name': 'Tonga', 'color': const Color(0xFFFF8C00)},
      {'emoji': '🇿🇲', 'name': 'Lozi', 'color': const Color(0xFFDE2010)},
      {'emoji': '🇿🇲', 'name': 'Lunda', 'color': const Color(0xFF7B2FBE)},
      {'emoji': '🇿🇲', 'name': 'Kaonde', 'color': const Color(0xFFFF6B35)},
      {'emoji': '🇿🇲', 'name': 'Luvale', 'color': const Color(0xFF0077B6)},
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: languages.map((lang) {
        final color = lang['color'] as Color;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha(18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(80)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang['emoji'] as String,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 5),
              Text(
                lang['name'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'icon': '🌍', 'value': '7', 'label': 'Languages'},
      {'icon': '📚', 'value': '500+', 'label': 'Lessons'},
      {'icon': '🆓', 'value': 'Free', 'label': 'Always'},
    ];
    return Row(
      children: stats.asMap().entries.map((entry) {
        final stat = entry.value;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: entry.key == 0 ? 0 : 6,
              right: entry.key == 2 ? 0 : 6,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  stat['icon'] as String,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['value'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  stat['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: const Color(0xFF888888),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
