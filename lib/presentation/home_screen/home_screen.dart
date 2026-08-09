import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/home_header_widget.dart';
import './widgets/home_language_selector_widget.dart';
import './widgets/home_learning_path_widget.dart';
import './widgets/home_offline_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'Bemba';
  final bool _isOffline = false;

  final int _moto = 7;
  final int _maKopala = 350;
  final int _maLives = 5;

  void _onLanguageChanged(String lang) {
    setState(() => _selectedLanguage = lang);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          HomeHeaderWidget(moto: _moto, maKopala: _maKopala, maLives: _maLives),

          if (_isOffline) const HomeOfflineBannerWidget(),

          // Achievement preview banner
          GestureDetector(
            onTap: () => context.push(AppRoutes.achievementPreviewScreen),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F1923), Color(0xFF1A2E3A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withAlpha(80)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primary.withAlpha(120),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/zambian_fish_eagle_mascot.png',
                        fit: BoxFit.cover,
                        semanticLabel: 'Zam-Eagle mascot preview',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "See what you'll achieve in 3 months! 🇿🇲",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tap to see your learning goals',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppTheme.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          HomeLaguageSelectorWidget(
            selectedLanguage: _selectedLanguage,
            onChanged: _onLanguageChanged,
          ),

          Expanded(
            child: HomeLearningPathWidget(
              selectedLanguage: _selectedLanguage,
              onLessonTap: (lessonId) {
                context.push(AppRoutes.lessonPlayerScreen);
              },
              isTablet: isTablet,
            ),
          ),
        ],
      ),
    );
  }
}
