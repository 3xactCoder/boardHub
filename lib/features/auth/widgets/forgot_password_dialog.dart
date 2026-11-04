import 'package:flutter/material.dart';

import '../../../core/di/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../data/auth_failure.dart';

/// Модальне вікно «Reset your password»: надсилає лист Firebase Auth.
class ForgotPasswordDialog extends StatefulWidget {
  final String initialEmail;

  const ForgotPasswordDialog({super.key, this.initialEmail = ''});

  static Future<void> show(BuildContext context, {String initialEmail = ''}) =>
      showDialog<void>(
        context: context,
        builder: (_) => ForgotPasswordDialog(initialEmail: initialEmail),
      );

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    final services = AppScope.of(context);
    final email = _emailController.text.trim();
    setState(() => _submitting = true);
    try {
      await services.authRepository.sendPasswordReset(email: email);
      services.analytics.logEvent('password_reset_requested');
      if (!mounted) return;
      Navigator.of(context).pop();
      // Firebase не розкриває, чи існує акаунт, тому повідомлення нейтральне.
      showAppSnackBar(
        context,
        'If an account exists for $email, a reset link has been sent.',
      );
    } on AuthFailure catch (e) {
      if (mounted) {
        showAppSnackBar(context, e.message, isError: true);
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 448),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Reset your password',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: _submitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: AppColors.textBody),
                    ),
                  ],
                ),
                const Text(
                  "Enter your email and we'll send you a reset link.",
                  style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.large),
                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  onFieldSubmitted: (_) => _sendResetLink(),
                  enabled: !_submitting,
                ),
                const SizedBox(height: AppSpacing.large),
                PrimaryButton(
                  label: _submitting ? 'Sending…' : 'Send Reset Link',
                  loading: _submitting,
                  onPressed: _sendResetLink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
