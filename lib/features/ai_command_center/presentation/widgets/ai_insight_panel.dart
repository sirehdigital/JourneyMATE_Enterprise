import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'insight_chart_placeholder.dart';
import 'insight_tile.dart';

class AIInsightPanel extends StatelessWidget {
  const AIInsightPanel({super.key});

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
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: JMColors.primary.withOpacity(.10),
                  borderRadius: JMRadius.radiusLG,
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: JMColors.primary,
                  size: 28,
                ),
              ),

              const SizedBox(width: JMSpacing.lg),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Insight Dashboard',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Enterprise Travel Intelligence',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // KPI Tiles
          //--------------------------------------------------
          Row(
            children: const [
              Expanded(
                child: InsightTile(
                  title: 'Travel Score',
                  value: '96%',
                  subtitle: 'Excellent match',
                  trend: '+4%',
                  icon: Icons.star_rounded,
                  color: JMColors.primary,
                ),
              ),
              SizedBox(width: JMSpacing.lg),
              Expanded(
                child: InsightTile(
                  title: 'Budget Usage',
                  value: 'RM650',
                  subtitle: 'of RM800',
                  trend: '-8%',
                  isPositive: false,
                  icon: Icons.account_balance_wallet_rounded,
                  color: JMColors.wallet,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.lg),

          Row(
            children: const [
              Expanded(
                child: InsightTile(
                  title: 'Destination Match',
                  value: '98%',
                  subtitle: 'AI Confidence',
                  trend: '+2%',
                  icon: Icons.place_rounded,
                  color: JMColors.secondary,
                ),
              ),
              SizedBox(width: JMSpacing.lg),
              Expanded(
                child: InsightTile(
                  title: 'Weather',
                  value: '95%',
                  subtitle: 'Forecast Accuracy',
                  trend: '+1%',
                  icon: Icons.sunny,
                  color: JMColors.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Analytics
          //--------------------------------------------------
          const InsightChartPlaceholder(title: 'Travel Analytics'),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // AI Summary
          //--------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(JMSpacing.lg),
            decoration: BoxDecoration(
              color: JMColors.background,
              borderRadius: JMRadius.radiusLG,
              border: Border.all(color: JMColors.border),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome_rounded, color: JMColors.ai),
                SizedBox(width: JMSpacing.md),
                Expanded(
                  child: Text(
                    'JourneyMATE AI predicts this itinerary has a very high success rate based on travel preferences, weather conditions, accommodation availability, transportation options and estimated budget.',
                    style: JMTypography.bodyMedium,
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
