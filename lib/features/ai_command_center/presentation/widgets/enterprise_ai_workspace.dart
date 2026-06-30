import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

import 'ai_chat_input.dart';
import 'ai_conversation.dart';
import 'ai_insight_panel.dart';
import 'ai_notification_feed.dart';
import 'ai_task_queue.dart';
import 'recommendation_list.dart';

class EnterpriseAIWorkspace extends StatelessWidget {
  const EnterpriseAIWorkspace({super.key});

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
          // Workspace Header
          //--------------------------------------------------
          Row(
            children: [
              const Icon(
                Icons.dashboard_customize_rounded,
                color: JMColors.ai,
                size: 28,
              ),

              const SizedBox(width: JMSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Enterprise AI Workspace',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Central hub for AI collaboration',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Conversation
          //--------------------------------------------------
          const AIConversation(),

          const SizedBox(height: JMSpacing.lg),

          const AIChatInput(),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Recommendation
          //--------------------------------------------------
          const RecommendationList(),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Task Queue
          //--------------------------------------------------
          const AITaskQueue(),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Insight
          //--------------------------------------------------
          const AIInsightPanel(),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // Notification Feed
          //--------------------------------------------------
          const AINotificationFeed(),
        ],
      ),
    );
  }
}
