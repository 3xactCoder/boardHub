import 'package:flutter/material.dart';

import 'initials_avatar.dart';

/// Кругле фото користувача за HTTPS-посиланням; поки фото немає
/// або його не вдалося завантажити — аватар з ініціалами.
class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String initials;
  final double size;

  const UserAvatar({
    super.key,
    required this.photoUrl,
    required this.initials,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = InitialsAvatar(initials: initials, size: size);
    final url = photoUrl;
    if (url == null || url.isEmpty) return fallback;

    return ClipOval(
      child: Image.network(
        url,
        key: ValueKey(url),
        width: size,
        height: size,
        fit: BoxFit.cover,
        // На Web дозволяє показувати зображення з серверів без CORS.
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (_, _, _) => fallback,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
      ),
    );
  }
}
