import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIAgentMessage extends StatelessWidget {
  const AIAgentMessage({
    super.key,
    required this.agentName,
    required this.message,
    required this.icon,
    required this.agentColor,
    this.timestamp = 'Just now',
  });

  final String agentName;
  final String message;
  final IconData icon;
  final Color agentColor;
  final String timestamp;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //--------------------------------------------------
          // Agent Avatar
          //--------------------------------------------------
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: agentColor.withOpacity(.10),
              borderRadius: JMRadius.radiusPill,
            ),
            child: Icon(icon, color: agentColor, size: 26),
          ),

          const SizedBox(width: JMSpacing.lg),

          //--------------------------------------------------
          // Message Content
          //--------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //------------------------------------------------
                // Header
                //------------------------------------------------
                Row(
                  children: [
                    Expanded(
                      child: Text(agentName, style: JMTypography.titleMedium),
                    ),

                    Text(timestamp, style: JMTypography.labelSmall),
                  ],
                ),

                const SizedBox(height: JMSpacing.xs),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: JMSpacing.sm,
                    vertical: JMSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: JMColors.success.withOpacity(.10),
                    borderRadius: JMRadius.radiusPill,
                  ),
                  child: const Text(
                    'ONLINE',
                    style: TextStyle(
                      color: JMColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: JMSpacing.md),

                //------------------------------------------------
                // AI Message
                //------------------------------------------------
                Text(message, style: JMTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
