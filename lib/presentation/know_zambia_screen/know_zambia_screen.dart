import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class KnowZambiaScreen extends StatefulWidget {
  const KnowZambiaScreen({super.key});

  @override
  State<KnowZambiaScreen> createState() => _KnowZambiaScreenState();
}

class _KnowZambiaScreenState extends State<KnowZambiaScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnim;

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'greetings',
      'title': 'Greetings',
      'subtitle': 'How Zambians greet each other',
      'emoji': '👋',
      'color': Color(0xFF58CC02),
      'description': 'Learn about traditional greetings, handshakes, and polite forms of address.',
    },
    {
      'id': 'respect_norms',
      'title': 'Respect Norms',
      'subtitle': 'Cultural etiquette & customs',
      'emoji': '🙏',
      'color': Color(0xFFFF9600),
      'description': 'Understand the importance of respect for elders and community leaders.',
    },
    {
      'id': 'family_structures',
      'title': 'Family Structures',
      'subtitle': 'Extended family & kinship',
      'emoji': '👨‍👩‍👧‍👦',
      'color': Color(0xFFFF4B4B),
      'description': 'Explore Zambian family dynamics and kinship terminology.',
    },
    {
      'id': 'food_culture',
      'title': 'Food Culture',
      'subtitle': 'Nshima, relish & traditions',
      'emoji': '🍲',
      'color': Color(0xFFE67E22),
      'description': 'Discover the role of food in Zambian culture, from nshima to village feasts.',
    },
    {
      'id': 'community_life',
      'title': 'Community Life',
      'subtitle': 'Ubuntu & togetherness',
      'emoji': '🤝',
      'color': Color(0xFF1CB0F6),
      'description': 'How community bonds shape daily life across Zambia.',
    },
    {
      'id': 'music_football',
      'title': 'Music & Football',
      'subtitle': 'National passions',
      'emoji': '🎵⚽',
      'color': Color(0xFF9B59B6),
      'description': 'From Kalindula to the Super League, sport and music unite Zambians.',
    },
    {
      'id': 'education_work',
      'title': 'Education & Work',
      'subtitle': 'Schools, jobs & aspirations',
      'emoji': '📚💼',
      'color': Color(0xFF34495E),
      'description': 'The value placed on education and the workplace culture in Zambia.',
    },
    {
      'id': 'regional_differences',
      'title': 'Regional Differences',
      'subtitle': 'Provincial variations',
      'emoji': '🗺️',
      'color': Color(0xFF2ECC71),
      'description': 'How language and customs vary across Zambia\'s 10 provinces.',
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
                    'Know Zambia',
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
                      '🇿🇲 Understand the culture',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Learn the customs that shape Zambian life',
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
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 400 + index * 80),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: _CategoryCard(
                      category: category,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${category['title']} coming soon!'),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
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

class _CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = category['color'] as Color;
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
                  category['emoji'] as String,
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
                    category['title'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    category['subtitle'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    category['description'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
