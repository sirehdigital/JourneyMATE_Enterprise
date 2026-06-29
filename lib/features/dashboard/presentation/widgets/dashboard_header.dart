import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning, Abang 👋',
                style: JMTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: JMSpacing.xs),

              Text(
                'AI Travel Assistant',
                style: JMTypography.titleMedium.copyWith(
                  color: JMColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Always ready to plan your next adventure.',
                style: JMTypography.bodyMedium.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: JMColors.primary,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: JMColors.primary.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}
