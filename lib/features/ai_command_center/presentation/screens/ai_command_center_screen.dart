import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

import '../widgets/ai_chat_input.dart';
import '../widgets/ai_conversation.dart';
import '../widgets/ai_insight_panel.dart';
import '../widgets/ai_notification_feed.dart';
import '../widgets/ai_orb.dart';
import '../widgets/ai_quick_actions.dart';
import '../widgets/ai_recent_activity.dart';
import '../widgets/ai_status_card.dart';
import '../widgets/ai_task_queue.dart';
import '../widgets/recommendation_list.dart';

class AICommandCenterScreen extends StatelessWidget {
  const AICommandCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JMColors.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: JMColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('AI Command Center', style: JMTypography.titleLarge),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: JMSpacing.screenHorizontal,
            vertical: JMSpacing.screenVertical,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //---------------------------------------------------
              // AI Orb
              //---------------------------------------------------
              const Center(child: AIOrb(size: 140)),

              const SizedBox(height: JMSpacing.xxl),

              const Center(
                child: Text(
                  'JourneyMATE Enterprise AI',
                  style: JMTypography.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: JMSpacing.sm),

              const Center(
                child: Text(
                  'Enterprise Travel Intelligence Platform',
                  style: JMTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: JMSpacing.section),

              //---------------------------------------------------
              // Status
              //---------------------------------------------------
              const AIStatusCard(),

              const SizedBox(height: JMSpacing.section),

              //---------------------------------------------------
              // Quick Actions
              //---------------------------------------------------
              const AIQuickActions(),

              const SizedBox(height: JMSpacing.section),

              //---------------------------------------------------
              // Recent Activity
              //---------------------------------------------------
              const AIRecentActivity(),

              const SizedBox(height: JMSpacing.section),

              //---------------------------------------------------
              // AI Conversation
              //---------------------------------------------------
              const AIConversation(),

              const SizedBox(height: JMSpacing.lg),

              const AIChatInput(),

              const SizedBox(height: JMSpacing.section),

              //---------------------------------------------------
              // Recommendation
              //---------------------------------------------------
              const RecommendationList(),

              const SizedBox(height: JMSpacing.section),

              //---------------------------------------------------
              // Task Queue
              //---------------------------------------------------
              const AITaskQueue(),

              const SizedBox(height: JMSpacing.section),

              //---------------------------------------------------
              // Insight Dashboard
              //---------------------------------------------------
              const AIInsightPanel(),

              const SizedBox(height: JMSpacing.section),

              //---------------------------------------------------
              // Notification Feed
              //---------------------------------------------------
              const AINotificationFeed(),

              const SizedBox(height: JMSpacing.hero),
            ],
          ),
        ),
      ),
    );
  }
}
