import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BadgeType { success, warning, error, info, slang, locked }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final BadgeType type;
  final double fontSize;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    required this.type,
    this.fontSize = 11,
  });

  Color get _bgColor {
    switch (type) {
      case BadgeType.success:
        return AppTheme.primary.withAlpha(38);
      case BadgeType.warning:
        return AppTheme.warning.withAlpha(38);
      case BadgeType.error:
        return AppTheme.error.withAlpha(38);
      case BadgeType.info:
        return const Color(0xFF1976D2).withAlpha(31);
      case BadgeType.slang:
        return const Color(0xFF7B1FA2).withAlpha(31);
      case BadgeType.locked:
        return const Color(0xFFAFAFAF).withAlpha(38);
    }
  }

  Color get _textColor {
    switch (type) {
      case BadgeType.success:
        return AppTheme.primaryDark;
      case BadgeType.warning:
        return const Color(0xFF7A4200);
      case BadgeType.error:
        return AppTheme.error;
      case BadgeType.info:
        return const Color(0xFF1565C0);
      case BadgeType.slang:
        return const Color(0xFF6A1B9A);
      case BadgeType.locked:
        return const Color(0xFF6B6B6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: _textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
