import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'task_progress.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.eta,
    required this.icon,
    this.iconColor = JMColors.primary,
  });

  final String title;
  final String description;
  final AITaskStatus status;
  final double progress;
  final String eta;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: JMSpacing.lg),
      padding: const EdgeInsets.all(JMSpacing.cardPadding),
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: JMRadius.radiusLG,
        border: Border.all(color: JMColors.border),
        boxShadow: JMShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: JMSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: JMTypography.titleMedium),
                    const SizedBox(height: JMSpacing.xs),
                    Text(description, style: JMTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: JMSpacing.xxl),
          TaskProgress(progress: progress, status: status),
          const SizedBox(height: JMSpacing.lg),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 18,
                color: JMColors.textSecondary,
              ),
              const SizedBox(width: JMSpacing.sm),
              Text('ETA : $eta', style: JMTypography.bodySmall),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: JMSpacing.md,
                  vertical: JMSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.08),
                  borderRadius: JMRadius.radiusPill,
                ),
                child: Text(
                  _statusText(status),
                  style: JMTypography.labelSmall.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusText(AITaskStatus status) {
    switch (status) {
      case AITaskStatus.pending:
        return 'PENDING';
      case AITaskStatus.running:
        return 'RUNNING';
      case AITaskStatus.completed:
        return 'COMPLETED';
      case AITaskStatus.failed:
        return 'FAILED';
    }
  }
}
