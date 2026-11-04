import 'package:flutter/material.dart';

import '../../../core/di/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/data/app_user.dart';
import '../../auth/data/auth_failure.dart';
import '../data/avatar_presets.dart';

/// Редагування імені та фото профілю.
///
/// Фото обирається з набору готових зображень або задається власним
/// HTTPS-посиланням з попереднім переглядом.
class EditProfileDialog extends StatefulWidget {
  final AppUser user;

  const EditProfileDialog({super.key, required this.user});

  static Future<void> show(BuildContext context, AppUser user) =>
      showDialog<void>(
        context: context,
        builder: (_) => EditProfileDialog(user: user),
      );

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.user.name);
  late final _urlController = TextEditingController(
    text: _isPreset(widget.user.photoUrl) ? '' : widget.user.photoUrl ?? '',
  );
  late String? _photoUrl = widget.user.photoUrl;
  late bool _customUrl =
      _photoUrl != null && _photoUrl!.isNotEmpty && !_isPreset(_photoUrl);
  bool _submitting = false;

  static bool _isPreset(String? url) => AvatarPresets.urls.contains(url);

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _selectPreset(String? url) => setState(() {
    _customUrl = false;
    _photoUrl = url;
  });

  /// Попередній перегляд показується лише для коректного HTTPS-посилання.
  static String? _previewUrl(String value) {
    final url = value.trim();
    return Validators.httpsImageUrl(url) == null ? url : null;
  }

  void _selectCustom() => setState(() {
    _customUrl = true;
    _photoUrl = _previewUrl(_urlController.text);
  });

  void _onUrlChanged(String value) =>
      setState(() => _photoUrl = _previewUrl(value));

  Future<void> _save() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    final services = AppScope.of(context);
    setState(() => _submitting = true);
    try {
      await services.profileRepository.updateProfile(
        displayName: _nameController.text.trim(),
        photoUrl: _customUrl ? _urlController.text.trim() : _photoUrl,
      );
      services.analytics.logEvent('profile_updated');
      if (!mounted) return;
      Navigator.of(context).pop();
      showAppSnackBar(context, 'Profile updated.');
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
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Edit profile',
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
                const SizedBox(height: AppSpacing.medium),
                Center(
                  child: UserAvatar(
                    photoUrl: _photoUrl,
                    initials: widget.user.initials,
                    size: 92,
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                AppTextField(
                  label: 'Name',
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  validator: Validators.name,
                  enabled: !_submitting,
                ),
                const SizedBox(height: AppSpacing.large),
                const Text(
                  'Photo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLabel,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Wrap(
                  spacing: AppSpacing.small,
                  runSpacing: AppSpacing.small,
                  children: [
                    _PhotoOption(
                      selected: !_customUrl && _photoUrl == null,
                      tooltip: 'No photo',
                      onTap: _submitting ? null : () => _selectPreset(null),
                      child: const Icon(
                        Icons.hide_image_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
                    for (final url in AvatarPresets.urls)
                      _PhotoOption(
                        selected: !_customUrl && _photoUrl == url,
                        tooltip: 'Preset avatar',
                        onTap: _submitting ? null : () => _selectPreset(url),
                        child: UserAvatar(
                          photoUrl: url,
                          initials: '',
                          size: 52,
                        ),
                      ),
                    _PhotoOption(
                      selected: _customUrl,
                      tooltip: 'Custom link',
                      onTap: _submitting ? null : _selectCustom,
                      child: const Icon(Icons.link, color: AppColors.primary),
                    ),
                  ],
                ),
                if (_customUrl) ...[
                  const SizedBox(height: AppSpacing.medium),
                  AppTextField(
                    label: 'Image URL (HTTPS)',
                    hint: 'https://example.com/avatar.png',
                    controller: _urlController,
                    keyboardType: TextInputType.url,
                    validator: Validators.httpsImageUrl,
                    onChanged: _onUrlChanged,
                    enabled: !_submitting,
                  ),
                ],
                const SizedBox(height: AppSpacing.xLarge),
                PrimaryButton(
                  label: _submitting ? 'Saving…' : 'Save Changes',
                  expanded: true,
                  loading: _submitting,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final bool selected;
  final String tooltip;
  final VoidCallback? onTap;
  final Widget child;

  const _PhotoOption({
    required this.selected,
    required this.tooltip,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceMuted,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 3 : 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
