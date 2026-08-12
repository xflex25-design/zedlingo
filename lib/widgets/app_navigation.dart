import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import 'app_routes.dart';

class _TabSpec {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _TabSpec({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedVisualIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
      route: AppRoutes.homeScreen,
    ),
    _TabSpec(
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book_rounded,
      label: 'Learn',
      route: AppRoutes.realZambiaScreen,
    ),
    _TabSpec(
      icon: Icons.wallet_outlined,
      selectedIcon: Icons.wallet_rounded,
      label: 'Rewards',
      route: AppRoutes.wordOfTheDayScreen,
    ),
    _TabSpec(
      icon: Icons.leaderboard_outlined,
      selectedIcon: Icons.leaderboard_rounded,
      label: 'Rankings',
      route: AppRoutes.knowZambiaScreen,
    ),
    _TabSpec(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profile',
      route: AppRoutes.homeScreen,
    ),
  ];

  void _onTabTapped(int visualIndex) {
    final tab = _tabs[visualIndex];
    setState(() {
      _selectedVisualIndex = visualIndex;
    });
    context.pushReplacement(tab.route);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        (bottomPadding + 12).clamp(16.0, 48.0),
      ),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(36),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppTheme.primary.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final isActive = index == _selectedVisualIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => _onTabTapped(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.primary.withAlpha(31)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  margin: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isActive ? tab.selectedIcon : tab.icon,
                          key: ValueKey(isActive),
                          color: isActive
                              ? AppTheme.primary
                              : const Color(0xFFAFAFAF),
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive
                              ? AppTheme.primary
                              : const Color(0xFFAFAFAF),
                        ),
                        child: Text(tab.label),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
