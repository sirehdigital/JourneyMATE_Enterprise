import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'notification_badge.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.priority,
    this.isRead = false,
    this.onTap,
  });

  final String title;
  final String message;
  final String time;

  final IconData icon;
  final Color iconColor;

  final NotificationPriority priority;

  final bool isRead;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: JMRadius.radiusLG,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(JMSpacing.cardPadding),
          decoration: BoxDecoration(
            color: isRead ? JMColors.card : JMColors.primary.withOpacity(.03),
            borderRadius: JMRadius.radiusLG,
            border: Border.all(color: JMColors.border),
            boxShadow: JMShadows.card,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //------------------------------------------
              // Notification Icon
              //------------------------------------------
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),

              const SizedBox(width: JMSpacing.lg),

              //------------------------------------------
              // Content
              //------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, style: JMTypography.titleMedium),
                        ),
                        NotificationBadge(priority: priority),
                      ],
                    ),

                    const SizedBox(height: JMSpacing.sm),

                    Text(message, style: JMTypography.bodyMedium),

                    const SizedBox(height: JMSpacing.md),

                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: JMColors.textSecondary,
                        ),
                        const SizedBox(width: JMSpacing.xs),
                        Text(time, style: JMTypography.labelSmall),
                        const Spacer(),
                        if (!isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: JMColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
