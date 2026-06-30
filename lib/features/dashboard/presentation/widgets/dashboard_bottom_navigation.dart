import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/colors/jm_colors.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({super.key, this.selectedIndex = 0});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      backgroundColor: Colors.white,
      indicatorColor: JMColors.primary.withValues(alpha: .15),

      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/dashboard');
            break;

          case 1:
            // TODO: Explore
            break;

          case 2:
            // TODO: Trips
            break;

          case 3:
            context.go('/ai');
            break;

          case 4:
            // TODO: Profile
            break;
        }
      },

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),

        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Explore',
        ),

        NavigationDestination(
          icon: Icon(Icons.card_travel),
          selectedIcon: Icon(Icons.card_travel),
          label: 'Trips',
        ),

        NavigationDestination(
          icon: Icon(Icons.smart_toy_outlined),
          selectedIcon: Icon(Icons.smart_toy),
          label: 'AI',
        ),

        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
