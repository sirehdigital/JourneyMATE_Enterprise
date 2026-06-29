import 'package:flutter/material.dart';

import '../../design/radius/jm_radius.dart';
import '../../design/spacing/jm_spacing.dart';
import '../../design/typography/jm_typography.dart';

enum JMStatusType { success, warning, error, info }

class JMStatusBadge extends StatelessWidget {
  const JMStatusBadge({
    super.key,
    required this.label,
    this.type = JMStatusType.success,
  });

  final String label;
  final JMStatusType type;

  @override
  Widget build(BuildContext context) {
    late Color background;
    late Color foreground;

    switch (type) {
      case JMStatusType.success:
        background = const Color(0xFFE8F8EE);
        foreground = const Color(0xFF16A34A);
        break;

      case JMStatusType.warning:
        background = const Color(0xFFFFF7E6);
        foreground = const Color(0xFFD97706);
        break;

      case JMStatusType.error:
        background = const Color(0xFFFFECEC);
        foreground = const Color(0xFFDC2626);
        break;

      case JMStatusType.info:
        background = const Color(0xFFEAF4FF);
        foreground = const Color(0xFF2563EB);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JMSpacing.md,
        vertical: JMSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(JMRadius.xl),
      ),
      child: Text(
        label,
        style: JMTypography.labelMedium.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
