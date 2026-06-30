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
        border: Border.all(
          color: JMColors.border,
        ),
        boxShadow: JMShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------------------------
          // Header
          //------------------------------------------

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
              Expanded(
                child: Text(
                  title,
                  style: JMTypography.titleLarge,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //------------------------------------------
          // Chart Area
          //------------------------------------------

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartHeight = constraints.maxHeight;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    _ChartBar(
                      value: .55,
                      color: JMColors.primary,
                    ),
                    SizedBox(width: JMSpacing.md),
                    _ChartBar(
                      value: .82,
                      color: JMColors.flight,
                    ),
                    SizedBox(width: JMSpacing.md),
                    _ChartBar(
                      value: .67,
                      color: JMColors.hotel,
                    ),
                    SizedBox(width: JMSpacing.md),
                    _ChartBar(
                      value: .91,
                      color: JMColors.wallet,
                    ),
                    SizedBox(width: JMSpacing.md),
                    _ChartBar(
                      value: .73,
                      color: JMColors.secondary,
                    ),
                    SizedBox(width: JMSpacing.md),
                    _ChartBar(
                      value: .96,
                      color: JMColors.ai,
                    ),
                  ],
                );
              },
            ),
          ),

         