import 'package:flutter/material.dart';

import '../../../core/di/app_scope.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../data/auth_failure.dart';
import '../widgets/auth_card.dart';
import '../widgets/forgot_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    final services = AppScope.of(context);
    setState(() => _submitting = true);
    try {
      await services.authRepository.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      services.analytics.logLogin();
      // Після успішного входу AuthGate сам покаже головний екран.
    } on AuthFailure catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Welcome back',
      subtitle: 'Log in to keep your game nights organized.',
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.requiredPassword,
                  onFieldSubmitted: (_) => _logIn(),
                  enabled: !_submitting,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        PrimaryButton(
          label: _submitting ? 'Logging in…' : 'Log In',
          expanded: true,
          loading: _submitting,
          onPressed: _logIn,
        ),
        const SizedBox(height: AppSpacing.small),
        TextButton(
          onPressed: _submitting
              ? null
              : () => ForgotPasswordDialog.show(
                  context,
                  initialEmail: _emailController.text.trim(),
                ),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(48, 44),
            textStyle: Theme.of(context).textTheme.labelLarge
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: const Text('Forgot password?'),
        ),
        AuthFooter(
          text: 'New to BoardHub?',
          actionLabel: 'Create account',
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.register),
        ),
      ],
    );
  }
}
