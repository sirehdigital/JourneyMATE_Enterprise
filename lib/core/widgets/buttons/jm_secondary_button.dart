import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/radius/jm_radius.dart';
import '../../design/spacing/jm_spacing.dart';
import '../../design/typography/jm_typography.dart';

class JMSecondaryButton extends StatelessWidget {
  const JMSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width = double.infinity,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: JMColors.primary,
          side: BorderSide(color: JMColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: JMSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(JMRadius.xl),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon),
              const SizedBox(width: JMSpacing.sm),
            ],
            Text(
              text,
              style: JMTypography.labelLarge.copyWith(color: JMColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
