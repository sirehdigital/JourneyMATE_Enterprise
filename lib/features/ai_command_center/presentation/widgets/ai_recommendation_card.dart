import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIRecommendationCard extends StatelessWidget {
  const AIRecommendationCard({
    super.key,
    required this.destination,
    required this.flightPrice,
    required this.hotelPrice,
    required this.weather,
    required this.budget,
    this.aiScore = 98,
    this.onViewDetails,
  });

  final String destination;
  final String flightPrice;
  final String hotelPrice;
  final String weather;
  final String budget;
  final int aiScore;
  final VoidCallback? onViewDetails;

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
                  color: JMColors.ai.withValues(alpha: 0.10),
                  borderRadius: JMRadius.radiusLG,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: JMColors.ai,
                  size: 28,
                ),
              ),

              const SizedBox(width: JMSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Recommendation',
                      style: JMTypography.titleLarge,
                    ),

                    const SizedBox(height: JMSpacing.xs),

                    Text(destination, style: JMTypography.bodyMedium),
                  ],
                ),
              ),

              _AIScoreBadge(score: aiScore),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //--------------------------------------------------
          // Recommendation
          //--------------------------------------------------
          const Text('Recommended Plan', style: JMTypography.titleMedium),

          const SizedBox(height: JMSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _RecommendationTile(
                  icon: Icons.flight_takeoff_rounded,
                  title: 'Flight',
                  value: flightPrice,
                  color: JMColors.flight,
                ),
              ),

              const SizedBox(width: JMSpacing.md),

              Expanded(
                child: _RecommendationTile(
                  icon: Icons.hotel_rounded,
                  title: 'Hotel',
                  value: hotelPrice,
                  color: JMColors.hotel,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.md),

          Row(
            children: [
              Expanded(
                child: _RecommendationTile(
                  icon: Icons.sunny,
                  title: 'Weather',
                  value: weather,
                  color: JMColors.warning,
                ),
              ),

              const SizedBox(width: JMSpacing.md),

              Expanded(
                child: _RecommendationTile(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Budget',
                  value: budget,
                  color: JMColors.wallet,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          SizedBox(
            width: double.infinity,
            height: JMSpacing.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: onViewDetails,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text(
                'View Recommendation',
                style: JMTypography.button,
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: JMColors.primary,
                foregroundColor: JMColors.textInverse,
                shape: RoundedRectangleBorder(borderRadius: JMRadius.radiusLG),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AIScoreBadge extends StatelessWidget {
  const _AIScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JMSpacing.md,
        vertical: JMSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: JMColors.success.withValues(alpha: 0.10),
        borderRadius: JMRadius.radiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: JMColors.success, size: 18),

          const SizedBox(width: JMSpacing.sm),

          Text(
            '$score%',
            style: const TextStyle(
              color: JMColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JMSpacing.lg),
      decoration: BoxDecoration(
        color: JMColors.background,
        borderRadius: JMRadius.radiusMD,
        border: Border.all(color: JMColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),

          const SizedBox(height: JMSpacing.md),

          Text(title, style: JMTypography.labelMedium),

          const SizedBox(height: JMSpacing.xs),

          Text(value, style: JMTypography.titleMedium),
        ],
      ),
    );
  }
}
