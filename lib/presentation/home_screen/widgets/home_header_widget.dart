import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeHeaderWidget extends StatelessWidget {
  final int moto;
  final int maKopala;
  final int maLives;

  const HomeHeaderWidget({
    super.key,
    required this.moto,
    required this.maKopala,
    required this.maLives,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryDark, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              // Top row: Logo + notification + avatar
              Row(
                children: [
                  // Logo
                  Row(
                    children: [
                      Text(
                        'ZED',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'LINGO',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.zambiaOrange,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Notification bell
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Avatar
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withAlpha(128),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/zambian_fish_eagle_mascot.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          semanticLabel:
                              'Zambian Fish Eagle mascot, national bird of Zambia',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Stats row: Moto | MaKopala | Ma Lives
              Row(
                children: [
                  _StatChip(
                    emoji: '🔥',
                    value: moto.toString(),
                    label: 'Moto',
                    color: const Color(0xFFFF6B35),
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    emoji: '🪙',
                    value: maKopala.toString(),
                    label: 'MaKopala',
                    color: AppTheme.maKopalaGold,
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    emoji: '❤️',
                    value: maLives.toString(),
                    label: 'Ma Lives',
                    color: const Color(0xFFE74C3C),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(46),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 5),
          Text(
            value,
            style: GoogleFonts.nunitoSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }
}
