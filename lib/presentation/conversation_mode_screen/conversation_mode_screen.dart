import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/zambian_eagle_mascot.dart';

class ConversationModeScreen extends StatefulWidget {
  const ConversationModeScreen({super.key});

  @override
  State<ConversationModeScreen> createState() => _ConversationModeScreenState();
}

class _ConversationModeScreenState extends State<ConversationModeScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnim;

  final List<Map<String, dynamic>> _modes = [
    {
      'id': 'beginner',
      'title': 'Beginner',
      'subtitle': 'With English support',
      'emoji': '🌱',
      'color': Color(0xFF58CC02),
      'description': 'Practice simple conversations with English hints and translations.',
      'icon': Icons.school_outlined,
    },
    {
      'id': 'intermediate',
      'title': 'Intermediate',
      'subtitle': 'Mostly target language',
      'emoji': '🌿',
      'color': Color(0xFFFF9600),
      'description': 'Engage in fuller conversations with occasional English support.',
      'icon': Icons.chat_bubble_outline,
    },
    {
      'id': 'advanced',
      'title': 'Advanced',
      'subtitle': 'Full target language only',
      'emoji': '🌳',
      'color': Color(0xFF9B59B6),
      'description': 'Challenge yourself with pure Zambian language conversations.',
      'icon': Icons.record_voice_over,
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
                    'Talk to Zambia',
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
                      'Practice speaking with AI',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Choose your level and start conversing',
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
                itemCount: _modes.length,
                itemBuilder: (context, index) {
                  final mode = _modes[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 400 + index * 100),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: _ModeCard(
                      mode: mode,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${mode['title']} mode coming soon!'),
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

class _ModeCard extends StatelessWidget {
  final Map<String, dynamic> mode;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = mode['color'] as Color;
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
              child: Icon(
                mode['icon'] as IconData,
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mode['emoji'] as String,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        mode['title'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    mode['subtitle'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    mode['description'] as String,
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
