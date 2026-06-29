import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/typography/jm_typography.dart';

class ActivityListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ActivityListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: CircleAvatar(
        radius: 24,
        backgroundColor: JMColors.primary.withValues(alpha: .12),
        child: Icon(icon, color: JMColors.primary),
      ),

      title: Text(title, style: JMTypography.titleMedium),

      subtitle: Text(subtitle, style: JMTypography.bodyMedium),

      trailing: const Icon(Icons.chevron_right),
    );
  }
}
