import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class RecommendationChip extends StatelessWidget {
  const RecommendationChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: JMRadius.radiusPill,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: JMSpacing.lg,
          vertical: JMSpacing.md,
        ),
        decoration: BoxDecoration(
          color: selected ? color : JMColors.card,
          borderRadius: JMRadius.radiusPill,
          border: Border.all(color: selected ? color : JMColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? JMColors.textInverse : color,
            ),
            const SizedBox(width: JMSpacing.sm),
            Text(
              label,
              style: JMTypography.labelMedium.copyWith(
                color: selected ? JMColors.textInverse : JMColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendationChips extends StatelessWidget {
  const RecommendationChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: JMSpacing.sm,
      runSpacing: JMSpacing.sm,
      children: const [
        RecommendationChip(
          label: 'Flight',
          icon: Icons.flight_takeoff_rounded,
          color: JMColors.flight,
          selected: true,
        ),
        RecommendationChip(
          label: 'Hotel',
          icon: Icons.hotel_rounded,
          color: JMColors.hotel,
        ),
        RecommendationChip(
          label: 'Food',
          icon: Icons.restaurant_rounded,
          color: JMColors.food,
        ),
        RecommendationChip(
          label: 'Attraction',
          icon: Icons.place_rounded,
          color: JMColors.primary,
        ),
        RecommendationChip(
          label: 'Weather',
          icon: Icons.sunny,
          color: JMColors.warning,
        ),
        RecommendationChip(
          label: 'Budget',
          icon: Icons.account_balance_wallet_rounded,
          color: JMColors.wallet,
        ),
        RecommendationChip(
          label: 'Family',
          icon: Icons.family_restroom_rounded,
          color: JMColors.secondary,
        ),
        RecommendationChip(
          label: 'Adventure',
          icon: Icons.landscape_rounded,
          color: JMColors.ai,
        ),
      ],
    );
  }
}
