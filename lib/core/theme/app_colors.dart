import 'package:flutter/material.dart';

/// Палітра «Tabletop Club» з дизайну ЛР-2.
abstract final class AppColors {
  // Акцентні (смарагдові) кольори
  static const Color primary = Color(0xFF006045);
  static const Color primaryDark = Color(0xFF004F3B);
  static const Color primarySoft = Color(0xFFECFDF5);
  static const Color primaryTint = Color(0xFFD0FAE5);
  static const Color mint = Color(0xFFA4F4CF);

  // Теплі (бурштинові) акценти
  static const Color eyebrow = Color(0xFFBB4D00);
  static const Color amberSoft = Color(0xFFFEF3C6);
  static const Color amberIcon = Color(0xFF973C00);
  static const Color amberLink = Color(0xFFFFD230);

  // Фони та поверхні
  static const Color background = Color(0xFFFAFAF9);
  static const Color authBackground = Color(0xFFF5F5F4);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFFAFAF9);
  static const Color border = Color(0xFFE7E5E4);
  static const Color divider = Color(0xFFF5F5F4);

  // Текст
  static const Color textPrimary = Color(0xFF0F172B);
  static const Color textBody = Color(0xFF1D293D);
  static const Color textLabel = Color(0xFF314158);
  static const Color textMuted = Color(0xFF79716B);
  static const Color textFaint = Color(0xFFA6A09B);
}
