import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class CelebrationOverlayWidget extends StatefulWidget {
  final int xpEarned;
  final VoidCallback onDismiss;

  const CelebrationOverlayWidget({
    super.key,
    required this.xpEarned,
    required this.onDismiss,
  });

  @override
  State<CelebrationOverlayWidget> createState() =>
      _CelebrationOverlayWidgetState();
}

class _CelebrationOverlayWidgetState extends State<CelebrationOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: const Interval(0.7, 1.0),
      ),
    );

    // Generate particles
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(i));
    }

    _scaleController.forward();
    _particleController.forward();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return Stack(
              children: [
                // Particles
                ..._particles.map((p) {
                  final t = _particleController.value;
                  final x =
                      p.startX +
                      p.velocityX * t * MediaQuery.of(context).size.width;
                  final y =
                      p.startY +
                      p.velocityY * t * MediaQuery.of(context).size.height -
                      0.5 * 9.8 * t * t * 200;
                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: (1.0 - t).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: t * p.rotation * 6.28,
                        child: Container(
                          width: p.size,
                          height: p.size,
                          decoration: BoxDecoration(
                            color: p.color,
                            borderRadius: BorderRadius.circular(p.size / 4),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // XP badge
                Center(
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withAlpha(80),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🎉', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 8),
                          Text(
                            'Zabotu!',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(
                            '+${widget.xpEarned} MaKopala',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.maKopalaGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Particle {
  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final double size;
  final Color color;
  final double rotation;

  static const List<Color> _colors = [
    AppTheme.primary,
    AppTheme.maKopalaGold,
    AppTheme.zambiaOrange,
    AppTheme.zambiaRed,
    Color(0xFF7B2FBE),
    Color(0xFF0077B6),
  ];

  _Particle(int seed)
    : startX = (seed * 37.5) % 350 + 10,
      startY = 200 + (seed * 23) % 100,
      velocityX = ((seed % 5) - 2) * 0.08,
      velocityY = -0.3 - (seed % 4) * 0.1,
      size = 8.0 + (seed % 6) * 2.0,
      color = _colors[seed % _colors.length],
      rotation = (seed % 3) * 0.5 + 0.5;
}