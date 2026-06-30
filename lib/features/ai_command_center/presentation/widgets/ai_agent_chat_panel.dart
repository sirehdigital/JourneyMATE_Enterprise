import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'ai_agent_message.dart';

class AIAgentChatPanel extends StatelessWidget {
  const AIAgentChatPanel({super.key});

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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: JMColors.ai.withOpacity(.10),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: const Icon(Icons.forum_rounded, color: JMColors.ai),
              ),

              const SizedBox(width: JMSpacing.lg),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Multi-Agent Conversation',
                      style: JMTypography.titleLarge,
                    ),
                    SizedBox(height: JMSpacing.xs),
                    Text(
                      'Live collaboration between AI agents',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxxl),

          //--------------------------------------------------
          // AI Messages
          //--------------------------------------------------
          const AIAgentMessage(
            agentName: 'Master AI',
            message:
                'All travel agents are online. Optimizing itinerary based on your preferences.',
            icon: Icons.auto_awesome_rounded,
            agentColor: JMColors.ai,
          ),

          const AIAgentMessage(
            agentName: 'Flight Agent',
            message:
                'A cheaper flight has been detected. Estimated savings: RM120.',
            icon: Icons.flight_takeoff_rounded,
            agentColor: JMColors.flight,
            timestamp: '1 min ago',
          ),

          const AIAgentMessage(
            agentName: 'Hotel Agent',
            message:
                'Recommended hotel availability has been confirmed for your travel dates.',
            icon: Icons.hotel_rounded,
            agentColor: JMColors.hotel,
            timestamp: '2 min ago',
          ),

          const AIAgentMessage(
            agentName: 'Weather AI',
            message:
                'Weather forecast indicates sunny conditions throughout most of your trip.',
            icon: Icons.sunny,
            agentColor: JMColors.warning,
            timestamp: '3 min ago',
          ),

          const AIAgentMessage(
            agentName: 'Wallet AI',
            message:
                'Current estimated trip budget is within your planned spending limit.',
            icon: Icons.account_balance_wallet_rounded,
            agentColor: JMColors.wallet,
            timestamp: '5 min ago',
          ),
        ],
      ),
    );
  }
}
