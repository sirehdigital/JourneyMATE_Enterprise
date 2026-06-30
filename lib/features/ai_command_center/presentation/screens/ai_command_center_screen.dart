import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import '../../../../core/providers/ai_chat_provider.dart';
import '../../../../core/providers/ai_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import 'ai_conversation_screen.dart';

class AICommandCenterScreen extends ConsumerStatefulWidget {
  const AICommandCenterScreen({super.key});

  @override
  ConsumerState<AICommandCenterScreen> createState() =>
      _AICommandCenterScreenState();
}

class _AICommandCenterScreenState extends ConsumerState<AICommandCenterScreen> {
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
                  'JourneyMATE AI',
                  style: JMTypography.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: JMSpacing.sm),

              const Center(
                child: Text(
                  'Your Travel Intelligence Platform',
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
              Container(
                padding: const EdgeInsets.all(JMSpacing.lg),
                decoration: BoxDecoration(
                  color: JMColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: JMColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.smart_toy_rounded,
                      size: 56,
                      color: JMColors.ai,
                    ),

                    const SizedBox(height: JMSpacing.md),

                    const Text(
                      'JourneyMATE AI Assistant',
                      style: JMTypography.titleMedium,
                    ),

                    const SizedBox(height: JMSpacing.sm),

                    const Text(
                      'Start a live conversation with JourneyMATE AI.',
                      textAlign: TextAlign.center,
                      style: JMTypography.bodyMedium,
                    ),

                    const SizedBox(height: JMSpacing.lg),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AIConversationScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_rounded),
                        label: const Text('Open AI Assistant'),
                      ),
                    ),
                  ],
                ),
              ),

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
