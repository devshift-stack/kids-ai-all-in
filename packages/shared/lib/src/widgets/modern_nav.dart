import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

/// Modern Navigation Bar (v0-kids-ai-ui Design)
class ModernNavBar extends StatelessWidget implements PreferredSizeWidget {
  const ModernNavBar({
    super.key,
    required this.title,
    this.actions,
    this.isTransparent = false,
    this.backgroundColor,
  });

  final String title;
  final List<Widget>? actions;
  final bool isTransparent;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isTransparent
                ? Colors.white.withValues(alpha: 0.1)
                : KidsColors.surface),
        border: Border(
          bottom: BorderSide(
            color: isTransparent
                ? Colors.white.withValues(alpha: 0.2)
                : KidsColors.border,
            width: 1,
          ),
        ),
      ),
      child: isTransparent
          ? ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  actions: actions,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
              actions: actions,
              iconTheme: const IconThemeData(color: KidsColors.textPrimary),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Navigation Button für NavBar
class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isTransparent = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isTransparent;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onTap,
      color: isTransparent ? Colors.white : KidsColors.textPrimary,
      style: IconButton.styleFrom(
        backgroundColor: isTransparent
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.transparent,
      ),
    );
  }
}

