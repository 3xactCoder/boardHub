import 'package:flutter/material.dart';

import '../../../core/di/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/icon_badge.dart';

/// Перевірка інтеграції Sentry: оброблена та необроблена помилки.
/// Показується, лише коли Sentry налаштовано (задано DSN).
class DiagnosticsCard extends StatelessWidget {
  const DiagnosticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final crashReporter = AppScope.of(context).crashReporter;
    if (!crashReporter.isEnabled) return const SizedBox.shrink();

    return AppCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              IconBadge(icon: Icons.bug_report_outlined),
              SizedBox(width: AppSpacing.normal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crash reporting',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Send a test report to Sentry.',
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
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              SecondaryButton(
                label: 'Report Score Parse Error',
                icon: Icons.report_outlined,
                onPressed: () async {
                  await crashReporter.recordTestError();
                  if (context.mounted) {
                    showAppSnackBar(
                      context,
                      'FormatException reported to Sentry.',
                    );
                  }
                },
              ),
              SecondaryButton(
                label: 'Open Empty Match (crash)',
                icon: Icons.warning_amber_outlined,
                onPressed: crashReporter.throwUnhandledError,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
