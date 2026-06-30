import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

import 'ai_agent_chat_panel.dart';
import 'ai_chat_input.dart';

class AIConversationWorkspace extends StatelessWidget {
  const AIConversationWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JMSpacing.cardPadding),
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: JMRadius.radiusLG,
        border: Border.all(color: JMColors.border),
        boxShadow: JMShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //--------------------------------------------------
          // Header
          //--------------------------------------------------
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: JMColors.ai.withOpacity(.10),
                  borderRadius: JMRadius.radiusLG,
                ),
                child: const Icon(
                  Icons.forum_rounded,
                  color: JMColors.ai,
                  size: 30,
                ),
              ),

              const SizedBox(width: JMSpacing.lg),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Conversation Workspace',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Collaborate with multiple AI agents',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Multi-Agent Conversation
          //--------------------------------------------------
          const AIAgentChatPanel(),

          const SizedBox(height: JMSpacing.xxl),

          //--------------------------------------------------
          // Chat Input
          //--------------------------------------------------
          const AIChatInput(),

          const SizedBox(height: JMSpacing.lg),

          //--------------------------------------------------
          // Footer
          //--------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(JMSpacing.lg),
            decoration: BoxDecoration(
              color: JMColors.background,
              borderRadius: JMRadius.radiusMD,
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: JMColors.ai),
                const SizedBox(width: JMSpacing.md),
                Expanded(
                  child: Text(
                    'Your request will be routed to the most suitable AI agents automatically.',
                    style: JMTypography.bodySmall.copyWith(
                      color: JMColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
