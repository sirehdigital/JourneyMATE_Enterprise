import '../../destination/services/destination_intelligence_service.dart';
import '../../knowledge/engine/knowledge_engine.dart';
import '../../recommendation/engine/recommendation_engine.dart';
import '../../recommendation/models/recommendation_request.dart';
import '../models/itinerary_activity.dart';
import '../models/itinerary_day.dart';
import '../models/travel_plan.dart';
import '../models/travel_plan_request.dart';
import '../models/travel_plan_summary.dart';

class TravelPlannerService {
  const TravelPlannerService({
    required KnowledgeEngine knowledgeEngine,
    required DestinationIntelligenceService destinationService,
  }) : _knowledgeEngine = knowledgeEngine,
       _destinationService = destinationService;

  final KnowledgeEngine _knowledgeEngine;
  final DestinationIntelligenceService _destinationService;

  TravelPlan generatePlan(TravelPlanRequest request) {
    final itinerary = buildDailyItinerary(request);
    final summary = _buildSummary(request, itinerary);
    return TravelPlan(
      request: request,
      summary: summary,
      itinerary: itinerary,
      metadata: <String, dynamic>{
        'knowledgeEngine': _knowledgeEngine.runtimeType.toString(),
        'destinationService': _destinationService.runtimeType.toString(),
      },
    );
  }

  List<ItineraryDay> buildDailyItinerary(TravelPlanRequest request) {
    final activities = <ItineraryActivity>[];
    final dayCount = request.durationDays.clamp(1, 7).toInt();

    for (var day = 1; day <= dayCount; day++) {
      activities.add(
        ItineraryActivity(
          id: 'day-$day-activity',
          title: 'Explore ${request.destination}',
          category: 'Attraction',
          location: request.destination,
          startTime: '${8 + ((day - 1) % 3)}:00',
          endTime: '${10 + ((day - 1) % 3)}:00',
          estimatedCost: request.budget > 0
              ? request.budget / dayCount / 4
              : 50.0,
          metadata: <String, dynamic>{'day': day},
        ),
      );
    }

    return List<ItineraryDay>.generate(
      dayCount,
      (index) => ItineraryDay(
        dayNumber: index + 1,
        title: 'Day ${index + 1}',
        activities: activities
            .where((activity) => activity.metadata['day'] == index + 1)
            .toList(growable: false),
        estimatedBudget: request.budget > 0
            ? request.budget / dayCount
            : 100.0,
      ),
      growable: false,
    );
  }

  TravelPlanSummary allocateBudget(
    TravelPlanRequest request,
    List<ItineraryDay> itinerary,
  ) {
    final totalBudget = request.budget > 0 ? request.budget : 1000.0;
    final estimatedSpent = itinerary.fold<double>(
      0,
      (sum, day) => sum + day.estimatedBudget,
    );
    return TravelPlanSummary(
      totalBudget: totalBudget,
      estimatedSpent: estimatedSpent,
      remainingBudget: totalBudget - estimatedSpent,
      totalActivities: itinerary.fold<int>(
        0,
        (sum, day) => sum + day.activities.length,
      ),
      recommendationScore: 0.85,
    );
  }

  List<ItineraryDay> optimizeActivities(List<ItineraryDay> itinerary) {
    return itinerary
        .map((day) => day.copyWith(estimatedBudget: day.estimatedBudget))
        .toList(growable: false);
  }

  double estimateTripScore(TravelPlanRequest request) {
    return request.budget > 0 ? 0.82 : 0.75;
  }

  TravelPlanSummary _buildSummary(
    TravelPlanRequest request,
    List<ItineraryDay> itinerary,
  ) {
    final summary = allocateBudget(request, itinerary);
    final optimized = optimizeActivities(itinerary);
    final recommendationScore = estimateTripScore(request);
    return summary.copyWith(
      totalActivities: optimized.fold<int>(
        0,
        (sum, day) => sum + day.activities.length,
      ),
      recommendationScore: recommendationScore,
    );
  }
}
