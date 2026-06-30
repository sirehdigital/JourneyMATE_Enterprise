import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'ai_message_bubble.dart';
import 'typing_indicator.dart';

class AIConversation extends StatelessWidget {
  const AIConversation({super.key, this.isTyping = true});

  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: JMRadius.radiusLG,
        border: Border.all(color: JMColors.border),
        boxShadow: JMShadows.card,
      ),
      child: Padding(
        padding: const EdgeInsets.all(JMSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------------------
            // Header
            //------------------------------------
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: JMColors.ai,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: JMColors.textInverse,
                  ),
                ),

                const SizedBox(width: JMSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('JourneyMATE AI', style: JMTypography.titleMedium),
                      SizedBox(height: JMSpacing.xs),
                      Text(
                        'Enterprise Travel Assistant',
                        style: JMTypography.bodySmall,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: JMSpacing.md,
                    vertical: JMSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: JMColors.success.withOpacity(.10),
                    borderRadius: JMRadius.radiusPill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.circle, color: JMColors.success, size: 10),
                      SizedBox(width: JMSpacing.sm),
                      Text(
                        'ONLINE',
                        style: TextStyle(
                          color: JMColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: JMSpacing.xxl),

            //------------------------------------
            // Conversation
            //------------------------------------
            const AIMessageBubble(
              message:
                  'Hello Abang 👋\n\n'
                  'I am JourneyMATE AI.\n'
                  'How can I help you plan your next journey today?',
              timestamp: '09:30 AM',
            ),

            const AIMessageBubble(
              isUser: true,
              message:
                  'Please create a 3 Days 2 Nights itinerary for Kelantan with a budget below RM800.',
              timestamp: '09:31 AM',
            ),

            const AIMessageBubble(
              message:
                  'Certainly.\n\n'
                  'I am analysing your destination, budget, accommodation, transport and attractions.\n\n'
                  'Your personalised itinerary will be ready shortly.',
              timestamp: '09:31 AM',
            ),

            //------------------------------------
            // Typing
            //------------------------------------
            if (isTyping) ...[
              const SizedBox(height: JMSpacing.md),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: JMColors.ai,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: JMColors.textInverse,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: JMSpacing.md),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: JMSpacing.lg,
                      vertical: JMSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: JMColors.background,
                      borderRadius: JMRadius.radiusLG,
                      border: Border.all(color: JMColors.border),
                    ),
                    child: const TypingIndicator(),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
