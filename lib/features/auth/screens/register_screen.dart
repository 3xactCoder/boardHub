import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../widgets/auth_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    // Без бізнес-логіки: після «реєстрації» відкриваємо головний екран
    // і прибираємо екрани авторизації зі стеку.
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  void _backToLogin() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Create your account',
      subtitle: 'Start tracking your favorite table sessions.',
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
          hint: 'At least 8 characters',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.large),
        PrimaryButton(
          label: 'Create Account',
          expanded: true,
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
