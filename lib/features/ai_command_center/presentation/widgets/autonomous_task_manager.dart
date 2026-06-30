import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

import 'autonomous_task_list.dart';

class AutonomousTaskManager extends StatelessWidget {
  const AutonomousTaskManager({super.key});

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
                  Icons.auto_mode_rounded,
                  color: JMColors.ai,
                  size: 30,
                ),
              ),

              const SizedBox(width: JMSpacing.lg),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Autonomous Task Manager',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Enterprise AI execution engine',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Summary Cards
          //--------------------------------------------------
          Row(
            children: const [
              Expanded(
                child: _TaskSummaryCard(
                  title: 'Running',
                  value: '2',
                  color: JMColors.primary,
                  icon: Icons.play_circle_fill_rounded,
                ),
              ),
              SizedBox(width: JMSpacing.lg),
              Expanded(
                child: _TaskSummaryCard(
                  title: 'Completed',
                  value: '1',
                  color: JMColors.success,
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.lg),

          Row(
            children: const [
              Expanded(
                child: _TaskSummaryCard(
                  title: 'Pending',
                  value: '1',
                  color: JMColors.warning,
                  icon: Icons.schedule_rounded,
                ),
              ),
              SizedBox(width: JMSpacing.lg),
              Expanded(
                child: _TaskSummaryCard(
                  title: 'Failed',
                  value: '1',
                  color: JMColors.error,
                  icon: Icons.error_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Autonomous Task Queue
          //--------------------------------------------------
          const AutonomousTaskList(),

          const SizedBox(height: JMSpacing.xxl),

          //--------------------------------------------------
          // Footer Status
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
                const Icon(Icons.memory_rounded, color: JMColors.ai),
                const SizedBox(width: JMSpacing.md),
                Expanded(
                  child: Text(
                    'AI Autonomous Engine is actively managing travel workflows and monitoring task execution.',
                    style: JMTypography.bodyMedium.copyWith(
                      color: JMColors.textPrimary,
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

class _TaskSummaryCard extends StatelessWidget {
  const _TaskSummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JMSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: JMRadius.radiusMD,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: JMSpacing.md),
          Text(
            value,
            style: JMTypography.headlineMedium.copyWith(color: color),
          ),
          const SizedBox(height: JMSpacing.xs),
          Text(title, style: JMTypography.labelMedium),
        ],
      ),
    );
  }
}
