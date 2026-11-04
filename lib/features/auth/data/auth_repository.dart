import 'package:firebase_auth/firebase_auth.dart';

import 'app_user.dart';
import 'auth_failure.dart';

/// Взаємодія з Firebase Auth: реєстрація, вхід, вихід, відновлення пароля.
///
/// Усі методи перетворюють [FirebaseAuthException] на [AuthFailure].
class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  /// Поточний користувач; потік оновлюється при вході/виході та зміні профілю.
  Stream<AppUser?> userChanges() => _auth.userChanges().map(
    (user) => user == null ? null : AppUser.fromFirebase(user),
  );

  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : AppUser.fromFirebase(user);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) => _guard(() async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) return;
    await user.updateDisplayName(name);
    await user.reload();
  });

  Future<void> signIn({required String email, required String password}) =>
      _guard(
        () =>
            _auth.signInWithEmailAndPassword(email: email, password: password),
      );

  Future<void> sendPasswordReset({required String email}) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email));

  Future<void> signOut() => _guard(_auth.signOut);

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebase(e);
    }
  }
}
