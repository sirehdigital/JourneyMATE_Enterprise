import 'package:flutter/material.dart';

import 'statistic_card.dart';

class DashboardStatisticsSection extends StatelessWidget {
  const DashboardStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.25,
        children: const [
          StatisticCard(icon: Icons.flight, value: '24', label: 'Trips'),
          StatisticCard(icon: Icons.star, value: '2,540', label: 'Rewards'),
          StatisticCard(icon: Icons.public, value: '8', label: 'Countries'),
          StatisticCard(icon: Icons.favorite, value: '128', label: 'Saved'),
        ],
      ),
    );
  }
}
