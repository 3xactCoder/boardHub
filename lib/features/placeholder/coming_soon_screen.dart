import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/icon_badge.dart';
import '../../core/widgets/page_container.dart';
import '../../core/widgets/page_header.dart';

/// Заглушка для розділів, які будуть реалізовані в наступних лабораторних.
class ComingSoonScreen extends StatelessWidget {
  final String eyebrow;
  final String title;
  final IconData icon;

  const ComingSoonScreen({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      children: [
        PageHeader(eyebrow: eyebrow, title: title),
        const SizedBox(height: AppSpacing.xLarge),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              IconBadge(
                icon: icon,
                size: 56,
                background: AppColors.primarySoft,
                foreground: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.medium),
              const Text(
                'Coming soon',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'This section will be implemented in the next labs.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
