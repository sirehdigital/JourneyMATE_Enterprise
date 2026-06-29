import 'package:flutter/material.dart';

import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

import '../widgets/dashboard_bottom_navigation.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_modules_grid.dart';
import '../widgets/dashboard_quick_actions_section.dart';
import '../widgets/dashboard_recent_activity_section.dart';
import '../widgets/dashboard_statistics_section.dart';
import '../widgets/hero_travel_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      bottomNavigationBar: const DashboardBottomNavigation(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(JMSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const DashboardHeader(),

              const SizedBox(height: JMSpacing.lg),

              // Hero Card
              const HeroTravelCard(),

              const SizedBox(height: JMSpacing.xl),

              // Statistics
              const DashboardStatisticsSection(),

              const SizedBox(height: JMSpacing.xl),

              // Enterprise Modules
              Text(
                'Enterprise Modules',
                style: JMTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: JMSpacing.md),

              const DashboardModulesGrid(),

              const SizedBox(height: JMSpacing.xl),

              // Quick Actions
              const DashboardQuickActionsSection(),

              const SizedBox(height: JMSpacing.xl),

              // Recent Activity
              const DashboardRecentActivitySection(),

              const SizedBox(height: JMSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
