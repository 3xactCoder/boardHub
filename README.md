# BoardHub

Кросплатформний застосунок для обліку настільних ігор, зіграних партій, учасників та результатів (Flutter).

## Запуск

```bash
flutter pub get
flutter run -d chrome
```

## Структура

- `lib/core` — тема, утиліти, тестові дані, маршрути та спільні віджети (`core/widgets`).
- `lib/features` — екрани за функціональними модулями: `auth`, `home`, `profile`, `shell`.
- `screenshots` — знімки екранів (Desktop 1440 px / Mobile 390 px), генеруються командою
  `flutter test tool/screenshots_test.dart --update-goldens`.
