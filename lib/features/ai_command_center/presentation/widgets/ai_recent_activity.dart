import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIRecentActivity extends StatelessWidget {
  const AIRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    const activities = [
      _ActivityItem(
        title: 'Flight options generated',
        subtitle: 'Kuala Lumpur → Kota Bharu',
        time: 'Just now',
        icon: Icons.flight_takeoff_rounded,
        color: JMColors.flight,
      ),
      _ActivityItem(
        title: 'Hotel recommendation ready',
        subtitle: '5 hotels matched your preferences',
        time: '5 min ago',
        icon: Icons.hotel_rounded,
        color: JMColors.hotel,
      ),
      _ActivityItem(
        title: 'AI itinerary completed',
        subtitle: '3 Days • 2 Nights Kelantan',
        time: '12 min ago',
        icon: Icons.route_rounded,
        color: JMColors.primary,
      ),
      _ActivityItem(
        title: 'Wallet rewards updated',
        subtitle: '+250 Journey Points',
        time: '1 hour ago',
        icon: Icons.account_balance_wallet_rounded,
        color: JMColors.wallet,
      ),
      _ActivityItem(
        title: 'AI knowledge synchronized',
        subtitle: 'Tourism data successfully updated',
        time: 'Today',
        icon: Icons.sync_rounded,
        color: JMColors.success,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activity', style: JMTypography.titleLarge),
        const SizedBox(height: JMSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: JMColors.card,
            borderRadius: JMRadius.radiusLG,
            border: Border.all(color: JMColors.border),
            boxShadow: JMShadows.card,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: JMColors.divider),
            itemBuilder: (context, index) {
              return _ActivityTile(
                item: activities[index],
                isLast: index == activities.length - 1,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item, required this.isLast});

  final _ActivityItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(JMSpacing.lg),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(.10),
                    borderRadius: JMRadius.radiusMD,
                  ),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: JMSpacing.sm),
                      color: JMColors.divider,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: JMSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: JMTypography.titleSmall),
                  const SizedBox(height: JMSpacing.xs),
                  Text(item.subtitle, style: JMTypography.bodyMedium),
                  const SizedBox(height: JMSpacing.sm),
                  Text(item.time, style: JMTypography.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;
}
