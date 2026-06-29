import 'package:flutter/material.dart';

import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/widgets/avatar/jm_avatar.dart';
import '../../../../core/widgets/buttons/jm_icon_button.dart';
import '../../../../core/widgets/buttons/jm_primary_button.dart';
import '../../../../core/widgets/buttons/jm_secondary_button.dart';
import '../../../../core/widgets/cards/jm_glass_card.dart';
import '../../../../core/widgets/cards/jm_metric_card.dart';
import '../../../../core/widgets/indicators/jm_status_badge.dart';
import '../../../../core/widgets/layout/jm_section_header.dart';
import '../../../../core/widgets/navigation/jm_bottom_navigation.dart';
import '../../../../core/widgets/search/jm_search_bar.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JourneyMATE Enterprise UI Kit')),

      body: ListView(
        padding: const EdgeInsets.all(JMSpacing.lg),
        children: [
          const JMSearchBar(),

          const SizedBox(height: JMSpacing.lg),

          const JMSectionHeader(title: 'Glass Card'),

          const JMGlassCard(child: Text('Glass Card Example')),

          const SizedBox(height: JMSpacing.lg),

          const JMSectionHeader(title: 'Metric Card'),

          const JMMetricCard(
            title: 'Trips',
            value: '128',
            icon: Icons.flight_takeoff,
          ),

          const SizedBox(height: JMSpacing.lg),

          const JMSectionHeader(title: 'Status Badge'),

          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              JMStatusBadge(label: 'Online'),
              JMStatusBadge(label: 'Pending', type: JMStatusType.warning),
              JMStatusBadge(label: 'Error', type: JMStatusType.error),
              JMStatusBadge(label: 'Info', type: JMStatusType.info),
            ],
          ),

          const SizedBox(height: JMSpacing.lg),

          const JMSectionHeader(title: 'Avatar'),

          const Row(children: [JMAvatar(initials: 'JM', isOnline: true)]),

          const SizedBox(height: JMSpacing.lg),

          const JMSectionHeader(title: 'Buttons'),

          JMPrimaryButton(
            text: 'Primary Button',
            icon: Icons.check_circle_outline,
            onPressed: () {},
          ),

          const SizedBox(height: JMSpacing.md),

          JMSecondaryButton(
            text: 'Secondary Button',
            icon: Icons.arrow_forward,
            onPressed: () {},
          ),

          const SizedBox(height: JMSpacing.lg),

          const JMSectionHeader(title: 'Icon Button'),

          Row(
            children: [
              JMIconButton(icon: Icons.favorite_outline, onPressed: () {}),

              const SizedBox(width: JMSpacing.md),

              JMIconButton(icon: Icons.notifications_none, onPressed: () {}),

              const SizedBox(width: JMSpacing.md),

              JMIconButton(icon: Icons.settings_outlined, onPressed: () {}),
            ],
          ),

          const SizedBox(height: 120),
        ],
      ),

      bottomNavigationBar: JMBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
