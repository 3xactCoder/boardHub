import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Обгортка над Sentry для звітів про помилки.
///
/// Sentry використано замість Firebase Crashlytics, бо Crashlytics не
/// підтримує Web. Без DSN (і в тестах) усі виклики ігноруються.
class CrashReporter {
  final bool isEnabled;

  const CrashReporter._(this.isEnabled);

  const CrashReporter.disabled() : this._(false);

  /// Ініціалізує Flutter і Sentry та запускає застосунок через [appRunner].
  ///
  /// Усе виконується в одній зоні [runZonedGuarded]: інакше на Web Flutter
  /// ініціалізується в кореневій зоні, а запускається в зоні Sentry
  /// («Zone mismatch»). Помилки Flutter (FlutterError.onError) Sentry
  /// перехоплює сам, а необроблені асинхронні помилки потрапляють в onError зони.
  static Future<void> init({
    required String dsn,
    required Future<void> Function(CrashReporter reporter) appRunner,
  }) async {
    if (dsn.isEmpty) {
      WidgetsFlutterBinding.ensureInitialized();
      await appRunner(const CrashReporter.disabled());
      return;
    }
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await SentryFlutter.init((options) {
          options.dsn = dsn;
          options.sendDefaultPii = false;
        }, appRunner: () => appRunner(const CrashReporter._(true)));
      },
      (error, stack) => Sentry.captureException(
        ThrowableMechanism(
          Mechanism(type: 'runZonedGuarded', handled: false),
          error,
        ),
        stackTrace: stack,
      ),
    );
  }

  Future<void> setUserId(String? uid) async {
    if (!isEnabled) return;
    await Sentry.configureScope(
      (scope) => scope.setUser(uid == null ? null : SentryUser(id: uid)),
    );
  }

  /// Оброблена (нефатальна) помилка: застосунок продовжує роботу.
  /// Імітує розбір некоректного рахунку партії (наприклад, з імпорту).
  Future<void> recordTestError() async {
    if (!isEnabled) return;
    const rawScore = '82 points';
    try {
      int.parse(rawScore);
    } on FormatException catch (error, stack) {
      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) => scope.setTag('feature', 'match-score-import'),
      );
    }
  }

  /// Необроблена помилка, яку перехоплює глобальний обробник Sentry:
  /// звернення до переможця партії, у якій немає жодного гравця.
  void throwUnhandledError() {
    if (!isEnabled) return;
    final players = <String>[];
    Timer.run(() => debugPrint('Winner: ${players[0]}'));
  }
}
