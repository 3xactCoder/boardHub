import 'package:flutter/widgets.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/profile/data/profile_repository.dart';
import '../services/analytics_service.dart';
import '../services/crash_reporter.dart';

/// Залежності застосунку, які створюються один раз у main().
class AppServices {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  final AnalyticsService analytics;
  final CrashReporter crashReporter;

  const AppServices({
    required this.authRepository,
    required this.profileRepository,
    this.analytics = const AnalyticsService.disabled(),
    this.crashReporter = const CrashReporter.disabled(),
  });
}

/// Робить [AppServices] доступними будь-якому віджету через `AppScope.of(context)`.
class AppScope extends InheritedWidget {
  final AppServices services;

  const AppScope({super.key, required this.services, required super.child});

  static AppServices of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in the widget tree');
    return scope!.services;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => services != oldWidget.services;
}
