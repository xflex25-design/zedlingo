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
          top: BorderSide(color: const Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: isEnabled ? onCheck : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled
                  ? AppTheme.primary
                  : const Color(0xFFE0E0E0),
              foregroundColor: isEnabled
                  ? Colors.white
                  : const Color(0xFFAFAFAF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'CHECK',
              style: GoogleFonts.nunitoSans(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: isEnabled ? Colors.white : const Color(0xFFAFAFAF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
