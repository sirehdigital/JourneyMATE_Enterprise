import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'ai_dashboard_metric_card.dart';

class AIDashboardSummary extends StatelessWidget {
  const AIDashboardSummary({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //--------------------------------------------------
          // Header
          //--------------------------------------------------
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: JMColors.ai.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: const Icon(Icons.analytics_rounded, color: JMColors.ai),
              ),

              const SizedBox(width: JMSpacing.lg),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Dashboard Summary',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Enterprise AI performance overview',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Metrics
          //--------------------------------------------------
          SizedBox(
            height: 420,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: JMSpacing.lg,
              mainAxisSpacing: JMSpacing.lg,
              childAspectRatio: 1.15,
              children: const [
                AIDashboardMetricCard(
                  title: 'AI Agents',
                  value: '8',
                  subtitle: 'Currently Online',
                  trend: '+2 Today',
                  icon: Icons.smart_toy_rounded,
                  color: JMColors.success,
                ),

                AIDashboardMetricCard(
                  title: 'Active Tasks',
                  value: '24',
                  subtitle: 'Running Now',
                  trend: '+5%',
                  icon: Icons.task_alt_rounded,
                  color: JMColors.primary,
                ),

                AIDashboardMetricCard(
                  title: 'AI Chats',
                  value: '152',
                  subtitle: 'Processed Today',
                  trend: '+18%',
                  icon: Icons.forum_rounded,
                  color: JMColors.ai,
                ),

                AIDashboardMetricCard(
                  title: 'System Health',
                  value: '99%',
                  subtitle: 'Operational',
                  trend: 'Excellent',
                  icon: Icons.health_and_safety_rounded,
                  color: JMColors.warning,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
