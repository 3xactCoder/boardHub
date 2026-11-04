import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Обгортка над Firebase Crashlytics. Crashlytics не підтримує Web і
/// Windows, тому там (і в тестах) усі виклики ігноруються.
class CrashReporter {
  final FirebaseCrashlytics? _crashlytics;

  const CrashReporter._(this._crashlytics);

  const CrashReporter.disabled() : this._(null);

  factory CrashReporter.create() =>
      CrashReporter._(isSupported ? FirebaseCrashlytics.instance : null);

  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  bool get isEnabled => _crashlytics != null;

  /// Перенаправляє необроблені помилки Flutter і Dart у Crashlytics.
  void init() {
    final crashlytics = _crashlytics;
    if (crashlytics == null) return;

    FlutterError.onError = crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<void> setUserId(String? uid) async =>
      _crashlytics?.setUserIdentifier(uid ?? '');

  /// Нефатальна тестова помилка: застосунок продовжує роботу.
  Future<void> recordTestError() async {
    try {
      throw StateError('BoardHub test non-fatal error');
    } catch (error, stack) {
      await _crashlytics?.recordError(
        error,
        stack,
        reason: 'Manual test from the Profile screen',
      );
    }
  }

  /// Аварійно завершує застосунок; звіт надійде після наступного запуску.
  void crash() => _crashlytics?.crash();
}
