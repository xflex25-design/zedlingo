import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingMotivationWidget extends StatelessWidget {
  final Set<String> selectedMotivations;
  final ValueChanged<String> onChanged;

  static const List<Map<String, String>> _motivations = [
    {'label': 'Family', 'emoji': '👨‍👩‍👧‍👦'},
    {'label': 'School / Work', 'emoji': '📚'},
    {'label': 'Other Tribes', 'emoji': '🤝'},
    {'label': 'Fun', 'emoji': '🎉'},
    {'label': 'Data Rewards', 'emoji': '📶'},
  ];

  const OnboardingMotivationWidget({
    super.key,
    required this.selectedMotivations,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Why do you want\nto learn?',
          style: GoogleFonts.nunitoSans(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppTheme.zambiaBlack,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '(Select all that apply)',
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            color: const Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(_motivations.length, (index) {
          final item = _motivations[index];
          final label = item['label']!;
          final emoji = item['emoji']!;
          final isSelected = selectedMotivations.contains(label);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onChanged(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withAlpha(26)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary
                        : const Color(0xFFE0E0E0),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.primaryDark
                            : AppTheme.zambiaBlack,
                      ),
                    ),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              key: ValueKey('checked'),
                              color: AppTheme.primary,
                              size: 22,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              key: ValueKey('unchecked'),
                              color: Color(0xFFCCCCCC),
                              size: 22,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }
}
