# BoardHub

Кросплатформний застосунок для обліку настільних ігор, зіграних партій, учасників та результатів (Flutter).

## Підключення Firebase

1. У [Firebase Console](https://console.firebase.google.com) створіть проєкт з увімкненим Google Analytics.
2. Authentication → Sign-in method → увімкніть **Email/Password**.
3. Згенеруйте конфігурацію (перезапише `lib/firebase_options.dart` і додасть `google-services.json`):

```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

Crashlytics працює на Android/iOS/macOS; на Web і Windows вона вимкнена. Analytics працює скрізь, крім Windows.

## Запуск

```bash
flutter pub get
flutter run -d chrome
flutter run -d emulator-5554
```

## Структура

- `lib/core` — тема, утиліти й валідатори, сервіси Analytics/Crashlytics (`core/services`), DI (`core/di`), маршрути та спільні віджети (`core/widgets`).
- `lib/features` — модулі `auth`, `home`, `profile`, `shell`; взаємодія з Firebase Auth винесена в репозиторії `auth/data/auth_repository.dart` і `profile/data/profile_repository.dart`.
