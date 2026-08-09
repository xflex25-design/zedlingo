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
          colors: [Color(0xFF0F3D00), Color(0xFF1A5C00), Color(0xFF58CC02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Column(
            children: [
              // Top row: Logo + notification + avatar
              Row(
                children: [
                  // Premium logo
                  _buildLogo(),
                  const Spacer(),
                  // Notification bell
                  _buildIconButton(Icons.notifications_outlined),
                  const SizedBox(width: 10),
                  // Avatar
                  _buildAvatar(),
                ],
              ),
              const SizedBox(height: 16),
              // Stats row
              _buildStatsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withAlpha(60), width: 1),
          ),
          child: Center(
            child: Text('🦅', style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Zed',
                style: GoogleFonts.dmSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'lingo',
                style: GoogleFonts.dmSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.zambiaOrange,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(50), width: 1),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(180), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/zambian_fish_eagle_mascot.png',
          width: 34,
          height: 34,
          fit: BoxFit.cover,
          semanticLabel: 'Zambian Fish Eagle mascot avatar',
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _StatChip(
          emoji: '🔥',
          value: moto.toString(),
          label: 'Moto',
          color: const Color(0xFFFF6B35),
        ),
        const SizedBox(width: 10),
        _StatChip(
          emoji: '🪙',
          value: maKopala.toString(),
          label: 'MaKopala',
          color: AppTheme.maKopalaGold,
        ),
        const SizedBox(width: 10),
        _StatChip(
          emoji: '❤️',
          value: maLives.toString(),
          label: 'Lives',
          color: const Color(0xFFE74C3C),
        ),
      ],
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(22),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withAlpha(50), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(190),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
