import 'package:flutter/material.dart';

import '../../../core/di/app_scope.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../data/auth_failure.dart';
import '../widgets/auth_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    final services = AppScope.of(context);
    setState(() => _submitting = true);
    try {
      await services.authRepository.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      services.analytics.logSignUp();
      // Користувача вже авторизовано: повертаємося до кореневого маршруту,
      // де AuthGate показує головний екран.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthFailure catch (e) {
      if (mounted) {
        showAppSnackBar(context, e.message, isError: true);
        setState(() => _submitting = false);
      }
    }
  }

  void _backToLogin() => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Create your account',
      subtitle: 'Start tracking your favorite table sessions.',
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Name',
                  hint: 'How other players will see you',
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: Validators.name,
                  enabled: !_submitting,
                ),
                const SizedBox(height: AppSpacing.medium),
                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                  enabled: !_submitting,
                ),
                const SizedBox(height: AppSpacing.medium),
                AppTextField(
                  label: 'Password',
                  hint: 'At least 8 characters, letters and digits',
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: Validators.newPassword,
                  enabled: !_submitting,
                ),
                const SizedBox(height: AppSpacing.medium),
                AppTextField(
                  label: 'Confirm password',
                  hint: 'Repeat the password',
                  controller: _confirmController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: Validators.confirmPassword(
                    () => _passwordController.text,
                  ),
                  onFieldSubmitted: (_) => _createAccount(),
                  enabled: !_submitting,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        PrimaryButton(
          label: _submitting ? 'Creating account…' : 'Create Account',
          expanded: true,
          loading: _submitting,
          onPressed: _createAccount,
        ),
        AuthFooter(
          text: 'Already have an account?',
          actionLabel: 'Log in',
          onTap: _backToLogin,
        ),
      ],
    );
  }
}
