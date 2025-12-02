import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Large pastel gradient placeholder for product images
class PastelPlaceholderImage extends StatelessWidget {
  final Color color;
  final double height;
  final double borderRadius;
  final String heroTag;

  const PastelPlaceholderImage({
    super.key,
    required this.color,
    this.height = 300,
    this.borderRadius = 30,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: AppColors.getPastelGradient(color),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 120,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

