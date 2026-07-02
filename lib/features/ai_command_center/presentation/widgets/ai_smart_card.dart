import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import '../../../travel_ai/cards/rendering/models/rendered_card.dart';

class AISMARTCard extends StatelessWidget {
  const AISMARTCard({super.key, required this.card});

  final RenderedCard card;

  @override
  Widget build(BuildContext context) {
    final confidence = _confidenceLabel(card.metadata['confidence']);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JMSpacing.md),
      decoration: BoxDecoration(
        color: JMColors.surface,
        borderRadius: BorderRadius.circular(JMRadius.md),
        border: Border.all(color: JMColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: JMColors.ai.withOpacity(.12),
                  borderRadius: BorderRadius.circular(JMRadius.sm),
                ),
                child: Icon(
                  _iconFor(card.icon, card.type),
                  color: JMColors.ai,
                  size: 18,
                ),
              ),
              const SizedBox(width: JMSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: JMTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: JMColors.textPrimary,
                      ),
                    ),
                    if (card.subtitle.trim().isNotEmpty) ...[
                      const SizedBox(height: JMSpacing.xs),
                      Text(
                        card.subtitle.trim(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: JMTypography.bodySmall.copyWith(
                          color: JMColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (confidence.isNotEmpty) ...[
            const SizedBox(height: JMSpacing.sm),
            _InfoPill(label: confidence, icon: Icons.star_rounded),
          ],
          const SizedBox(height: JMSpacing.sm),
          Wrap(
            spacing: JMSpacing.xs,
            runSpacing: JMSpacing.xs,
            children: [
              if (card.expandable)
                const _InfoPill(label: 'Expandable', icon: Icons.unfold_more),
              if (card.savable)
                const _InfoPill(label: 'Savable', icon: Icons.bookmark_border),
              if (card.shareable)
                const _InfoPill(label: 'Shareable', icon: Icons.ios_share),
            ],
          ),
          if (card.actions.isNotEmpty) ...[
            const SizedBox(height: JMSpacing.sm),
            Wrap(
              spacing: JMSpacing.xs,
              runSpacing: JMSpacing.xs,
              children: card.actions
                  .map(
                    (action) => OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: JMSpacing.sm,
                        ),
                      ),
                      child: Text(action.label),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }

  String _confidenceLabel(dynamic value) {
    if (value is num) {
      return '${(value.clamp(0, 1) * 100).toStringAsFixed(0)}% confidence';
    }
    final parsed = double.tryParse(value?.toString() ?? '');
    if (parsed == null) {
      return '';
    }
    return '${(parsed.clamp(0, 1) * 100).toStringAsFixed(0)}% confidence';
  }

  IconData _iconFor(String icon, String type) {
    final key = icon.trim().isNotEmpty ? icon : type;
    switch (key) {
      case 'map-pin':
      case 'destination':
        return Icons.place_rounded;
      case 'hotel':
        return Icons.hotel_rounded;
      case 'utensils':
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'calendar':
      case 'timeline':
        return Icons.event_note_rounded;
      case 'wallet':
      case 'budget':
        return Icons.account_balance_wallet_rounded;
      case 'car':
      case 'transport':
        return Icons.directions_car_rounded;
      case 'star':
        return Icons.star_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JMSpacing.sm,
        vertical: JMSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: JMColors.background,
        borderRadius: BorderRadius.circular(JMRadius.pill),
        border: Border.all(color: JMColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: JMColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: JMTypography.labelSmall.copyWith(
              color: JMColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
