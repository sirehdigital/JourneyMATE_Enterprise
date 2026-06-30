import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

enum AutonomousTaskStatus { pending, running, completed, failed }

enum AutonomousTaskPriority { low, medium, high, critical }

class AutonomousTaskCard extends StatelessWidget {
  const AutonomousTaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.status,
    required this.priority,
    required this.icon,
  });

  final String title;
  final String description;
  final double progress;
  final AutonomousTaskStatus status;
  final AutonomousTaskPriority priority;
  final IconData icon;

  Color get statusColor {
    switch (status) {
      case AutonomousTaskStatus.pending:
        return JMColors.warning;

      case AutonomousTaskStatus.running:
        return JMColors.primary;

      case AutonomousTaskStatus.completed:
        return JMColors.success;

      case AutonomousTaskStatus.failed:
        return JMColors.error;
    }
  }

  String get statusLabel {
    switch (status) {
      case AutonomousTaskStatus.pending:
        return 'PENDING';

      case AutonomousTaskStatus.running:
        return 'RUNNING';

      case AutonomousTaskStatus.completed:
        return 'COMPLETED';

      case AutonomousTaskStatus.failed:
        return 'FAILED';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case AutonomousTaskPriority.low:
        return Colors.grey;

      case AutonomousTaskPriority.medium:
        return JMColors.info;

      case AutonomousTaskPriority.high:
        return JMColors.warning;

      case AutonomousTaskPriority.critical:
        return JMColors.error;
    }
  }

  String get priorityLabel {
    switch (priority) {
      case AutonomousTaskPriority.low:
        return 'LOW';

      case AutonomousTaskPriority.medium:
        return 'MEDIUM';

      case AutonomousTaskPriority.high:
        return 'HIGH';

      case AutonomousTaskPriority.critical:
        return 'CRITICAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          //--------------------------------------------------
          // Header
          //--------------------------------------------------
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: Icon(icon, color: statusColor),
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

          const SizedBox(height: JMSpacing.lg),

          //--------------------------------------------------
          // Progress
          //--------------------------------------------------
          ClipRRect(
            borderRadius: JMRadius.radiusPill,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: statusColor,
              backgroundColor: JMColors.border,
            ),
          ),

          const SizedBox(height: JMSpacing.md),

          Row(
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: JMTypography.labelMedium,
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: JMSpacing.sm,
                  vertical: JMSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(.10),
                  borderRadius: JMRadius.radiusPill,
                ),
                child: Text(
                  priorityLabel,
                  style: JMTypography.labelSmall.copyWith(
                    color: priorityColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: JMSpacing.sm),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: JMSpacing.sm,
                  vertical: JMSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.10),
                  borderRadius: JMRadius.radiusPill,
                ),
                child: Text(
                  statusLabel,
                  style: JMTypography.labelSmall.copyWith(
                    color: statusColor,
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
}
