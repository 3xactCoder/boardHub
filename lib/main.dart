import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/app_scope.dart';
import 'core/services/analytics_service.dart';
import 'core/services/crash_reporter.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/profile/data/profile_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final crashReporter = CrashReporter.create()..init();
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
}
