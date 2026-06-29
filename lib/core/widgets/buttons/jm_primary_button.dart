import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/radius/jm_radius.dart';
import '../../design/spacing/jm_spacing.dart';
import '../../design/typography/jm_typography.dart';

class JMPrimaryButton extends StatelessWidget {
  const JMPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: JMColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: JMSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(JMRadius.xl),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: JMSpacing.sm),
                  ],
                  Text(
                    text,
                    style: JMTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
