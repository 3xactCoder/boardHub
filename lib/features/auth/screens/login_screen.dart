import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../widgets/auth_card.dart';
import '../widgets/forgot_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    // Без бізнес-логіки: одразу відкриваємо головний екран,
    // як у випадку успішної авторизації.
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Welcome back',
      subtitle: 'Log in to keep your game nights organized.',
      children: [
        AppTextField(
          label: 'Email',
          hint: 'you@example.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.medium),
        AppTextField(
          label: 'Password',
          hint: '••••••••',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.large),
        PrimaryButton(label: 'Log In', expanded: true, onPressed: _logIn),
        const SizedBox(height: AppSpacing.small),
        TextButton(
          onPressed: () => ForgotPasswordDialog.show(context),
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
