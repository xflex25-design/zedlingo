import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showGradient;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showGradient = true,
    this.centerTitle = false,
    this.backgroundColor,
    this.titleColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showGradient
          ? const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            )
          : BoxDecoration(color: backgroundColor ?? Colors.white),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              if (leading != null) ...[
                const SizedBox(width: 4),
                leading!,
              ] else ...[
                const SizedBox(width: 16),
              ],
              if (centerTitle) const Spacer(),
              Text(
                title,
                style: GoogleFonts.nunitoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color:
                      titleColor ??
                      (showGradient ? Colors.white : AppTheme.zambiaBlack),
                ),
              ),
              if (centerTitle) const Spacer(),
              if (!centerTitle) const Spacer(),
              if (actions != null) ...actions!,
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
