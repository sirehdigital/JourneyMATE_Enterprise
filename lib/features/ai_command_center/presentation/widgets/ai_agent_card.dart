import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

enum AIAgentStatus { online, syncing, busy, offline }

class AIAgentCard extends StatelessWidget {
  const AIAgentCard({
    super.key,
    required this.agentName,
    required this.description,
    required this.icon,
    required this.status,
  });

  final String agentName;
  final String description;
  final IconData icon;
  final AIAgentStatus status;

  Color get statusColor {
    switch (status) {
      case AIAgentStatus.online:
        return JMColors.success;

      case AIAgentStatus.syncing:
        return JMColors.warning;

      case AIAgentStatus.busy:
        return JMColors.primary;

      case AIAgentStatus.offline:
        return JMColors.error;
    }
  }

  String get statusText {
    switch (status) {
      case AIAgentStatus.online:
        return 'ONLINE';

      case AIAgentStatus.syncing:
        return 'SYNCING';

      case AIAgentStatus.busy:
        return 'BUSY';

      case AIAgentStatus.offline:
        return 'OFFLINE';
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
          //----------------------------------------
          // Header
          //----------------------------------------
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: Icon(icon, color: statusColor, size: 28),
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

          const SizedBox(height: JMSpacing.lg),

          //----------------------------------------
          // Agent Name
          //----------------------------------------
          Text(agentName, style: JMTypography.titleMedium),

          const SizedBox(height: JMSpacing.xs),

          Text(
            description,
            style: JMTypography.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: JMSpacing.lg),

          //----------------------------------------
          // Status
          //----------------------------------------
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
