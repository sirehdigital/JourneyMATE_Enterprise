import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

enum NotificationPriority { low, medium, high, critical }

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key, required this.priority, this.label});

  final NotificationPriority priority;
  final String? label;

  Color get _color {
    switch (priority) {
      case NotificationPriority.low:
        return JMColors.info;

      case NotificationPriority.medium:
        return JMColors.warning;

      case NotificationPriority.high:
        return JMColors.primary;

      case NotificationPriority.critical:
        return JMColors.error;
    }
  }

  IconData get _icon {
    switch (priority) {
      case NotificationPriority.low:
        return Icons.notifications_none_rounded;

      case NotificationPriority.medium:
        return Icons.notifications_active_rounded;

      case NotificationPriority.high:
        return Icons.priority_high_rounded;

      case NotificationPriority.critical:
        return Icons.warning_rounded;
    }
  }

  String get _defaultLabel {
    switch (priority) {
      case NotificationPriority.low:
        return 'LOW';

      case NotificationPriority.medium:
        return 'MEDIUM';

      case NotificationPriority.high:
        return 'HIGH';

      case NotificationPriority.critical:
        return 'CRITICAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JMSpacing.md,
        vertical: JMSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(.10),
        borderRadius: JMRadius.radiusPill,
        border: Border.all(color: _color.withOpacity(.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 16, color: _color),

          const SizedBox(width: JMSpacing.sm),

          Text(
            label ?? _defaultLabel,
            style: JMTypography.labelSmall.copyWith(
              color: _color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
