import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Заголовок сторінки: надпис-«eyebrow», великий заголовок і необов'язкова дія справа.
class PageHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final Widget? action;

  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: AppColors.eyebrow,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: isDesktop ? 36 : 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.15,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );

    if (action == null) return texts;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: texts),
        const SizedBox(width: 16),
        action!,
      ],
    );
  }
}
