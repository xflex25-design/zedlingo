import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../services/sound_service.dart';

class ListenAndPickWidget extends StatefulWidget {
  final String audioText;
  final List<String> options;
  final String? selectedAnswer;
  final String? correctAnswer;
  final bool hasChecked;
  final ValueChanged<String> onSelected;

  const ListenAndPickWidget({
    super.key,
    required this.audioText,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.hasChecked,
    required this.onSelected,
  });

  @override
  State<ListenAndPickWidget> createState() => _ListenAndPickWidgetState();
}

class _ListenAndPickWidgetState extends State<ListenAndPickWidget>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  bool _hasListened = false;
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  final _sound = SoundService();

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _playAudio() {
    _sound.playTap();
    setState(() {
      _isPlaying = true;
      _hasListened = true;
    });
    _waveController.repeat();
    _pulseController.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isPlaying = false);
        _waveController.stop();
        _waveController.reset();
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
        Text(
          'Listen and pick the translation',
          style: GoogleFonts.nunitoSans(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppTheme.zambiaBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What does this Bemba phrase mean?',
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 28),

        // Big audio button
        Center(
          child: GestureDetector(
            onTap: _playAudio,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isPlaying ? _pulseAnim.value : 1.0,
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _isPlaying
                        ? [AppTheme.primary, AppTheme.zambiaGreen]
                        : [
                            AppTheme.primary.withAlpha(40),
                            AppTheme.primary.withAlpha(20),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(_isPlaying ? 100 : 40),
                      blurRadius: _isPlaying ? 24 : 12,
                      spreadRadius: _isPlaying ? 4 : 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isPlaying
                          ? Icons.graphic_eq_rounded
                          : Icons.volume_up_rounded,
                      color: _isPlaying ? Colors.white : AppTheme.primary,
                      size: 44,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isPlaying ? 'Playing...' : 'TAP TO LISTEN',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _isPlaying ? Colors.white : AppTheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (_hasListened) ...[
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '"${widget.audioText}"',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 28),

        // Options
        ...widget.options.map((option) {
          final isSelected = widget.selectedAnswer == option;
          final isCorrect = widget.hasChecked && option == widget.correctAnswer;
          final isWrong =
              widget.hasChecked && isSelected && option != widget.correctAnswer;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: widget.hasChecked
                  ? null
                  : () {
                      _sound.playTap();
                      widget.onSelected(option);
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppTheme.primary.withAlpha(25)
                      : isWrong
                      ? AppTheme.error.withAlpha(20)
                      : isSelected
                      ? AppTheme.primary.withAlpha(15)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCorrect
                        ? AppTheme.primary
                        : isWrong
                        ? AppTheme.error
                        : isSelected
                        ? AppTheme.primary
                        : const Color(0xFFE0E0E0),
                    width: isSelected || isCorrect || isWrong ? 2 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: AppTheme.zambiaBlack,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.primary,
                        size: 22,
                      ),
                    if (isWrong)
                      const Icon(
                        Icons.cancel_rounded,
                        color: AppTheme.error,
                        size: 22,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
