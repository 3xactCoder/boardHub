import 'package:firebase_auth/firebase_auth.dart';

/// Дані облікового запису, потрібні інтерфейсу (без залежності від Firebase у віджетах).
class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  /// Прив'язані способи входу: `password`, `google.com`.
  final Set<String> providers;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.providers = const {},
  });

  factory AppUser.fromFirebase(User user) => AppUser(
    uid: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoUrl: user.photoURL,
    providers: {for (final info in user.providerData) info.providerId},
  );

  bool get hasPassword => providers.contains(EmailAuthProvider.PROVIDER_ID);
  bool get hasGoogle => providers.contains(GoogleAuthProvider.PROVIDER_ID);

  /// Ім'я для відображення: displayName або частина email до «@».
  String get name {
    final displayName = this.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) return displayName;
    return email.split('@').first;
  }

  String get initials {
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.length > 1
        ? parts.take(2).map((p) => p[0]).join()
        : name.substring(0, name.length < 2 ? name.length : 2);
    return letters.toUpperCase();
  }
}
