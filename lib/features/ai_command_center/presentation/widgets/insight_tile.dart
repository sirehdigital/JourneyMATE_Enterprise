import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class InsightTile extends StatelessWidget {
  const InsightTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.trend,
    this.isPositive = true,
  });

  final String title;
  final String value;
  final String? subtitle;
  final String? trend;

  final IconData icon;
  final Color color;

  final bool isPositive;

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
          //------------------------------------------------
          // Header
          //------------------------------------------------
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: Icon(icon, color: color, size: 24),
              ),

              const Spacer(),

              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: JMSpacing.sm,
                    vertical: JMSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: (isPositive ? JMColors.success : JMColors.error)
                        .withOpacity(.10),
                    borderRadius: JMRadius.radiusPill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: isPositive ? JMColors.success : JMColors.error,
                        size: 16,
                      ),
                      const SizedBox(width: JMSpacing.xs),
                      Text(
                        trend!,
                        style: JMTypography.labelSmall.copyWith(
                          color: isPositive ? JMColors.success : JMColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //------------------------------------------------
          // Value
          //------------------------------------------------
          Text(value, style: JMTypography.headlineMedium),

          const SizedBox(height: JMSpacing.sm),

          Text(title, style: JMTypography.titleSmall),

          if (subtitle != null) ...[
            const SizedBox(height: JMSpacing.xs),

            Text(subtitle!, style: JMTypography.bodySmall),
          ],
        ],
      ),
    );
  }
}
