import 'package:flutter/material.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/initials_avatar.dart';

/// Картка з аватаром, кнопкою «Upload Photo» та даними облікового запису.
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: InitialsAvatar(initials: MockData.userInitials, size: 92),
          ),
          const SizedBox(height: AppSpacing.large),
          Center(
            child: SecondaryButton(
              label: 'Upload Photo',
              icon: Icons.file_upload_outlined,
              // Вибір файлу буде підключено разом із бізнес-логікою.
              onPressed: () => showAppSnackBar(
                context,
                'Photo upload will be available soon.',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          const Divider(),
          const SizedBox(height: AppSpacing.large),
          const _InfoField(label: 'Username', value: MockData.userName),
          const SizedBox(height: AppSpacing.medium),
          const _InfoField(label: 'Email', value: MockData.userEmail),
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
