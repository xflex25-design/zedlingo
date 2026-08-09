import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LessonTopBarWidget extends StatelessWidget {
  final double progress;
  final int hearts;
  final int streak;
  final bool isSlangMode;
  final bool isSlangExercise;
  final VoidCallback onClose;
  final VoidCallback onSlangToggle;

  const LessonTopBarWidget({
    super.key,
    required this.progress,
    required this.hearts,
    required this.streak,
    required this.isSlangMode,
    required this.isSlangExercise,
    required this.onClose,
    required this.onSlangToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              // Close button
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF6B6B6B),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Progress bar
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primary,
                    ),
                    minHeight: 10,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Streak
              Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 3),
                  Text(
                    streak.toString(),
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Hearts
              Row(
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 3),
                  Text(
                    hearts.toString(),
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFE74C3C),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Slang mode badge (if slang exercise)
          if (isSlangExercise) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onSlangToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B1FA2).withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF7B1FA2).withAlpha(102),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🗣️', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      'Kopala Street Mode',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6A1B9A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B1FA2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
