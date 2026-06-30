import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class InsightChartPlaceholder extends StatelessWidget {
  const InsightChartPlaceholder({
    super.key,
    this.title = 'Travel Analytics',
    this.height = 220,
  });

  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: JMColors.primary.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: JMColors.primary,
                ),
              ),
              const SizedBox(width: JMSpacing.md),
              Expanded(child: Text(title, style: JMTypography.titleLarge)),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //--------------------------------------------------
          // Placeholder Chart
          //--------------------------------------------------
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Expanded(
                  child: _ChartBar(
                    value: 0.45,
                    color: JMColors.primary,
                    label: 'Mon',
                  ),
                ),
                SizedBox(width: JMSpacing.sm),
                Expanded(
                  child: _ChartBar(
                    value: 0.70,
                    color: JMColors.flight,
                    label: 'Tue',
                  ),
                ),
                SizedBox(width: JMSpacing.sm),
                Expanded(
                  child: _ChartBar(
                    value: 0.60,
                    color: JMColors.hotel,
                    label: 'Wed',
                  ),
                ),
                SizedBox(width: JMSpacing.sm),
                Expanded(
                  child: _ChartBar(
                    value: 0.92,
                    color: JMColors.wallet,
                    label: 'Thu',
                  ),
                ),
                SizedBox(width: JMSpacing.sm),
                Expanded(
                  child: _ChartBar(
                    value: 0.75,
                    color: JMColors.secondary,
                    label: 'Fri',
                  ),
                ),
                SizedBox(width: JMSpacing.sm),
                Expanded(
                  child: _ChartBar(
                    value: 1.0,
                    color: JMColors.ai,
                    label: 'Sat',
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

class _ChartBar extends StatelessWidget {
  const _ChartBar({
    required this.value,
    required this.color,
    required this.label,
  });

  final double value;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barHeight = constraints.maxHeight * value;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 22,
              height: barHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: JMSpacing.sm),
            Text(label, style: JMTypography.labelSmall),
          ],
        );
      },
    );
  }
}
