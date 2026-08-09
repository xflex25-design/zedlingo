import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../services/sound_service.dart';

class CompleteTheChatWidget extends StatefulWidget {
  final String mascotMessage;
  final List<String> options;
  final String? selectedAnswer;
  final String? correctAnswer;
  final bool hasChecked;
  final ValueChanged<String> onSelected;

  const CompleteTheChatWidget({
    super.key,
    required this.mascotMessage,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.hasChecked,
    required this.onSelected,
  });

  @override
  State<CompleteTheChatWidget> createState() => _CompleteTheChatWidgetState();
}

class _CompleteTheChatWidgetState extends State<CompleteTheChatWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnim;
  bool _isPlayingAudio = false;
  final _sound = SoundService();

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bubbleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeOutBack),
    );
    _bubbleController.forward();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  void _playAudio() {
    _sound.playTap();
    setState(() => _isPlayingAudio = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isPlayingAudio = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Complete the chat',
          style: GoogleFonts.nunitoSans(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppTheme.zambiaBlack,
          ),
        ),
        const SizedBox(height: 24),

        // Chat area
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Mascot message (left side)
              ScaleTransition(
                scale: _bubbleAnim,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Eagle avatar
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(100),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/zambian_fish_eagle_mascot.png',
                          fit: BoxFit.cover,
                          semanticLabel:
                              'Zam-Eagle mascot speaking in the chat exercise',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4FF),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border.all(color: const Color(0xFFD0D8FF)),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _playAudio,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _isPlayingAudio
                                      ? AppTheme.primary
                                      : AppTheme.primary.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: _isPlayingAudio
                                      ? Colors.white
                                      : AppTheme.primary,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.mascotMessage,
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.zambiaBlack,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // User response bubble (right side)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: widget.selectedAnswer != null
                            ? (widget.hasChecked
                                  ? (widget.selectedAnswer ==
                                            widget.correctAnswer
                                        ? AppTheme.primary.withAlpha(30)
                                        : AppTheme.error.withAlpha(20))
                                  : AppTheme.primary.withAlpha(20))
                            : const Color(0xFFF5F5F5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(4),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        border: Border.all(
                          color: widget.selectedAnswer != null
                              ? (widget.hasChecked
                                    ? (widget.selectedAnswer ==
                                              widget.correctAnswer
                                          ? AppTheme.primary
                                          : AppTheme.error)
                                    : AppTheme.primary)
                              : const Color(0xFFDDDDDD),
                          width: widget.selectedAnswer != null ? 2 : 1,
                        ),
                      ),
                      child: widget.selectedAnswer != null
                          ? Text(
                              widget.selectedAnswer!,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.zambiaBlack,
                              ),
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCCCCCC),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // User avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.zambiaOrange, AppTheme.zambiaRed],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text('👤', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Answer options
        ...widget.options.map((option) {
          final isSelected = widget.selectedAnswer == option;
          final isCorrect = widget.hasChecked && option == widget.correctAnswer;
          final isWrong =
              widget.hasChecked && isSelected && option != widget.correctAnswer;

          Color borderColor = const Color(0xFFDDDDDD);
          Color bgColor = Colors.white;
          if (isSelected && !widget.hasChecked) {
            borderColor = AppTheme.primary;
            bgColor = AppTheme.primary.withAlpha(15);
          } else if (isCorrect) {
            borderColor = AppTheme.primary;
            bgColor = AppTheme.primary.withAlpha(20);
          } else if (isWrong) {
            borderColor = AppTheme.error;
            bgColor = AppTheme.error.withAlpha(15);
          }

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
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: borderColor,
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
                          fontSize: 15,
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
