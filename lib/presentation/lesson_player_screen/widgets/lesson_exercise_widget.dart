import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LessonExerciseWidget extends StatefulWidget {
  final String instruction;
  final String question;
  final bool isSlang;

  const LessonExerciseWidget({
    super.key,
    required this.instruction,
    required this.question,
    required this.isSlang,
  });

  @override
  State<LessonExerciseWidget> createState() => _LessonExerciseWidgetState();
}

class _LessonExerciseWidgetState extends State<LessonExerciseWidget>
    with SingleTickerProviderStateMixin {
  bool _isPlayingAudio = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _playAudio() {
    setState(() => _isPlayingAudio = true);
    _pulseController.repeat(reverse: true);
    // TODO: Replace with real TTS audio playback
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isPlayingAudio = false);
        _pulseController.stop();
        _pulseController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instruction
        Row(
          children: [
            Text(
              widget.instruction,
              style: GoogleFonts.nunitoSans(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.zambiaBlack,
              ),
            ),
            if (widget.isSlang) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B1FA2).withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF7B1FA2).withAlpha(77),
                  ),
                ),
                child: Text(
                  'Kopala',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6A1B9A),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        // Question card with audio
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.question,
                style: GoogleFonts.nunitoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.zambiaBlack,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Audio button
              GestureDetector(
                onTap: _playAudio,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isPlayingAudio ? _pulseAnimation.value : 1.0,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _isPlayingAudio
                          ? AppTheme.primary
                          : AppTheme.primary.withAlpha(26),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primary.withAlpha(102),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _isPlayingAudio
                          ? Icons.volume_up_rounded
                          : Icons.volume_up_outlined,
                      color: _isPlayingAudio ? Colors.white : AppTheme.primary,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
