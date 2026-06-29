import 'package:flutter/material.dart';

import '../../../../core/design/spacing/jm_spacing.dart';
import 'module_card.dart';

class DashboardModulesGrid extends StatelessWidget {
  const DashboardModulesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: JMSpacing.md,
      mainAxisSpacing: JMSpacing.md,
      childAspectRatio: 1.05,
      children: [
        ModuleCard(icon: Icons.flight_takeoff, title: 'Flights', onTap: () {}),
        ModuleCard(icon: Icons.hotel, title: 'Hotels', onTap: () {}),
        ModuleCard(icon: Icons.map, title: 'Planner', onTap: () {}),
        ModuleCard(icon: Icons.explore, title: 'Explore', onTap: () {}),
        ModuleCard(
          icon: Icons.account_balance_wallet,
          title: 'Wallet',
          onTap: () {},
        ),
        ModuleCard(icon: Icons.smart_toy, title: 'AI', onTap: () {}),
      ],
    );
  }
}
