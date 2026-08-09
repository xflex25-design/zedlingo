import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../services/sound_service.dart';

class TapTheWordWidget extends StatefulWidget {
  final String instruction;
  final String question;
  final List<String> wordBank;
  final String correctAnswer;
  final bool hasChecked;
  final ValueChanged<String> onAnswerChanged;

  const TapTheWordWidget({
    super.key,
    required this.instruction,
    required this.question,
    required this.wordBank,
    required this.correctAnswer,
    required this.hasChecked,
    required this.onAnswerChanged,
  });

  @override
  State<TapTheWordWidget> createState() => _TapTheWordWidgetState();
}

class _TapTheWordWidgetState extends State<TapTheWordWidget>
    with SingleTickerProviderStateMixin {
  final List<String> _selectedWords = [];
  final _sound = SoundService();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _addWord(String word) {
    if (widget.hasChecked) return;
    _sound.playTap();
    setState(() => _selectedWords.add(word));
    widget.onAnswerChanged(_selectedWords.join(' '));
  }

  void _removeWord(int index) {
    if (widget.hasChecked) return;
    _sound.playTap();
    setState(() => _selectedWords.removeAt(index));
    widget.onAnswerChanged(_selectedWords.join(' '));
  }

  bool _isWordUsed(String word) {
    final count = _selectedWords.where((w) => w == word).length;
    final bankCount = widget.wordBank.where((w) => w == word).length;
    return count >= bankCount;
  }

  bool get _isCorrect => _selectedWords.join(' ') == widget.correctAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instruction
        Text(
          widget.instruction,
          style: GoogleFonts.nunitoSans(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppTheme.zambiaBlack,
          ),
        ),
        const SizedBox(height: 16),

        // Question card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.question,
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.zambiaBlack,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 24),

        // Answer area (selected words)
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.hasChecked
                ? (_isCorrect
                      ? AppTheme.primary.withAlpha(20)
                      : AppTheme.error.withAlpha(15))
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.hasChecked
                  ? (_isCorrect ? AppTheme.primary : AppTheme.error)
                  : const Color(0xFFDDDDDD),
              width: widget.hasChecked ? 2 : 1,
            ),
          ),
          child: _selectedWords.isEmpty
              ? Center(
                  child: Text(
                    'Tap words below to build your answer',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      color: const Color(0xFFAFAFAF),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_selectedWords.length, (index) {
                    return GestureDetector(
                      onTap: () => _removeWord(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: widget.hasChecked
                              ? (_isCorrect ? AppTheme.primary : AppTheme.error)
                              : AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withAlpha(60),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _selectedWords[index],
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
        ),

        const SizedBox(height: 8),
        if (!widget.hasChecked && _selectedWords.isNotEmpty)
          Center(
            child: Text(
              'Tap a word to remove it',
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                color: const Color(0xFFAFAFAF),
              ),
            ),
          ),

        const SizedBox(height: 20),

        // Word bank
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: widget.wordBank.map((word) {
              final used = _isWordUsed(word);
              return GestureDetector(
                onTap: used || widget.hasChecked ? null : () => _addWord(word),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: used ? const Color(0xFFF0F0F0) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: used
                          ? const Color(0xFFDDDDDD)
                          : const Color(0xFFCCCCCC),
                      width: 1.5,
                    ),
                    boxShadow: used
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withAlpha(15),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    word,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: used
                          ? const Color(0xFFCCCCCC)
                          : AppTheme.zambiaBlack,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
