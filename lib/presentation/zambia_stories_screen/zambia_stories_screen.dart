import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/zambian_eagle_mascot.dart';

class ZambiaStoriesScreen extends StatefulWidget {
  const ZambiaStoriesScreen({super.key});

  @override
  State<ZambiaStoriesScreen> createState() => _ZambiaStoriesScreenState();
}

class _ZambiaStoriesScreenState extends State<ZambiaStoriesScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnim;

  final List<Map<String, dynamic>> _stories = [
    {
      'id': 'market-day',
      'title': 'Market Day',
      'subtitle': 'A trip to the local market',
      'emoji': '🛒',
      'color': Color(0xFFFF9600),
      'difficulty': 'beginner',
      'xp': 40,
      'coins': 15,
      'description': 'Follow along as a family prepares for market day in Lusaka.',
      'pages': 8,
    },
    {
      'id': 'visiting-family',
      'title': 'Visiting Family',
      'subtitle': 'A journey to the village',
      'emoji': '🏠',
      'color': Color(0xFF58CC02),
      'difficulty': 'beginner',
      'xp': 35,
      'coins': 12,
      'description': 'Experience the warmth of Zambian family visits and greetings.',
      'pages': 6,
    },
    {
      'id': 'first-day-school',
      'title': 'First Day at School',
      'subtitle': 'New friends and new lessons',
      'emoji': '🎒',
      'color': Color(0xFF1CB0F6),
      'difficulty': 'beginner',
      'xp': 30,
      'coins': 10,
      'description': 'Join a young learner on their first day of school in Zambia.',
      'pages': 7,
    },
    {
      'id': 'football-match',
      'title': 'Football Match Day',
      'subtitle': 'The excitement of the game',
      'emoji': '⚽',
      'color': Color(0xFF2ECC71),
      'difficulty': 'intermediate',
      'xp': 45,
      'coins': 18,
      'description': 'Feel the energy of a live football match between Zesco and Nkana.',
      'pages': 10,
    },
    {
      'id': 'traveling-towns',
      'title': 'Traveling Between Towns',
      'subtitle': 'Road trips across Zambia',
      'emoji': '🚌',
      'color': Color(0xFF9B59B6),
      'difficulty': 'intermediate',
      'xp': 50,
      'coins': 20,
      'description': 'Navigate bus terminals and road conversations across the country.',
      'pages': 9,
    },
  ];

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _headerAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Zambia Stories',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _headerAnim,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - _headerAnim.value)),
                  child: Opacity(
                    opacity: _headerAnim.value,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📖 Learn through stories',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Interactive stories set in real Zambian life',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _stories.length,
                itemBuilder: (context, index) {
                  final story = _stories[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 400 + index * 80),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: _StoryCard(
                      story: story,
                      onTap: () {
                        context.push('/story/${story['id']}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final Map<String, dynamic> story;
  final VoidCallback onTap;

  const _StoryCard({
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = story['color'] as Color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withAlpha(180)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  story['emoji'] as String,
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story['title'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    story['subtitle'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    story['description'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          color: AppTheme.xpGold.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${story['xp']} XP',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.xpGold,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          color: AppTheme.gemBlue.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${story['coins']} 💎',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gemBlue,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          color: color.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${story['pages']} pages',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
