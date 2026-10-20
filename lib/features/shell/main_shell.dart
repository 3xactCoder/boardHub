import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/utils/responsive.dart';
import '../home/screens/home_screen.dart';
import '../placeholder/coming_soon_screen.dart';
import '../profile/screens/profile_screen.dart';
import 'nav_destinations.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/side_nav.dart';

/// Головний каркас після входу: бічне меню на десктопі, нижня панель на мобільних.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppSection _section = AppSection.dashboard;

  void _select(AppSection section) => setState(() => _section = section);

  void _logOut() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  Widget _buildPage() {
    return switch (_section) {
      AppSection.dashboard => HomeScreen(onNavigate: _select),
      AppSection.catalog => const ComingSoonScreen(
        eyebrow: 'Your collection',
        title: 'Game catalog',
        icon: Icons.menu_book_outlined,
      ),
      AppSection.matches => const ComingSoonScreen(
        eyebrow: 'Match sessions',
        title: 'Matches',
        icon: Icons.calendar_month_outlined,
      ),
      AppSection.players => const ComingSoonScreen(
        eyebrow: 'Your group',
        title: 'Players',
        icon: Icons.people_outline,
      ),
      AppSection.profile => ProfileScreen(onLogout: _logOut),
    };
  }

  @override
  Widget build(BuildContext context) {
    final page = KeyedSubtree(key: ValueKey(_section), child: _buildPage());

    if (context.isDesktop) {
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SideNav(selected: _section, onSelected: _select, onLogout: _logOut),
            Expanded(child: page),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(bottom: false, child: page),
      bottomNavigationBar: BottomNav(selected: _section, onSelected: _select),
    );
  }
}
