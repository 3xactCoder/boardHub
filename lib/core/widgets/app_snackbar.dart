import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Коротке сповіщення внизу екрана; [isError] підсвічує помилку.
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : null,
      ),
    );
}
