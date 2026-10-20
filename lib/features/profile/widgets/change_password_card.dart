import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/icon_badge.dart';

/// Форма зміни пароля.
class ChangePasswordCard extends StatefulWidget {
  const ChangePasswordCard({super.key});

  @override
  State<ChangePasswordCard> createState() => _ChangePasswordCardState();
}

class _ChangePasswordCardState extends State<ChangePasswordCard> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    // Без бізнес-логіки: очищаємо поля й показуємо повідомлення про успіх.
    _currentController.clear();
    _newController.clear();
    FocusScope.of(context).unfocus();
    showAppSnackBar(context, 'Password updated successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              IconBadge(icon: Icons.lock_outline),
              SizedBox(width: AppSpacing.normal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Keep your account secure.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          AppTextField(
            label: 'Current password',
            controller: _currentController,
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.medium),
          AppTextField(
            label: 'New password',
            controller: _newController,
            obscureText: true,
          ),
          const SizedBox(height: AppSpacing.large),
          PrimaryButton(
            label: 'Update Password',
            expanded: true,
            onPressed: _updatePassword,
          ),
        ],
      ),
    );
  }
}
