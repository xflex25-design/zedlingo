import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../services/tts_service.dart';

class OnboardingLanguageSelectionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Set<String> selectedLanguages;
  final bool multiSelect;
  final ValueChanged<String> onChanged;

  static const List<Map<String, String>> _languages = [
    {'name': 'Bemba', 'native': 'Ichibemba', 'greeting': 'Mwashibukeni', 'code': 'bemba'},
    {'name': 'Nyanja', 'native': 'Chinyanja', 'greeting': 'Muli bwanji', 'code': 'nyanja'},
    {'name': 'Tonga', 'native': 'Chitonga', 'greeting': 'Mwabuka biyani', 'code': 'tonga'},
    {'name': 'Lozi', 'native': 'Silozi', 'greeting': 'Muli cwang\'i', 'code': 'lozi'},
    {'name': 'Lunda', 'native': 'Chilunda', 'greeting': 'Eneyi hinyi', 'code': 'lunda'},
    {'name': 'Kaonde', 'native': 'Chikaonde', 'greeting': 'Mwaji byepi', 'code': 'kaonde'},
    {'name': 'Luvale', 'native': 'Chiluvale', 'greeting': 'Muno ngachili', 'code': 'luvale'},
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
          final langMap = _languages[index];
          final lang = langMap['name']!;
          final isSelected = selectedLanguages.contains(lang);
          return _LanguageOptionTile(
            language: lang,
            nativeName: langMap['native']!,
            greeting: langMap['greeting']!,
            languageCode: langMap['code']!,
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
  final String nativeName;
  final String greeting;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const _LanguageOptionTile({
    required this.language,
    required this.nativeName,
    required this.greeting,
    required this.languageCode,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.language,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 15,
                          fontWeight: widget.isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: widget.isSelected
                              ? AppTheme.primaryDark
                              : AppTheme.zambiaBlack,
                        ),
                      ),
                      Text(
                        '${widget.nativeName} • "${widget.greeting}"',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 11,
                          color: const Color(0xFF888888),
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    TTSService().speak(widget.greeting, languageCode: widget.languageCode);
                  },
                  icon: Icon(
                    Icons.volume_up_rounded,
                    color: widget.isSelected ? AppTheme.primary : const Color(0xFF888888),
                    size: 20,
                  ),
                  tooltip: 'Listen to greeting',
                ),
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
