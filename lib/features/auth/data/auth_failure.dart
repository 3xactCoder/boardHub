import 'package:firebase_auth/firebase_auth.dart';

/// Помилка автентифікації зі зрозумілим користувачу повідомленням.
class AuthFailure implements Exception {
  final String code;
  final String message;

  const AuthFailure(this.code, this.message);

  bool get requiresRecentLogin => code == 'requires-recent-login';

  /// Користувач сам закрив вікно Google — це не помилка, повідомлення не потрібне.
  bool get isCancelled => const {
    'popup-closed-by-user',
    'cancelled-popup-request',
    'web-context-canceled',
  }.contains(code);

  factory AuthFailure.fromFirebase(FirebaseAuthException e) {
    return AuthFailure(e.code, _messages[e.code] ?? _fallback);
  }

  factory AuthFailure.unknown() => const AuthFailure('unknown', _fallback);

  static const String _fallback = 'Something went wrong. Please try again.';

  static const Map<String, String> _messages = {
    // Вхід
    'invalid-credential': "Couldn't log in. Check your email and password.",
    'wrong-password': "Couldn't log in. Check your email and password.",
    'user-not-found': "Couldn't log in. Check your email and password.",
    'invalid-email': 'The email address is not valid.',
    'user-disabled': 'This account has been disabled.',
    // Реєстрація
    'email-already-in-use': 'An account with this email already exists.',
    'weak-password': 'The password is too weak. Choose a stronger one.',
    'operation-not-allowed':
        'This sign-in method is not enabled for this project.',
    // Google
    'popup-blocked':
        'The browser blocked the Google window. Allow pop-ups and retry.',
    'account-exists-with-different-credential':
        'An account with this email already exists. Log in with your '
        'password, then link Google in your profile.',
    'credential-already-in-use':
        'This Google account is already used by another BoardHub account.',
    'provider-already-linked': 'Google is already linked to this account.',
    // Зміна пароля
    'requires-recent-login':
        'For security reasons, please log out and log in again, '
        'then repeat the password change.',
    'user-mismatch': 'The credentials do not match the current account.',
    // Загальні
    'too-many-requests': 'Too many attempts. Please wait a moment and retry.',
    'network-request-failed': 'No connection. Check your internet and retry.',
  };
}
