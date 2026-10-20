import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Темно-зелена картка «Your top game» з посиланням на каталог.
class TopGameCard extends StatelessWidget {
  final TopGame game;
  final VoidCallback onViewCatalog;

  const TopGameCard({
    super.key,
    required this.game,
    required this.onViewCatalog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.amberLink,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.xLarge),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your top game',
                style: TextStyle(fontSize: 14, color: AppColors.mint),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                game.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.normal),
              Text(
                "You've played it ${game.timesPlayed} times and won "
                '${game.timesWon} of those matches.',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.primaryTint,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              InkWell(
                onTap: onViewCatalog,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View game catalog',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amberLink,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.amberLink,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
