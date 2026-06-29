import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/radius/jm_radius.dart';

class JMIconButton extends StatelessWidget {
  const JMIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? JMColors.surface,
      borderRadius: BorderRadius.circular(JMRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(JMRadius.xl),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor ?? JMColors.primary, size: 22),
        ),
      ),
    );
  }
}
