import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeLaguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onChanged;

  static const List<String> _languages = [
    'Bemba',
    'Nyanja',
    'Lozi',
    'Tonga',
    'Lunda',
    'Kaonde',
    'Luvale',
  ];

  const HomeLaguageSelectorWidget({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌍', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Learning:',
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B6B6B),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primary.withAlpha(102)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLanguage,
                isDense: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.primary,
                  size: 18,
                ),
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
                items: _languages
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
              ),
            ),
          ),
          const Spacer(),
          // Slang mode toggle
          _SlangModeToggle(),
        ],
      ),
    );
  }
}

class _SlangModeToggle extends StatefulWidget {
  @override
  State<_SlangModeToggle> createState() => _SlangModeToggleState();
}

class _SlangModeToggleState extends State<_SlangModeToggle> {
  // TODO: Replace with Riverpod/Bloc for production
  bool _slangMode = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _slangMode = !_slangMode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _slangMode
              ? const Color(0xFF7B1FA2).withAlpha(31)
              : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _slangMode
                ? const Color(0xFF7B1FA2)
                : const Color(0xFFCCCCCC),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _slangMode ? '🗣️' : '📖',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              _slangMode ? 'Kopala' : 'Standard',
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _slangMode
                    ? const Color(0xFF6A1B9A)
                    : const Color(0xFF6B6B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
