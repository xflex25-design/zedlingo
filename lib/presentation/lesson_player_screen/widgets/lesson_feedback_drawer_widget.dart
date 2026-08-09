import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LessonFeedbackDrawerWidget extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String culturalNote;
  final int xpEarned;
  final int perfectBonus;
  final Animation<double> slideAnimation;
  final VoidCallback onContinue;

  const LessonFeedbackDrawerWidget({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.culturalNote,
    required this.xpEarned,
    required this.perfectBonus,
    required this.slideAnimation,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isCorrect
        ? const Color(0xFF1A5C00)
        : const Color(0xFF8B1A1A);
    final lightBg = isCorrect
        ? const Color(0xFFEEFBE0)
        : const Color(0xFFFDECEA);
    final accentColor = isCorrect ? AppTheme.primary : AppTheme.error;

    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Transform.translate(
            offset: Offset(0, slideAnimation.value * 300),
            child: child!,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: lightBg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Colored header band
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(38),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/zambian_fish_eagle_mascot.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          semanticLabel:
                              'Zambian Fish Eagle mascot, national bird of Zambia with white head and brown wings',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCorrect ? 'Zabotu! 🎉' : 'Si Zabotu! 😞',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          isCorrect ? 'Correct!' : 'Incorrect',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withAlpha(230),
                          ),
                        ),
                        if (isCorrect) ...[
                          const SizedBox(height: 4),
                          Text(
                            '+$xpEarned MaKopala',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.maKopalaGold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isCorrect) ...[
                    Row(
                      children: [
                        _FeedbackStatChip(
                          label: 'You earned',
                          value: '+$xpEarned',
                          emoji: '🪙',
                          color: AppTheme.maKopalaGold,
                        ),
                        const SizedBox(width: 12),
                        _FeedbackStatChip(
                          label: 'Perfect Bonus!',
                          value: '+$perfectBonus',
                          emoji: '💎',
                          color: const Color(0xFF1976D2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ] else ...[
                    Text(
                      'The correct answer is:',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.error.withAlpha(77)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              correctAnswer,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.zambiaBlack,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.volume_up_outlined,
                            color: AppTheme.error,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.error.withAlpha(77)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('❤️', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            'You lost a life  -1',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Cultural note
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accentColor.withAlpha(77)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: accentColor,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cultural Note',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          culturalNote,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4A4A4A),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackStatChip extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  final Color color;

  const _FeedbackStatChip({
    required this.label,
    required this.value,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B6B6B),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                value,
                style: GoogleFonts.nunitoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
