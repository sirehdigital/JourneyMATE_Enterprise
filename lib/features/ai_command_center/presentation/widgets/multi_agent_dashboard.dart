import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

import 'ai_agent_status_panel.dart';
import 'ai_conversation_workspace.dart';
import 'ai_dashboard_summary.dart';

class MultiAgentDashboard extends StatelessWidget {
  const MultiAgentDashboard({super.key});

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
          // Dashboard Header
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
                  Icons.dashboard_customize_rounded,
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
                      'Multi-Agent Dashboard',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Enterprise AI Autonomous Command Center',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // AI Dashboard Summary
          //--------------------------------------------------
          const AIDashboardSummary(),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // AI Agent Status
          //--------------------------------------------------
          const AIAgentStatusPanel(),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // AI Conversation Workspace
          //--------------------------------------------------
          const AIConversationWorkspace(),

          const SizedBox(height: JMSpacing.xxl),

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
                const Icon(Icons.verified_rounded, color: JMColors.success),

                const SizedBox(width: JMSpacing.md),

                Expanded(
                  child: Text(
                    'All AI agents are synchronized and operating normally.',
                    style: JMTypography.bodyMedium.copyWith(
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
