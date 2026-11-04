import 'package:flutter/material.dart';

import '../../features/auth/screens/auth_gate.dart';
import '../../features/auth/screens/register_screen.dart';

abstract final class AppRoutes {
  /// Кореневий маршрут: вхід або головний екран залежно від стану сесії.
  static const String root = '/';
  static const String register = '/register';

  static Map<String, WidgetBuilder> get routes => {
    root: (_) => const AuthGate(),
    register: (_) => const RegisterScreen(),
  };
}
