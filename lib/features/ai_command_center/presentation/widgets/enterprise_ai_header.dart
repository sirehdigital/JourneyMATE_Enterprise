import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class EnterpriseAIHeader extends StatelessWidget {
  const EnterpriseAIHeader({super.key, this.userName = 'Abang'});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JMSpacing.cardPadding),
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: JMRadius.radiusLG,
        border: Border.all(color: JMColors.border),
        boxShadow: JMShadows.card,
      ),
      child: Row(
        children: [
          //---------------------------------------------
          // Avatar
          //---------------------------------------------
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: JMColors.primary.withValues(alpha: 0.10),
              borderRadius: JMRadius.radiusPill,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: JMColors.primary,
              size: 30,
            ),
          ),

          const SizedBox(width: JMSpacing.lg),

          //---------------------------------------------
          // Greeting
          //---------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning, $userName 👋',
                  style: JMTypography.titleLarge,
                ),

                const SizedBox(height: JMSpacing.xs),

                const Text(
                  'Enterprise AI Command Center',
                  style: JMTypography.bodyMedium,
                ),

                const SizedBox(height: JMSpacing.sm),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: JMSpacing.sm,
                    vertical: JMSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: JMColors.success.withValues(alpha: 0.10),
                    borderRadius: JMRadius.radiusPill,
                  ),
                  child: const Text(
                    'AI System Online',
                    style: TextStyle(
                      color: JMColors.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //---------------------------------------------
          // Notification
          //---------------------------------------------
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: JMColors.background,
              borderRadius: JMRadius.radiusMD,
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: JMColors.textPrimary,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: JMColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
