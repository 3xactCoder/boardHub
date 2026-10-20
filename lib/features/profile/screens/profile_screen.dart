import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/page_container.dart';
import '../../../core/widgets/page_header.dart';
import '../widgets/change_password_card.dart';
import '../widgets/profile_info_card.dart';

/// Екран профілю: аватар, дані користувача та зміна пароля.
class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return PageContainer(
      children: [
        const PageHeader(eyebrow: 'Account settings', title: 'Your profile'),
        const SizedBox(height: AppSpacing.xLarge),
        if (isDesktop)
          Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: const IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: 336, child: ProfileInfoCard()),
                    SizedBox(width: AppSpacing.large),
                    Expanded(child: ChangePasswordCard()),
                  ],
                ),
              ),
            ),
          )
        else ...[
          const ProfileInfoCard(),
          const SizedBox(height: AppSpacing.medium),
          const ChangePasswordCard(),
          const SizedBox(height: AppSpacing.large),
          // На мобільних немає бічного меню, тому вихід розміщено тут.
          SecondaryButton(
            label: 'Log out',
            icon: Icons.logout,
            expanded: true,
            onPressed: onLogout,
          ),
        ],
      ],
    );
  }
}
