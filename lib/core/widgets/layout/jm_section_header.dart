import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/spacing/jm_spacing.dart';
import '../../design/typography/jm_typography.dart';

class JMSectionHeader extends StatelessWidget {
  const JMSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: JMSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: JMTypography.titleLarge),

                if (subtitle != null) ...[
                  const SizedBox(height: JMSpacing.xs),
                  Text(
                    subtitle!,
                    style: JMTypography.bodyMedium.copyWith(
                      color: JMColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (actionText != null)
            TextButton(onPressed: onActionPressed, child: Text(actionText!)),
        ],
      ),
    );
  }
}
