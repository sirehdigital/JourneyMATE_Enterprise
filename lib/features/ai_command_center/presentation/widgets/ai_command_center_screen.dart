import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

import '../widgets/ai_orb.dart';
import '../widgets/ai_quick_actions.dart';
import '../widgets/ai_status_card.dart';
import '../widgets/enterprise_ai_header.dart';
import '../widgets/enterprise_ai_workspace.dart';

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
              //--------------------------------------------------
              // Enterprise Header
              //--------------------------------------------------
              const EnterpriseAIHeader(),

              const SizedBox(height: JMSpacing.section),

              //--------------------------------------------------
              // AI Orb
              //--------------------------------------------------
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
                  'Autonomous Travel Intelligence Platform',
                  style: JMTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: JMSpacing.section),

              //--------------------------------------------------
              // Status Card
              //--------------------------------------------------
              const AIStatusCard(),

              const SizedBox(height: JMSpacing.section),

              //--------------------------------------------------
              // Quick Actions
              //--------------------------------------------------
              const AIQuickActions(),

              const SizedBox(height: JMSpacing.section),

              //--------------------------------------------------
              // Enterprise Workspace
              //--------------------------------------------------
              const EnterpriseAIWorkspace(),

              const SizedBox(height: JMSpacing.hero),
            ],
          ),
        ),
      ),
    );
  }
}
