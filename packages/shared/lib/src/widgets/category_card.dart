import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// CategoryCard Widget
/// Wiederverwendbare Karten-Komponente für Kategorien in allen Kids AI Apps
/// 
/// Features:
/// - Icon und Titel
/// - Fortschrittsanzeige (optional)
/// - Gesperrt-Status mit Lock-Overlay
/// - Anpassbare Farben
/// 
/// Verwendung:
/// ```dart
/// CategoryCard(
///   title: 'Buchstaben',
///   icon: Icons.abc,
///   color: Colors.blue,
///   onTap: () => Navigator.push(...),
///   progress: 75, // Optional
///   isLocked: false, // Optional
/// )
/// ```
class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLocked;
  final int? progress;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLocked = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: KidsSpacing.borderRadiusLg,
          boxShadow: KidsShadows.card,
        ),
        child: Stack(
          children: [
            // Progress indicator
            if (progress != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(KidsSpacing.radiusLg),
                  ),
                  child: LinearProgressIndicator(
                    value: progress! / 100,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 4,
                  ),
                ),
              ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon container
                  Flexible(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: KidsSpacing.borderRadiusMd,
                      ),
                      child: Icon(
                        icon,
                        size: 22,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isLocked
                          ? KidsColors.textSecondary
                          : KidsColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Lock overlay
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: KidsSpacing.borderRadiusLg,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      color: KidsColors.textSecondary,
                      size: 24,
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
