import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'ai_agent_grid.dart';

class AIAgentStatusPanel extends StatelessWidget {
  const AIAgentStatusPanel({super.key});

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
                child: const Icon(Icons.hub_rounded, color: JMColors.ai),
              ),

              const SizedBox(width: JMSpacing.lg),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Agent Status', style: JMTypography.titleLarge),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Enterprise Multi-Agent Monitoring',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //--------------------------------------------------
          // Summary
          //--------------------------------------------------
          Container(
            padding: const EdgeInsets.all(JMSpacing.lg),
            decoration: BoxDecoration(
              color: JMColors.background,
              borderRadius: JMRadius.radiusMD,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatusItem(
                  label: 'Online',
                  value: '5',
                  color: JMColors.success,
                ),
                _StatusItem(label: 'Busy', value: '2', color: JMColors.primary),
                _StatusItem(
                  label: 'Syncing',
                  value: '1',
                  color: JMColors.warning,
                ),
                _StatusItem(
                  label: 'Offline',
                  value: '1',
                  color: JMColors.error,
                ),
              ],
            ),
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // AI Grid
          //--------------------------------------------------
          const AIAgentGrid(),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: JMTypography.headlineSmall.copyWith(color: color)),
        const SizedBox(height: JMSpacing.xs),
        Text(label, style: JMTypography.labelSmall),
      ],
    );
  }
}
