import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/zambian_eagle_mascot.dart';
import '../../widgets/scenario_illustration.dart';

class RealZambiaScreen extends StatefulWidget {
  const RealZambiaScreen({super.key});

  @override
  State<RealZambiaScreen> createState() => _RealZambiaScreenState();
}

class _RealZambiaScreenState extends State<RealZambiaScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnim;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'id': 'minibus',
      'type': ScenarioType.minibus,
      'title': 'Minibus',
      'subtitle': 'Buying a ticket & asking directions',
      'emoji': '🚌',
      'color': Color(0xFFFF6B00),
      'difficulty': 'beginner',
      'xp': 30,
      'coins': 10,
      'description': 'Learn how to interact with minibus conductors and drivers across Zambia.',
      'icon': Icons.directions_bus_filled,
    },
    {
      'id': 'market',
      'type': ScenarioType.market,
      'title': 'Market',
      'subtitle': 'Buying produce, negotiating prices',
      'emoji': '🛒',
      'color': Color(0xFF58CC02),
      'difficulty': 'beginner',
      'xp': 30,
      'coins': 10,
      'description': 'Master the art of bargaining at local markets like Soweto and City.',
      'icon': Icons.shopping_basket,
    },
    {
      'id': 'shop',
      'type': ScenarioType.shop,
      'title': 'Shop',
      'subtitle': 'Asking for items & paying',
      'emoji': '🏪',
      'color': Color(0xFF1CB0F6),
      'difficulty': 'beginner',
      'xp': 25,
      'coins': 8,
      'description': 'Practice everyday shopping conversations at local shops.',
      'icon': Icons.storefront,
    },
    {
      'id': 'elder',
      'type': ScenarioType.elder,
      'title': 'Elder Interactions',
      'subtitle': 'Showing respect & cultural awareness',
      'emoji': '👵',
      'color': Color(0xFF9B59B6),
      'difficulty': 'intermediate',
      'xp': 40,
      'coins': 15,
      'description': 'Learn respectful communication with elders and community leaders.',
      'icon': Icons.emoji_people,
    },
    {
      'id': 'family',
      'type': ScenarioType.family,
      'title': 'Family',
      'subtitle': 'Daily home conversations',
      'emoji': '🏠',
      'color': Color(0xFFFF4B4B),
      'difficulty': 'beginner',
      'xp': 25,
      'coins': 8,
      'description': 'Practice common phrases used in Zambian households.',
      'icon': Icons.home,
    },
    {
      'id': 'football',
      'type': ScenarioType.football,
      'title': 'Football',
      'subtitle': 'Casual conversations at the ground',
      'emoji': '⚽',
      'color': Color(0xFF2ECC71),
      'difficulty': 'intermediate',
      'xp': 35,
      'coins': 12,
      'description': 'Talk about football like a true Zambian fan at the stadium.',
      'icon': Icons.sports_soccer,
    },
    {
      'id': 'clinic',
      'type': ScenarioType.clinic,
      'title': 'Clinic',
      'subtitle': 'Describing symptoms & asking for help',
      'emoji': '🏥',
      'color': Color(0xFF3498DB),
      'difficulty': 'intermediate',
      'xp': 35,
      'coins': 12,
      'description': 'Essential phrases for healthcare visits (language only, no medical advice).',
      'icon': Icons.local_hospital,
    },
    {
      'id': 'mobile_money',
      'type': ScenarioType.mobileMoney,
      'title': 'Mobile Money',
      'subtitle': 'Deposits, transfers & payments',
      'emoji': '📱',
      'color': Color(0xFF1ABC9C),
      'difficulty': 'intermediate',
      'xp': 40,
      'coins': 15,
      'description': 'Navigate MTN Mobile Money and Airtel Money conversations confidently.',
      'icon': Icons.payments,
    },
    {
      'id': 'work',
      'type': ScenarioType.work,
      'title': 'Work',
      'subtitle': 'Professional communication',
      'emoji': '💼',
      'color': Color(0xFF34495E),
      'difficulty': 'advanced',
      'xp': 50,
      'coins': 20,
      'description': 'Professional vocabulary for workplace settings and meetings.',
      'icon': Icons.work,
    },
    {
      'id': 'school',
      'type': ScenarioType.school,
      'title': 'School',
      'subtitle': 'Classroom & student interactions',
      'emoji': '🎓',
      'color': Color(0xFFE67E22),
      'difficulty': 'beginner',
      'xp': 25,
      'coins': 8,
      'description': 'Common phrases used in Zambian schools and classrooms.',
      'icon': Icons.school,
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
                    'Real Zambia',
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
                    Row(
                      children: [
                        Text(
                          '🇿🇲 ',
                          style: TextStyle(fontSize: 32),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Learn real Zambian life',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                'Practice real conversations',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primary.withAlpha(30), AppTheme.primaryLight.withAlpha(20)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primary.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Practice real-life scenarios used by Zambians every day.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
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
                itemCount: _scenarios.length,
                itemBuilder: (context, index) {
                  final scenario = _scenarios[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + index * 50),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: _ScenarioCard(
                      scenario: scenario,
                      onTap: () {
                        context.push('/scenario/${scenario['id']}');
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

class _ScenarioCard extends StatelessWidget {
  final Map<String, dynamic> scenario;
  final VoidCallback onTap;

  const _ScenarioCard({
    required this.scenario,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = scenario['color'] as Color;
    final scenarioType = scenario['type'] as ScenarioType;
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
            ScenarioIllustration(
              type: scenarioType,
              size: 60,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        scenario['emoji'] as String,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        scenario['title'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    scenario['subtitle'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
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
                          '+${scenario['xp']} XP',
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
                          '+${scenario['coins']} 💎',
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
                          color: _getDifficultyColor(scenario['difficulty'] as String).withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _capitalize(scenario['difficulty'] as String),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getDifficultyColor(scenario['difficulty'] as String),
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return AppTheme.primary;
      case 'intermediate':
        return AppTheme.secondary;
      case 'advanced':
        return AppTheme.zambiaRed;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
