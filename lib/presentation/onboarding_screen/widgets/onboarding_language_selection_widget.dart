import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingLanguageSelectionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Set<String> selectedLanguages;
  final bool multiSelect;
  final ValueChanged<String> onChanged;

  static const List<String> _languages = [
    'Bemba',
    'Nyanja',
    'Lozi',
    'Tonga',
    'Lunda',
    'Kaonde',
    'Luvale',
    'English',
  ];

  const OnboardingLanguageSelectionWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedLanguages,
    required this.multiSelect,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: GoogleFonts.nunitoSans(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppTheme.zambiaBlack,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            color: const Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(_languages.length, (index) {
          final lang = _languages[index];
          final isSelected = selectedLanguages.contains(lang);
          return _LanguageOptionTile(
            language: lang,
            isSelected: isSelected,
            onTap: () => onChanged(lang),
            index: index,
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _LanguageOptionTile extends StatefulWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const _LanguageOptionTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  State<_LanguageOptionTile> createState() => _LanguageOptionTileState();
}

class _LanguageOptionTileState extends State<_LanguageOptionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTapDown: (_) => _scaleController.reverse(),
        onTapUp: (_) {
          _scaleController.forward();
          widget.onTap();
        },
        onTapCancel: () => _scaleController.forward(),
        child: ScaleTransition(
          scale: _scaleController,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppTheme.primary.withAlpha(20)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isSelected
                    ? AppTheme.primary
                    : const Color(0xFFE0E0E0),
                width: widget.isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? AppTheme.primary
                        : const Color(0xFFE0E0E0),
                    shape: BoxShape.circle,
                  ),
                  child: widget.isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.language,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    fontWeight: widget.isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: widget.isSelected
                        ? AppTheme.primaryDark
                        : AppTheme.zambiaBlack,
                  ),
                ),
                const Spacer(),
                if (widget.isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
