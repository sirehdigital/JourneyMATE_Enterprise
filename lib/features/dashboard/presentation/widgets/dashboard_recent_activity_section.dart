import 'package:flutter/material.dart';

import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import 'activity_list_tile.dart';

class DashboardRecentActivitySection extends StatelessWidget {
  const DashboardRecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: JMTypography.headlineSmall),

        const SizedBox(height: JMSpacing.md),

        const ActivityListTile(
          icon: Icons.flight_takeoff,
          title: 'Flight to Kota Bharu',
          subtitle: 'Today • 09:30 AM',
        ),

        const Divider(height: 28),

        const ActivityListTile(
          icon: Icons.hotel,
          title: 'Hotel Booking Confirmed',
          subtitle: 'Yesterday',
        ),

        const Divider(height: 28),

        const ActivityListTile(
          icon: Icons.smart_toy,
          title: 'AI generated itinerary',
          subtitle: '2 days ago',
        ),
      ],
    );
  }
}
