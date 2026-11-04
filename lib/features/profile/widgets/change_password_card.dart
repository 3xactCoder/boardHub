import 'package:flutter/material.dart';

import '../../../core/di/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../auth/data/auth_failure.dart';

/// Форма зміни пароля через Firebase Auth.
///
/// Для акаунта, створеного лише через Google, пароля немає — тоді
/// замість форми показується пояснення.
class ChangePasswordCard extends StatefulWidget {
  final bool hasPassword;

  const ChangePasswordCard({super.key, this.hasPassword = true});

  @override
  State<ChangePasswordCard> createState() => _ChangePasswordCardState();
}

class _ChangePasswordCardState extends State<ChangePasswordCard> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateNew(String? value) {
    final error = Validators.newPassword(value);
    if (error != null) return error;
    if (value == _currentController.text) {
      return 'New password must differ from the current one.';
    }
    return null;
  }

  Future<void> _updatePassword() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    final services = AppScope.of(context);
    setState(() => _submitting = true);
    try {
      await services.profileRepository.changePassword(
        currentPassword: _currentController.text,
        newPassword: _newController.text,
      );
      services.analytics.logEvent('password_changed');
      if (!mounted) return;
      _formKey.currentState!.reset();
      _currentController.clear();
      _newController.clear();
      _confirmController.clear();
      FocusScope.of(context).unfocus();
      showAppSnackBar(context, 'Password updated successfully.');
    } on AuthFailure catch (e) {
      if (!mounted) return;
      if (e.requiresRecentLogin) {
        _showReLoginDialog(e.message);
      } else {
        showAppSnackBar(context, e.message, isError: true);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Сесія застаріла: пропонуємо вийти та увійти знову.
  void _showReLoginDialog(String message) {
    final authRepository = AppScope.of(context).authRepository;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Please log in again'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              authRepository.signOut();
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(28),
      child: Form(
        key: _formKey,
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
            if (!widget.hasPassword)
              const Text(
                'Your account uses Google sign-in, so it has no password. '
                'Manage your password in your Google account.',
                style: TextStyle(fontSize: 14, color: AppColors.textBody),
              )
            else
              ..._passwordFields(),
          ],
        ),
      ),
    );
  }

  List<Widget> _passwordFields() {
    return [
      AppTextField(
        label: 'Current password',
        controller: _currentController,
        obscureText: true,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.password],
        validator: Validators.requiredPassword,
        enabled: !_submitting,
      ),
      const SizedBox(height: AppSpacing.medium),
      AppTextField(
        label: 'New password',
        controller: _newController,
        obscureText: true,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.newPassword],
        validator: _validateNew,
        enabled: !_submitting,
      ),
      const SizedBox(height: AppSpacing.medium),
      AppTextField(
        label: 'Confirm new password',
        controller: _confirmController,
        obscureText: true,
        textInputAction: TextInputAction.done,
        validator: Validators.confirmPassword(() => _newController.text),
        onFieldSubmitted: (_) => _updatePassword(),
        enabled: !_submitting,
      ),
      const SizedBox(height: AppSpacing.large),
      PrimaryButton(
        label: _submitting ? 'Updating…' : 'Update Password',
        expanded: true,
        loading: _submitting,
        onPressed: _updatePassword,
      ),
    ];
  }
}
