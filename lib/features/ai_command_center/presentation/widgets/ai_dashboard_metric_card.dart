import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIDashboardMetricCard extends StatelessWidget {
  const AIDashboardMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle = '',
    this.trend = '',
  });

  final String title;
  final String value;
  final String subtitle;
  final String trend;
  final IconData icon;
  final Color color;

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
          //--------------------------------------------------
          // Top Row
          //--------------------------------------------------
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: Icon(icon, color: color, size: 28),
              ),

              const Spacer(),

              Icon(Icons.trending_up_rounded, color: color, size: 22),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //--------------------------------------------------
          // Metric Value
          //--------------------------------------------------
          Text(value, style: JMTypography.headlineLarge.copyWith(color: color)),

          const SizedBox(height: JMSpacing.xs),

          //--------------------------------------------------
          // Metric Title
          //--------------------------------------------------
          Text(title, style: JMTypography.titleMedium),

          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: JMSpacing.xs),
            Text(subtitle, style: JMTypography.bodySmall),
          ],

          const Spacer(),

          //--------------------------------------------------
          // Trend
          //--------------------------------------------------
          if (trend.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: JMSpacing.sm,
                vertical: JMSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                borderRadius: JMRadius.radiusPill,
              ),
              child: Text(
                trend,
                style: JMTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
