import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LessonAnswerOptionsWidget extends StatelessWidget {
  final List<String> options;
  final String? selectedAnswer;
  final String? correctAnswer;
  final bool hasChecked;
  final ValueChanged<String> onSelected;

  const LessonAnswerOptionsWidget({
    super.key,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.hasChecked,
    required this.onSelected,
  });

  Color _getBorderColor(String option) {
    if (!hasChecked) {
      return selectedAnswer == option
          ? AppTheme.primary
          : const Color(0xFFE0E0E0);
    }
    if (option == correctAnswer) return AppTheme.primary;
    if (option == selectedAnswer && option != correctAnswer) {
      return AppTheme.error;
    }
    return const Color(0xFFE0E0E0);
  }

  Color _getBackgroundColor(String option) {
    if (!hasChecked) {
      return selectedAnswer == option
          ? AppTheme.primary.withAlpha(20)
          : Colors.white;
    }
    if (option == correctAnswer) return AppTheme.primary.withAlpha(26);
    if (option == selectedAnswer && option != correctAnswer) {
      return AppTheme.error.withAlpha(20);
    }
    return Colors.white;
  }

  Widget? _getTrailingIcon(String option) {
    if (!hasChecked) return null;
    if (option == correctAnswer) {
      return const Icon(
        Icons.check_circle_rounded,
        color: AppTheme.primary,
        size: 22,
      );
    }
    if (option == selectedAnswer && option != correctAnswer) {
      return const Icon(Icons.cancel_rounded, color: AppTheme.error, size: 22);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: hasChecked ? null : () => onSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(option),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _getBorderColor(option),
                  width: selectedAnswer == option || option == correctAnswer
                      ? 2
                      : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
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
                        fontWeight: selectedAnswer == option
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: AppTheme.zambiaBlack,
                      ),
                    ),
                  ),
                  if (_getTrailingIcon(option) != null)
                    _getTrailingIcon(option)!,
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
