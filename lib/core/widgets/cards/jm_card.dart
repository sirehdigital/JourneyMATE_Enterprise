import 'dart:ui';

import 'package:flutter/material.dart';

import '../../design/radius/jm_radius.dart';
import '../../design/shadows/jm_shadows.dart';

class JMGlassCard extends StatelessWidget {
  const JMGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(JMRadius.xl);

    Widget card = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.12),
            borderRadius: radius,
            border: Border.all(color: Colors.white.withOpacity(.25)),
            boxShadow: JMShadows.card,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = InkWell(borderRadius: radius, onTap: onTap, child: card);
    }

    return card;
  }
}
