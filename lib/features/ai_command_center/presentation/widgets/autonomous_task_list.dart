import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'autonomous_task_card.dart';

class AutonomousTaskList extends StatelessWidget {
  const AutonomousTaskList({super.key});

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
                child: const Icon(Icons.task_alt_rounded, color: JMColors.ai),
              ),

              const SizedBox(width: JMSpacing.lg),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Autonomous Task Queue',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'AI-managed execution pipeline',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Tasks
          //--------------------------------------------------
          const AutonomousTaskCard(
            title: 'Optimize Flight Booking',
            description: 'AI is searching for the best available airfare.',
            progress: 0.78,
            status: AutonomousTaskStatus.running,
            priority: AutonomousTaskPriority.high,
            icon: Icons.flight_takeoff_rounded,
          ),

          const AutonomousTaskCard(
            title: 'Reserve Hotel',
            description: 'Accommodation booking has been confirmed.',
            progress: 1.0,
            status: AutonomousTaskStatus.completed,
            priority: AutonomousTaskPriority.medium,
            icon: Icons.hotel_rounded,
          ),

          const AutonomousTaskCard(
            title: 'Monitor Weather',
            description: 'Waiting for the latest weather forecast update.',
            progress: 0.35,
            status: AutonomousTaskStatus.pending,
            priority: AutonomousTaskPriority.medium,
            icon: Icons.cloud_rounded,
          ),

          const AutonomousTaskCard(
            title: 'Update Travel Budget',
            description: 'Synchronizing wallet and travel expenses.',
            progress: 0.62,
            status: AutonomousTaskStatus.running,
            priority: AutonomousTaskPriority.high,
            icon: Icons.account_balance_wallet_rounded,
          ),

          const AutonomousTaskCard(
            title: 'Emergency Risk Analysis',
            description: 'Unable to retrieve regional safety information.',
            progress: 0.15,
            status: AutonomousTaskStatus.failed,
            priority: AutonomousTaskPriority.critical,
            icon: Icons.warning_amber_rounded,
          ),
        ],
      ),
    );
  }
}
