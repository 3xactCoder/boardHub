import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Аватар з ініціалами (коло або заокруглений квадрат).
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final bool circle;
  final Color background;
  final Color foreground;

  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 48,
    this.circle = true,
    this.background = AppColors.primaryTint,
    this.foreground = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(size * 0.25),
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w800,
          color: foreground,
        ),
      ),
    );
  }
}
