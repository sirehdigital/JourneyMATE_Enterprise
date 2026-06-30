import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'notification_badge.dart';
import 'notification_tile.dart';

class AINotificationFeed extends StatelessWidget {
  const AINotificationFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: JMColors.ai.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: JMColors.ai,
                ),
              ),
              const SizedBox(width: JMSpacing.lg),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Notification Feed',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Real-time AI events & travel alerts',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //------------------------------------------
          // Notifications
          //------------------------------------------

          const NotificationTile(
            title: 'New AI Recommendation',
            message:
                'JourneyMATE AI found a better itinerary with RM120 savings.',
            time: 'Just now',
            icon: Icons.auto_awesome_rounded,
            iconColor: JMColors.ai,
            priority: NotificationPriority.high,
          ),

          const SizedBox(height: JMSpacing.lg),

          const NotificationTile(
            title: 'Flight Price Dropped',
            message:
                'Airfare to Kota Bharu decreased by RM38.',
            time: '5 minutes ago',
            icon: Icons.flight_takeoff_rounded,
            iconColor: JMColors.flight,
            priority: NotificationPriority.medium,
          ),

          const SizedBox(height: JMSpacing.lg),

          const NotificationTile(
            title: 'Hotel Promotion',
            message:
                'Partner hotel offers 25% discount for your selected dates.',
            time: '18 minutes ago',
            icon: Icons.hotel_rounded,
            iconColor: JMColors.hotel,
            priority: NotificationPriority.low,
            isRead: true,
          ),

          const SizedBox(height: JMSpacing.lg),

          const NotificationTile(
            title: 'Weather Advisory',
            message:
                'Heavy rain is forecast tomorrow afternoon