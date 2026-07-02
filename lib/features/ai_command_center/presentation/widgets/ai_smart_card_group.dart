import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import '../../../travel_ai/cards/rendering/models/rendered_card_group.dart';
import 'ai_smart_card.dart';

class AISMARTCardGroup extends StatelessWidget {
  const AISMARTCardGroup({super.key, required this.group});

  final RenderedCardGroup group;

  @override
  Widget build(BuildContext context) {
    if (group.cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: JMSpacing.md),
      padding: const EdgeInsets.all(JMSpacing.md),
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: BorderRadius.circular(JMRadius.lg),
        border: Border.all(color: JMColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
            style: JMTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: JMColors.textPrimary,
            ),
          ),
          if (group.subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: JMSpacing.xs),
            Text(
              group.subtitle.trim(),
              style: JMTypography.bodySmall.copyWith(
                color: JMColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: JMSpacing.sm),
          ...group.cards.map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: JMSpacing.sm),
              child: AISMARTCard(card: card),
            ),
          ),
        ],
      ),
    );
  }
}
