import 'package:flutter/material.dart';

import '../../../../core/design/spacing/jm_spacing.dart';
import 'ai_agent_card.dart';

class AIAgentGrid extends StatelessWidget {
  const AIAgentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: JMSpacing.lg,
      mainAxisSpacing: JMSpacing.lg,
      childAspectRatio: 0.95,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: const [
        //--------------------------------------------------
        // Master AI
        //--------------------------------------------------
        AIAgentCard(
          agentName: 'Master AI',
          description: 'Coordinates all JourneyMATE AI agents.',
          icon: Icons.auto_awesome_rounded,
          status: AIAgentStatus.online,
        ),

        //--------------------------------------------------
        // Travel Planner
        //--------------------------------------------------
        AIAgentCard(
          agentName: 'Travel Planner',
          description: 'Creates intelligent travel itineraries.',
          icon: Icons.map_rounded,
          status: AIAgentStatus.online,
        ),

        //--------------------------------------------------
        // Flight Agent
        //--------------------------------------------------
        AIAgentCard(
          agentName: 'Flight Agent',
          description: 'Monitors flight prices and schedules.',
          icon: Icons.flight_takeoff_rounded,
          status: AIAgentStatus.busy,
        ),

        //--------------------------------------------------
        // Hotel Agent
        //--------------------------------------------------
        AIAgentCard(
          agentName: 'Hotel Agent',
          description: 'Searches and manages accommodation.',
          icon: Icons.hotel_rounded,
          status: AIAgentStatus.online,
        ),

        //--------------------------------------------------
        // Weather Agent
        //--------------------------------------------------
        AIAgentCard(
          agentName: 'Weather AI',
          description: 'Provides real-time weather forecasts.',
          icon: Icons.cloud_rounded,
          status: AIAgentStatus.syncing,
        ),

        //--------------------------------------------------
        // Wallet Agent
        //--------------------------------------------------
        AIAgentCard(
          agentName: 'Wallet AI',
          description: 'Tracks expenses and travel budget.',
          icon: Icons.account_balance_wallet_rounded,
          status: AIAgentStatus.online,
        ),

        //--------------------------------------------------
        // Navigation Agent
        //--------------------------------------------------
        AIAgentCard(
          agentName: 'Navigation',
          description: 'Optimizes routes and local transport.',
          icon: Icons.navigation_rounded,
          status: AIAgentStatus.busy,
        ),

        //--------------------------------------------------
        // Emergency Agent
        //--------------------------------------------------
        AIAgentCard(
          agentName: 'Emergency',
          description: 'Monitors emergency alerts and safety.',
          icon: Icons.warning_amber_rounded,
          status: AIAgentStatus.offline,
        ),
      ],
    );
  }
}
