import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/data/app_user.dart';
import 'edit_profile_dialog.dart';

/// Картка з фото, кнопкою редагування та даними облікового запису.
class ProfileInfoCard extends StatelessWidget {
  final AppUser user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: UserAvatar(
              photoUrl: user.photoUrl,
              initials: user.initials,
              size: 92,
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          Center(
            child: SecondaryButton(
              label: 'Edit Profile',
              icon: Icons.edit_outlined,
              onPressed: () => EditProfileDialog.show(context, user),
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          const Divider(),
          const SizedBox(height: AppSpacing.large),
          _InfoField(label: 'Username', value: user.name),
          const SizedBox(height: AppSpacing.medium),
          _InfoField(label: 'Email', value: user.email),
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;

  const _InfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.textFaint,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
