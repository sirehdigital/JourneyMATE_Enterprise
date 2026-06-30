import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

enum AIMonitorStatus { healthy, warning, critical }

class AIMonitorCard extends StatelessWidget {
  const AIMonitorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.status,
    this.subtitle = '',
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final AIMonitorStatus status;

  Color get statusColor {
    switch (status) {
      case AIMonitorStatus.healthy:
        return JMColors.success;
      case AIMonitorStatus.warning:
        return JMColors.warning;
      case AIMonitorStatus.critical:
        return JMColors.error;
    }
  }

  String get statusText {
    switch (status) {
      case AIMonitorStatus.healthy:
        return 'HEALTHY';
      case AIMonitorStatus.warning:
        return 'WARNING';
      case AIMonitorStatus.critical:
        return 'CRITICAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: statusColor.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: Icon(icon, color: statusColor),
              ),
              const Spacer(),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          Text(
            value,
            style: JMTypography.headlineLarge.copyWith(color: statusColor),
          ),

          const SizedBox(height: JMSpacing.xs),

          Text(title, style: JMTypography.titleMedium),

          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: JMSpacing.xs),
            Text(subtitle, style: JMTypography.bodySmall),
          ],

          const Spacer(),

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
              statusText,
              style: JMTypography.labelSmall.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
