/// Налаштування Sentry (аналог Firebase Crashlytics, який не підтримує Web).
abstract final class SentryConfig {
  /// DSN проєкту з sentry.io: Settings → Projects → flutter → Client Keys (DSN).
  /// Можна також передати під час запуску: `--dart-define=SENTRY_DSN=...`.
  static const String dsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: 'https://8e3d67201a52f6174114479d1ed3686d@o4512375242358784.ingest.de.sentry.io/4512375250681936',
  );
}
