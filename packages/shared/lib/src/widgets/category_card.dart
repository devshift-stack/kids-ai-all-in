import 'package:flutter/material.dart';

/// A card widget for displaying learning categories in Kids AI apps.
/// 
/// Used in home screens to show game categories like Letters, Numbers, Colors, etc.
/// Supports progress indication and lock state for premium/locked content.
class CategoryCard extends StatelessWidget {
  /// Title displayed on the card
  final String title;
  
  /// Icon displayed in the card
  final IconData icon;
  
  /// Primary color for the icon and progress indicator
  final Color color;
  
  /// Callback when card is tapped (not called if locked)
  final VoidCallback onTap;
  
  /// Whether the card is locked (shows lock overlay)
  final bool isLocked;
  
  /// Optional progress percentage (0-100)
  final int? progress;
  
  /// Border radius for the card (default: 16)
  final double borderRadius;
  
  /// Box shadow for the card
  final List<BoxShadow>? boxShadow;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLocked = false,
    this.progress,
    this.borderRadius = 16,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveShadow = boxShadow ?? [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: effectiveShadow,
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
                    bottom: Radius.circular(borderRadius),
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
                        borderRadius: BorderRadius.circular(12),
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
                          ? Colors.grey.shade500
                          : Colors.grey.shade800,
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
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.grey.shade500,
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
