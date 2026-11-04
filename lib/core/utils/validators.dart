/// Локальна валідація полів форм (виконується до запиту у Firebase).
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(
    r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
  );
  static final RegExp _namePattern = RegExp(
    r"^[\p{L}\d _.'-]+$",
    unicode: true,
  );

  static const int minPasswordLength = 8;

  static String? name(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter your name.';
    if (name.length < 2) return 'Name must be at least 2 characters.';
    if (name.length > 30) return 'Name must be at most 30 characters.';
    if (!_namePattern.hasMatch(name)) {
      return 'Use letters, digits, spaces, dots or dashes only.';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email.';
    if (!_emailPattern.hasMatch(email)) {
      return 'Enter a valid email, e.g. you@example.com.';
    }
    return null;
  }

  /// Для входу перевіряємо лише заповненість: правильність пароля
  /// перевіряє Firebase Auth.
  static String? requiredPassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password.';
    return null;
  }

  /// Політика пароля для реєстрації та зміни пароля.
  static String? newPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Enter a password.';
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters.';
    }
    if (!password.contains(RegExp(r'[A-Za-z]')) ||
        !password.contains(RegExp(r'\d'))) {
      return 'Password must contain letters and digits.';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) return 'Repeat the password.';
      if (value != original()) return 'Passwords do not match.';
      return null;
    };
  }

  static String? httpsImageUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter an image URL.';
    final uri = Uri.tryParse(text);
    if (uri == null || !uri.isAbsolute || uri.host.isEmpty) {
      return 'Enter a valid URL.';
    }
    if (uri.scheme != 'https') return 'Only HTTPS links are allowed.';
    return null;
  }
}
