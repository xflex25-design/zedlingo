import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../services/sound_service.dart';

class AchievementPreviewScreen extends StatefulWidget {
  const AchievementPreviewScreen({super.key});

  @override
  State<AchievementPreviewScreen> createState() =>
      _AchievementPreviewScreenState();
}

class _AchievementPreviewScreenState extends State<AchievementPreviewScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _itemsController;
  late AnimationController _mascotController;
  late Animation<double> _progressAnim;
  late Animation<double> _mascotBounce;

  final _sound = SoundService();

  static const List<_AchievementItem> _items = [
    _AchievementItem(
      emoji: '🗣️',
      color: Color(0xFF7B2FBE),
      bgColor: Color(0xFFF3E8FF),
      title: 'Converse with confidence',
      subtitle: 'Greet elders, bargain at Soweto Market & chat in Bemba',
    ),
    _AchievementItem(
      emoji: '📖',
      color: Color(0xFF0077B6),
      bgColor: Color(0xFFE0F2FE),
      title: 'Build your Zambian vocabulary',
      subtitle: 'Common words, Kopala slang & practical market phrases',
    ),
    _AchievementItem(
      emoji: '🔥',
      color: Color(0xFFFF6B35),
      bgColor: Color(0xFFFFF0E8),
      title: 'Develop a daily Moto streak',
      subtitle: 'Smart reminders, fun challenges & MaKopala rewards',
    ),
    _AchievementItem(
      emoji: '🇿🇲',
      color: Color(0xFF198A00),
      bgColor: Color(0xFFEEFBE0),
      title: 'Unlock Zambian cultural badges',
      subtitle: 'Earn badges for Copperbelt, Luapula & Eastern Province',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _itemsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _progressAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
    _mascotBounce = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _progressController.forward();
      _itemsController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _itemsController.dispose();
    _mascotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: Column(
          children: [
            // Top progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _sound.playTap();
                      context.pop();
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _progressAnim,
                      builder: (context, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _progressAnim.value,
                            backgroundColor: Colors.white.withAlpha(30),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primary,
                            ),
                            minHeight: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mascot + speech bubble
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: _mascotBounce,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _mascotBounce.value),
                              child: child,
                            );
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primary.withAlpha(100),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withAlpha(60),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/zambian_fish_eagle_mascot.png',
                                fit: BoxFit.cover,
                                semanticLabel:
                                    'Zam-Eagle mascot, Zambian Fish Eagle with white head and brown wings, national bird of Zambia',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(15),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withAlpha(30),
                              ),
                            ),
                            child: Text(
                              "Here's what you can achieve in 3 months! 🇿🇲",
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // Achievement items
                    ...List.generate(_items.length, (index) {
                      return AnimatedBuilder(
                        animation: _itemsController,
                        builder: (context, child) {
                          final delay = index * 0.15;
                          final t = (_itemsController.value - delay).clamp(
                            0.0,
                            1.0,
                          );
                          final curve = Curves.easeOutBack.transform(t);
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - curve)),
                            child: Opacity(
                              opacity: t.clamp(0.0, 1.0),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _AchievementCard(item: _items[index]),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Zambian cultural badge preview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primary.withAlpha(40),
                            AppTheme.zambiaOrange.withAlpha(30),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(80),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🏆 Zambian Cultural Badges',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _BadgePreview(
                                emoji: '🦅',
                                label: 'Eagle\nSpeaker',
                                unlocked: false,
                              ),
                              _BadgePreview(
                                emoji: '🌿',
                                label: 'Copperbelt\nLocal',
                                unlocked: false,
                              ),
                              _BadgePreview(
                                emoji: '🎵',
                                label: 'Kalimba\nMaster',
                                unlocked: false,
                              ),
                              _BadgePreview(
                                emoji: '🛒',
                                label: 'Market\nPro',
                                unlocked: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CONTINUE button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _sound.playTap();
                    context.go(AppRoutes.homeScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementItem {
  final String emoji;
  final Color color;
  final Color bgColor;
  final String title;
  final String subtitle;

  const _AchievementItem({
    required this.emoji,
    required this.color,
    required this.bgColor,
    required this.title,
    required this.subtitle,
  });
}

class _AchievementCard extends StatelessWidget {
  final _AchievementItem item;

  const _AchievementCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: item.bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(160),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BadgePreview extends StatelessWidget {
  final String emoji;
  final String label;
  final bool unlocked;

  const _BadgePreview({
    required this.emoji,
    required this.label,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: unlocked
                ? AppTheme.maKopalaGold.withAlpha(40)
                : Colors.white.withAlpha(15),
            shape: BoxShape.circle,
            border: Border.all(
              color: unlocked
                  ? AppTheme.maKopalaGold
                  : Colors.white.withAlpha(40),
              width: 2,
            ),
          ),
          child: Center(
            child: unlocked
                ? Text(emoji, style: const TextStyle(fontSize: 24))
                : const Icon(
                    Icons.lock_rounded,
                    color: Colors.white38,
                    size: 22,
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white60,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
