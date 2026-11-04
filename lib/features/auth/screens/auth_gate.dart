import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/di/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../shell/main_shell.dart';
import '../data/app_user.dart';
import 'login_screen.dart';

/// Слухає стан сесії Firebase Auth і показує вхід або головний екран.
///
/// Firebase зберігає сесію між запусками, тому після перезапуску
/// користувач одразу потрапляє на головний екран (відновлення сеансу).
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription<AppUser?>? _subscription;
  AppUser? _user;
  bool _resolved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscription ??= AppScope.of(context).authRepository
        .userChanges()
        .listen(_onUserChanged);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onUserChanged(AppUser? user) {
    final services = AppScope.of(context);
    final wasResolved = _resolved;
    final previous = _user;
    setState(() {
      _user = user;
      _resolved = true;
    });

    if (previous?.uid != user?.uid) {
      services.analytics.setUserId(user?.uid);
      services.crashReporter.setUserId(user?.uid);
    }

    final String? message;
    if (!wasResolved) {
      message = user == null
          ? null
          : 'Session restored. Welcome back, ${user.name}!';
    } else if (previous == null && user != null) {
      message = 'Signed in as ${user.email}.';
    } else if (previous != null && user == null) {
      message = 'You have been logged out.';
    } else {
      message = null;
    }
    if (message != null) showAppSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    if (!_resolved) {
      return const Scaffold(
        backgroundColor: AppColors.authBackground,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final user = _user;
    return user == null ? const LoginScreen() : MainShell(user: user);
  }
}
