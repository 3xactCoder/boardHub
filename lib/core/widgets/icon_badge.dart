import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Піктограма на кольоровій заокругленій підкладці.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color background;
  final Color foreground;

  const IconBadge({
    super.key,
    required this.icon,
    this.size = 44,
    this.background = AppColors.amberSoft,
    this.foreground = AppColors.amberIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Icon(icon, color: foreground, size: size * 0.55),
    );
  }
}
