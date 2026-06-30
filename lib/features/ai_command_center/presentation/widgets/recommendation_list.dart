import 'package:flutter/material.dart';

import '../../../../core/design/spacing/jm_spacing.dart';
import 'ai_recommendation_card.dart';
import 'recommendation_chip.dart';

class RecommendationList extends StatelessWidget {
  const RecommendationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RecommendationChips(),

        const SizedBox(height: JMSpacing.xxl),

        AIRecommendationCard(
          destination: 'Kelantan Explorer',
          flightPrice: 'RM129',
          hotelPrice: 'RM180',
          weather: 'Sunny 31°C',
          budget: 'RM768',
          aiScore: 98,
          onViewDetails: () {},
        ),

        const SizedBox(height: JMSpacing.lg),

        AIRecommendationCard(
          destination: 'Redang Island Escape',
          flightPrice: 'RM289',
          hotelPrice: 'RM320',
          weather: 'Cloudy 29°C',
          budget: 'RM1,280',
          aiScore: 95,
          onViewDetails: () {},
        ),

        const SizedBox(height: JMSpacing.lg),

        AIRecommendationCard(
          destination: 'Cameron Highlands Retreat',
          flightPrice: 'RM159',
          hotelPrice: 'RM210',
          weather: '20°C Cool',
          budget: 'RM690',
          aiScore: 97,
          onViewDetails: () {},
        ),
      ],
    );
  }
}
