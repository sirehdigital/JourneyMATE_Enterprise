import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

enum AITaskStatus { pending, running, completed, failed }

class TaskProgress extends StatelessWidget {
  const TaskProgress({
    super.key,
    required this.progress,
    required this.status,
    this.height = 8,
  });

  final double progress;
  final AITaskStatus status;
  final double height;

  Color get _statusColor {
    switch (status) {
      case AITaskStatus.running:
        return JMColors.primary;

      case AITaskStatus.completed:
        return JMColors.success;

      case AITaskStatus.pending:
        return JMColors.warning;

      case AITaskStatus.failed:
        return JMColors.error;
    }
  }

  String get _statusLabel {
    switch (status) {
      case AITaskStatus.running:
        return 'Running';

      case AITaskStatus.completed:
        return 'Completed';

      case AITaskStatus.pending:
        return 'Pending';

      case AITaskStatus.failed:
        return 'Failed';
    }
  }

  IconData get _statusIcon {
    switch (status) {
      case AITaskStatus.running:
        return Icons.autorenew_rounded;

      case AITaskStatus.completed:
        return Icons.check_circle_rounded;

      case AITaskStatus.pending:
        return Icons.schedule_rounded;

      case AITaskStatus.failed:
        return Icons.error_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------------------
        // Status
        //------------------------------------------
        Row(
          children: [
            Icon(_statusIcon, size: 18, color: _statusColor),

            const SizedBox(width: JMSpacing.sm),

            Text(
              _statusLabel,
              style: JMTypography.labelMedium.copyWith(color: _statusColor),
            ),

            const Spacer(),

            Text('${(value * 100).toInt()}%', style: JMTypography.labelMedium),
          ],
        ),

        const SizedBox(height: JMSpacing.md),

        //------------------------------------------
        // Progress Bar
        //------------------------------------------
        ClipRRect(
          borderRadius: JMRadius.radiusPill,
          child: LinearProgressIndicator(
            value: value,
            minHeight: height,
            backgroundColor: JMColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
          ),
        ),
      ],
    );
  }
}
