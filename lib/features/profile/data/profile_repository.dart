import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../auth/data/auth_failure.dart';

/// Керування профілем поточного користувача у Firebase Auth.
class ProfileRepository {
  final FirebaseAuth _auth;

  ProfileRepository(this._auth);

  User get _user {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthFailure('no-current-user', 'You are not logged in.');
    }
    return user;
  }

  /// Оновлює ім'я та посилання на фото (зберігається лише URL, не файл).
  Future<void> updateProfile({
    required String displayName,
    required String? photoUrl,
  }) => _guard(() async {
    final user = _user;
    if (displayName != user.displayName) {
      await user.updateDisplayName(displayName);
    }
    if (photoUrl != user.photoURL) {
      await user.updatePhotoURL(photoUrl);
    }
    await user.reload();
  });

  /// Прив'язує Google до поточного акаунта, щоб входити будь-яким способом
  /// в той самий профіль (об'єднання способів входу).
  Future<void> linkGoogle() => _guard(() async {
    final user = _user;
    final provider = GoogleAuthProvider();
    if (kIsWeb) {
      await user.linkWithPopup(provider);
    } else {
      await user.linkWithProvider(provider);
    }
    await user.reload();
  });

  /// Змінює пароль. Спершу повторно підтверджує особу поточним паролем:
  /// так перевіряється поточний пароль і уникається `requires-recent-login`.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _user;
      final credential = EmailAuthProvider.credential(
        email: user.email ?? '',
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        throw AuthFailure(e.code, 'Current password is incorrect.');
      }
      throw AuthFailure.fromFirebase(e);
    }
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebase(e);
    }
  }
}
