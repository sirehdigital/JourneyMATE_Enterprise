import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/radius/jm_radius.dart';
import '../../design/shadows/jm_shadows.dart';
import '../../design/spacing/jm_spacing.dart';
import '../../design/typography/jm_typography.dart';

class JMMetricCard extends StatelessWidget {
  const JMMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(JMSpacing.lg),
      decoration: BoxDecoration(
        color: JMColors.surface,
        borderRadius: BorderRadius.circular(JMRadius.xl),
        boxShadow: JMShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: (iconColor ?? JMColors.primary).withOpacity(.12),
            child: Icon(icon, color: iconColor ?? JMColors.primary),
          ),

          const SizedBox(height: JMSpacing.lg),

          Text(value, style: JMTypography.headlineMedium),

          const SizedBox(height: JMSpacing.xs),

          Text(title, style: JMTypography.bodyMedium),

          if (subtitle != null) ...[
            const SizedBox(height: JMSpacing.sm),
            Text(subtitle!, style: JMTypography.labelMedium),
          ],
        ],
      ),
    );

    if (onTap == null) return card;

    return InkWell(
      borderRadius: BorderRadius.circular(JMRadius.xl),
      onTap: onTap,
      child: card,
    );
  }
}
