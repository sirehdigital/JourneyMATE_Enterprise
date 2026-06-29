import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/radius/jm_radius.dart';
import '../../design/shadows/jm_shadows.dart';
import '../../design/spacing/jm_spacing.dart';

/// JourneyMATE Enterprise standard container.
///
/// Used by:
/// - Dashboard Cards
/// - Wallet Cards
/// - AI Cards
/// - Vendor Cards
/// - Analytics Cards
class JMContainer extends StatelessWidget {
  const JMContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.gradient,
    this.onTap,
    this.shadow = true,
  });

  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final Color? color;

  final BorderRadius? borderRadius;

  final Border? border;

  final Gradient? gradient;

  final VoidCallback? onTap;

  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(JMSpacing.md),
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? JMColors.surface) : null,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(JMRadius.lg),
        border: border,
        boxShadow: shadow ? JMShadows.card : null,
      ),
      child: child,
    );

    if (onTap == null) {
      return widget;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(JMRadius.lg),
        onTap: onTap,
        child: widget,
      ),
    );
  }
}
