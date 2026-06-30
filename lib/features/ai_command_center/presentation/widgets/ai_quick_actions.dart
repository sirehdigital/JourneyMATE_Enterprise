import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIQuickActions extends StatelessWidget {
  const AIQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <_QuickActionItem>[
      const _QuickActionItem(
        title: 'Flights',
        icon: Icons.flight_takeoff_rounded,
        color: JMColors.flight,
      ),
      const _QuickActionItem(
        title: 'Hotels',
        icon: Icons.hotel_rounded,
        color: JMColors.hotel,
      ),
      const _QuickActionItem(
        title: 'Trip Planner',
        icon: Icons.map_rounded,
        color: JMColors.primary,
      ),
      const _QuickActionItem(
        title: 'AI Concierge',
        icon: Icons.smart_toy_rounded,
        color: JMColors.ai,
      ),
      const _QuickActionItem(
        title: 'Voice AI',
        icon: Icons.mic_rounded,
        color: JMColors.secondary,
      ),
      const _QuickActionItem(
        title: 'Wallet',
        icon: Icons.account_balance_wallet_rounded,
        color: JMColors.wallet,
      ),
      const _QuickActionItem(
        title: 'Emergency',
        icon: Icons.emergency_rounded,
        color: JMColors.error,
      ),
      const _QuickActionItem(
        title: 'Search',
        icon: Icons.search_rounded,
        color: JMColors.transport,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: JMTypography.titleLarge),
        const SizedBox(height: JMSpacing.lg),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: JMSpacing.lg,
            mainAxisSpacing: JMSpacing.lg,
            childAspectRatio: .85,
          ),
          itemBuilder: (context, index) {
            return _QuickActionCard(item: actions[index]);
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.item});

  final _QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: JMRadius.radiusLG,
      onTap: () {},
      child: Ink(
        decoration: BoxDecoration(
          color: JMColors.card,
          borderRadius: JMRadius.radiusLG,
          border: Border.all(color: JMColors.border),
          boxShadow: JMShadows.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(JMSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: Icon(item.icon, color: item.color, size: 28),
              ),
              const SizedBox(height: JMSpacing.md),
              Text(
                item.title,
                style: JMTypography.labelMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;
}
