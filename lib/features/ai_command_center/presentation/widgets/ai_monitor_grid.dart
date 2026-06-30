import 'package:flutter/material.dart';

import '../../../../core/design/spacing/jm_spacing.dart';
import 'ai_monitor_card.dart';

class AIMonitorGrid extends StatelessWidget {
  const AIMonitorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: JMSpacing.lg,
      mainAxisSpacing: JMSpacing.lg,
      childAspectRatio: 1.05,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: const [
        //--------------------------------------------------
        // AI Engine
        //--------------------------------------------------
        AIMonitorCard(
          title: 'AI Engine',
          value: '99%',
          subtitle: 'System Health',
          icon: Icons.memory_rounded,
          status: AIMonitorStatus.healthy,
        ),

        //--------------------------------------------------
        // API
        //--------------------------------------------------
        AIMonitorCard(
          title: 'API Gateway',
          value: '12 ms',
          subtitle: 'Average Latency',
          icon: Icons.cloud_done_rounded,
          status: AIMonitorStatus.healthy,
        ),

        //--------------------------------------------------
        // Memory
        //--------------------------------------------------
        AIMonitorCard(
          title: 'Memory',
          value: '68%',
          subtitle: 'RAM Usage',
          icon: Icons.storage_rounded,
          status: AIMonitorStatus.warning,
        ),

        //--------------------------------------------------
        // CPU
        //--------------------------------------------------
        AIMonitorCard(
          title: 'CPU',
          value: '42%',
          subtitle: 'Processor Load',
          icon: Icons.developer_board_rounded,
          status: AIMonitorStatus.healthy,
        ),

        //--------------------------------------------------
        // Synchronization
        //--------------------------------------------------
        AIMonitorCard(
          title: 'Sync',
          value: '100%',
          subtitle: 'Agent Synchronization',
          icon: Icons.sync_rounded,
          status: AIMonitorStatus.healthy,
        ),

        //--------------------------------------------------
        // Realtime
        //--------------------------------------------------
        AIMonitorCard(
          title: 'Realtime',
          value: 'ONLINE',
          subtitle: 'Supabase Connection',
          icon: Icons.wifi_tethering_rounded,
          status: AIMonitorStatus.healthy,
        ),
      ],
    );
  }
}
