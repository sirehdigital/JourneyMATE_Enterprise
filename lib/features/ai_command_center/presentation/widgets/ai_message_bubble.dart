import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIMessageBubble extends StatelessWidget {
  const AIMessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
    this.isUser = false,
  });

  final String message;
  final String timestamp;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JMSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const _Avatar(
              backgroundColor: JMColors.ai,
              icon: Icons.smart_toy_rounded,
            ),
            const SizedBox(width: JMSpacing.md),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(JMSpacing.lg),
                  decoration: BoxDecoration(
                    color: isUser ? JMColors.primary : JMColors.card,
                    borderRadius: isUser
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(JMRadius.lg),
                            topRight: Radius.circular(JMRadius.lg),
                            bottomLeft: Radius.circular(JMRadius.lg),
                            bottomRight: Radius.circular(JMRadius.sm),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(JMRadius.sm),
                            topRight: Radius.circular(JMRadius.lg),
                            bottomLeft: Radius.circular(JMRadius.lg),
                            bottomRight: Radius.circular(JMRadius.lg),
                          ),
                    border: isUser ? null : Border.all(color: JMColors.border),
                  ),
                  child: Text(
                    message,
                    style: isUser
                        ? JMTypography.bodyLarge.copyWith(
                            color: JMColors.textInverse,
                          )
                        : JMTypography.bodyLarge,
                  ),
                ),

                const SizedBox(height: JMSpacing.xs),

                Text(timestamp, style: JMTypography.labelSmall),
              ],
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: JMSpacing.md),
            const _Avatar(
              backgroundColor: JMColors.primary,
              icon: Icons.person_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.backgroundColor, required this.icon});

  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: JMColors.textInverse, size: 22),
    );
  }
}
