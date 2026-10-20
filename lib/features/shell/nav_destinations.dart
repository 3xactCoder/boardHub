import 'package:flutter/material.dart';

/// Розділи застосунку. Порядок однаковий для бічного меню і нижньої панелі.
enum AppSection {
  dashboard('Dashboard', 'Home', Icons.home_outlined),
  catalog('Game Catalog', 'Games', Icons.menu_book_outlined),
  matches('Match History', 'Record', Icons.calendar_month_outlined),
  players('Players', 'Players', Icons.people_outline),
  profile('Profile', 'Profile', Icons.account_circle_outlined);

  final String sidebarLabel;
  final String bottomLabel;
  final IconData icon;

  const AppSection(this.sidebarLabel, this.bottomLabel, this.icon);

  /// На мобільній панелі розділ партій показується як швидка дія «+ Record».
  IconData get bottomIcon => this == AppSection.matches ? Icons.add : icon;
}
