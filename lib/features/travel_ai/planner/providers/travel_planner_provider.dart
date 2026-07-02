import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../destination/services/destination_intelligence_service.dart';
import '../../knowledge/engine/knowledge_engine.dart';
import '../../knowledge/providers/knowledge_provider.dart';
import '../engine/travel_planner_engine.dart';
import '../services/travel_planner_service.dart';

final Provider<TravelPlannerService> plannerServiceProvider =
    Provider<TravelPlannerService>(
      (ref) => TravelPlannerService(
        knowledgeEngine: ref.watch(knowledgeEngineProvider),
        destinationService: DestinationIntelligenceService(
          ref.watch(knowledgeEngineProvider),
        ),
      ),
    );

final Provider<TravelPlannerEngine> plannerEngineProvider =
    Provider<TravelPlannerEngine>(
      (ref) => TravelPlannerEngine(
        knowledgeEngine: ref.watch(knowledgeEngineProvider),
        destinationService: DestinationIntelligenceService(
          ref.watch(knowledgeEngineProvider),
        ),
      ),
    );
