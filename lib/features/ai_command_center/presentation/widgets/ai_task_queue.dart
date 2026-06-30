import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'task_card.dart';
import 'task_progress.dart';

class AITaskQueue extends StatelessWidget {
  const AITaskQueue({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: JMRadius.radiusLG,
        border: Border.all(color: JMColors.border),
        boxShadow: JMShadows.card,
      ),
      child: Padding(
        padding: const EdgeInsets.all(JMSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------
            // Header
            //----------------------------------
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: JMColors.ai.withOpacity(.10),
                    borderRadius: JMRadius.radiusMD,
                  ),
                  child: const Icon(Icons.queue_rounded, color: JMColors.ai),
                ),
                const SizedBox(width: JMSpacing.lg),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Task Queue', style: JMTypography.titleLarge),
                      SizedBox(height: JMSpacing.xs),
                      Text(
                        'Autonomous AI execution pipeline',
                        style: JMTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: JMSpacing.xxl),

            //----------------------------------
            // Running
            //----------------------------------
            const TaskCard(
              title: 'Generate Kelantan Itinerary',
              description: 'Creating personalised 3 Days 2 Nights travel plan.',
              status: AITaskStatus.running,
              progress: .72,
              eta: '14 sec',
              icon: Icons.route_rounded,
              iconColor: JMColors.primary,
            ),

            //----------------------------------
            // Pending
            //----------------------------------
            const TaskCard(
              title: 'Compare Hotel Prices',
              description:
                  'Searching 42 partner hotels across booking providers.',
              status: AITaskStatus.pending,
              progress: .18,
              eta: 'Waiting',
              icon: Icons.hotel_rounded,
              iconColor: JMColors.hotel,
            ),

            //----------------------------------
            // Completed
            //----------------------------------
            const TaskCard(
              title: 'Flight Analysis',
              description: 'Best airline and fare successfully identified.',
              status: AITaskStatus.completed,
              progress: 1.0,
              eta: 'Completed',
              icon: Icons.flight_takeoff_rounded,
              iconColor: JMColors.success,
            ),

            //----------------------------------
            // Failed
            //----------------------------------
            const TaskCard(
              title: 'Weather Synchronisation',
              description: 'Weather provider timeout. Retry required.',
              status: AITaskStatus.failed,
              progress: .45,
              eta: 'Retry',
              icon: Icons.cloud_off_rounded,
              iconColor: JMColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
