import 'package:flutter/material.dart';

import '../../design/spacing/jm_spacing.dart';
import '../../design/typography/jm_typography.dart';
import 'jm_gap.dart';

/// Standard section widget used throughout JourneyMATE Enterprise.
///
/// Example:
///
/// JMSection(
///   title: 'Popular Destinations',
///   subtitle: 'Recommended for you',
///   trailing: TextButton(
///     onPressed: () {},
///     child: const Text('See All'),
///   ),
///   child: GridView(...),
/// )
class JMSection extends StatelessWidget {
  const JMSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: JMSpacing.md,
            vertical: JMSpacing.sm,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: JMTypography.titleLarge),
                    if (subtitle != null) ...[
                      const JMGap.xs(),
                      Text(subtitle!, style: JMTypography.bodyMedium),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const JMGap.md(),
          child,
        ],
      ),
    );
  }
}
