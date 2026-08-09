import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeOfflineBannerWidget extends StatelessWidget {
  const HomeOfflineBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFFFF3E0),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, color: AppTheme.warning, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline Mode — Progress saved locally and will sync when back online.',
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF7A4200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
