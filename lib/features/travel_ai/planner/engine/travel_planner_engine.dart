import '../../destination/services/destination_intelligence_service.dart';
import '../../knowledge/engine/knowledge_engine.dart';
import '../models/travel_plan.dart';
import '../models/travel_plan_request.dart';
import '../services/travel_planner_service.dart';

class TravelPlannerEngine {
  TravelPlannerEngine({
    required KnowledgeEngine knowledgeEngine,
    required DestinationIntelligenceService destinationService,
  }) : _service = TravelPlannerService(
         knowledgeEngine: knowledgeEngine,
         destinationService: destinationService,
       );

  final TravelPlannerService _service;

  TravelPlan createTravelPlan(TravelPlanRequest request) {
    return _service.generatePlan(request);
  }

  TravelPlan regeneratePlan(TravelPlanRequest request) {
    return _service.generatePlan(request);
  }

  TravelPlan optimizePlan(TravelPlanRequest request) {
    final plan = _service.generatePlan(request);
    return plan.copyWith(
      summary: plan.summary.copyWith(recommendationScore: 0.9),
    );
  }
}
