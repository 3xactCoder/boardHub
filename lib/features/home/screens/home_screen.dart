import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/page_container.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/stat_card.dart';
import '../../shell/nav_destinations.dart';
import '../widgets/recent_match_card.dart';
import '../widgets/top_game_card.dart';

/// Головна панель (Dashboard) зі статистикою та швидким доступом до функцій.
class HomeScreen extends StatelessWidget {
  final ValueChanged<AppSection> onNavigate;

  static const String _userName = MockData.userName;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final now = DateTime.now();

    const gamesCard = StatCard(
      icon: Icons.sports_esports_outlined,
      value: '${MockData.totalGames}',
      label: 'Total games',
    );
    const matchesCard = StatCard(
      icon: Icons.emoji_events_outlined,
      value: '${MockData.totalMatches}',
      label: 'Total matches',
    );
    const recentCard = RecentMatchCard(match: MockData.recentMatch);
    final topGameCard = TopGameCard(
      game: MockData.topGame,
      onViewCatalog: () => onNavigate(AppSection.catalog),
    );

    return PageContainer(
      children: [
        PageHeader(
          eyebrow: DateFormatter.fullDate(now),
          title: '${DateFormatter.greeting(now)}, $_userName.',
          // На мобільних кнопка «Record» є в нижній панелі.
          action: isDesktop
              ? PrimaryButton(
                  label: 'Record Match',
                  icon: Icons.add,
                  onPressed: () => onNavigate(AppSection.matches),
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        if (isDesktop) ...[
          const Row(
            children: [
              Expanded(child: gamesCard),
              SizedBox(width: AppSpacing.large),
              Expanded(child: matchesCard),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(flex: 3, child: recentCard),
                const SizedBox(width: AppSpacing.large),
                Expanded(flex: 2, child: topGameCard),
              ],
            ),
          ),
        ] else ...[
          gamesCard,
          const SizedBox(height: AppSpacing.medium),
          matchesCard,
          const SizedBox(height: AppSpacing.medium),
          recentCard,
          const SizedBox(height: AppSpacing.medium),
          topGameCard,
        ],
      ],
    );
  }
}
