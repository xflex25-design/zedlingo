import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LessonCheckButtonWidget extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onCheck;

  const LessonCheckButtonWidget({
    super.key,
    required this.isEnabled,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        border: Border(
          top: BorderSide(color: const Color(0xFFE8E8E8), width: 1),
        ),
      ),
      child: GestureDetector(
        onTap: isEnabled ? onCheck : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: isEnabled
                ? const LinearGradient(
                    colors: [Color(0xFF58CC02), Color(0xFF2E8B00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isEnabled ? null : const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(80),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              'CHECK',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: isEnabled ? Colors.white : const Color(0xFFBBBBBB),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
