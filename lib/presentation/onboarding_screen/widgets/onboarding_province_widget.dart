import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingProvinceWidget extends StatelessWidget {
  final String selectedProvince;
  final ValueChanged<String> onChanged;

  static const List<String> _provinces = [
    'Lusaka',
    'Copperbelt',
    'Eastern',
    'Southern',
    'Northern',
    'Western',
    'Northwestern',
    'Luapula',
    'Muchinga',
    'Central',
  ];

  const OnboardingProvinceWidget({
    super.key,
    required this.selectedProvince,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Which Province\nare you from?',
          style: GoogleFonts.nunitoSans(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppTheme.zambiaBlack,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '(Select your province)',
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            color: const Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 24),
        // Province image placeholder
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF1A5C00), Color(0xFF58CC02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🗺️', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(
                      'Zambia',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(102),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedProvince,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCCCCCC)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedProvince,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6B6B6B),
              ),
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.zambiaBlack,
              ),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
              items: _provinces
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
