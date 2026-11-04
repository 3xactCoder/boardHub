import 'package:flutter/material.dart';

import 'core/di/app_scope.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class BoardHubApp extends StatelessWidget {
  final AppServices services;

  const BoardHubApp({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      services: services,
      child: MaterialApp(
        title: 'BoardHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.root,
        routes: AppRoutes.routes,
        navigatorObservers: services.analytics.navigatorObservers,
      ),
    );
  }
}
