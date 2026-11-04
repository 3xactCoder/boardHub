import 'package:flutter/material.dart';

import '../../../core/di/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../auth/data/app_user.dart';
import '../../auth/data/auth_failure.dart';

/// Способи входу в акаунт і прив'язка Google до акаунта з паролем.
class SignInMethodsCard extends StatefulWidget {
  final AppUser user;

  const SignInMethodsCard({super.key, required this.user});

  @override
  State<SignInMethodsCard> createState() => _SignInMethodsCardState();
}

class _SignInMethodsCardState extends State<SignInMethodsCard> {
  bool _linking = false;

  Future<void> _linkGoogle() async {
    if (_linking) return;

    final services = AppScope.of(context);
    setState(() => _linking = true);
    try {
      await services.profileRepository.linkGoogle();
      services.analytics.logEvent('google_linked');
      if (mounted) showAppSnackBar(context, 'Google account linked.');
    } on AuthFailure catch (e) {
      if (mounted && !e.isCancelled) {
        showAppSnackBar(context, e.message, isError: true);
      }
    } finally {
      if (mounted) setState(() => _linking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return AppCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              IconBadge(icon: Icons.key_outlined),
              SizedBox(width: AppSpacing.normal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign-in methods',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Use any linked method to open the same account.',
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
          _MethodRow(
            icon: Icons.mail_outline,
            title: 'Email & password',
            linked: user.hasPassword,
          ),
          const Divider(height: AppSpacing.xLarge),
          _MethodRow(
            icon: Icons.g_mobiledata_rounded,
            title: 'Google',
            linked: user.hasGoogle,
            action: user.hasGoogle
                ? null
                : SecondaryButton(
                    label: _linking ? 'Linking…' : 'Link Google',
                    icon: Icons.link,
                    onPressed: _linking ? null : _linkGoogle,
                  ),
          ),
        ],
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool linked;
  final Widget? action;

  const _MethodRow({
    required this.icon,
    required this.title,
    required this.linked,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textBody),
        const SizedBox(width: AppSpacing.normal),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                linked ? 'Linked' : 'Not linked',
                style: TextStyle(
                  fontSize: 13,
                  color: linked ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}
