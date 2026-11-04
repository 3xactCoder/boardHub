import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/app_scope.dart';
import 'core/services/analytics_service.dart';
import 'core/services/crash_reporter.dart';
import 'core/services/sentry_config.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/profile/data/profile_repository.dart';
import 'firebase_options.dart';

/// Спершу ініціалізується Sentry, щоб він перехоплював помилки з самого
/// старту, а вже в його зоні — Firebase і сам застосунок.
Future<void> main() => CrashReporter.init(
  dsn: SentryConfig.dsn,
  appRunner: (crashReporter) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final auth = FirebaseAuth.instance;

    runApp(
      BoardHubApp(
        services: AppServices(
          authRepository: AuthRepository(auth),
          profileRepository: ProfileRepository(auth),
          analytics: AnalyticsService.create(),
          crashReporter: crashReporter,
        ),
      ),
    );
  },
);
