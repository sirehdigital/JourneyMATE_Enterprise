import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

import 'ai_monitor_grid.dart';

class LiveAIMonitoring extends StatelessWidget {
  const LiveAIMonitoring({super.key});

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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: JMColors.ai.withOpacity(.10),
                  borderRadius: JMRadius.radiusLG,
                ),
                child: const Icon(
                  Icons.monitor_heart_rounded,
                  color: JMColors.ai,
                  size: 30,
                ),
              ),

              const SizedBox(width: JMSpacing.lg),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Live AI Monitoring', style: JMTypography.titleLarge),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Enterprise AI Health Dashboard',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // System Status
          //--------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(JMSpacing.lg),
            decoration: BoxDecoration(
              color: JMColors.background,
              borderRadius: JMRadius.radiusMD,
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: JMColors.success),

                const SizedBox(width: JMSpacing.md),

                Expanded(
                  child: Text(
                    'All enterprise AI services are online and operating normally.',
                    style: JMTypography.bodyMedium.copyWith(
                      color: JMColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Monitor Grid
          //--------------------------------------------------
          const AIMonitorGrid(),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Realtime Footer
          //--------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(JMSpacing.lg),
            decoration: BoxDecoration(
              color: JMColors.ai.withOpacity(.05),
              borderRadius: JMRadius.radiusMD,
              border: Border.all(color: JMColors.ai.withOpacity(.20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sync_rounded, color: JMColors.ai),

                const SizedBox(width: JMSpacing.md),

                Expanded(
                  child: Text(
                    'Realtime monitoring is active. AI metrics will automatically update when Supabase Realtime and AI Orchestrator are connected.',
                    style: JMTypography.bodySmall,
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
