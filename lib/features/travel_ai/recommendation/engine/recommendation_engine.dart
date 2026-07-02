import '../../destination/services/destination_intelligence_service.dart';
import '../../knowledge/engine/knowledge_engine.dart';
import '../models/recommendation_request.dart';
import '../models/recommendation_result.dart';
import '../services/recommendation_service.dart';

class RecommendationEngine {
  RecommendationEngine({
    required KnowledgeEngine knowledgeEngine,
    required DestinationIntelligenceService destinationService,
  }) : _service = RecommendationService(knowledgeEngine, destinationService);

  final RecommendationService _service;

  RecommendationResult recommendDestinations(RecommendationRequest request) {
    return _service.buildRecommendations(request);
  }

  RecommendationResult recommendHotels(RecommendationRequest request) {
    final result = _service.buildRecommendations(request);
    final filtered = _service.filterByCategory(result.items, 'Hotel');
    return result.copyWith(items: filtered, totalResults: filtered.length);
  }

  RecommendationResult recommendRestaurants(RecommendationRequest request) {
    final result = _service.buildRecommendations(request);
    final filtered = _service.filterByCategory(result.items, 'Restaurant');
    return result.copyWith(items: filtered, totalResults: filtered.length);
  }

  RecommendationResult recommendAttractions(RecommendationRequest request) {
    final result = _service.buildRecommendations(request);
    final filtered = _service.filterByCategory(result.items, 'Attraction');
    return result.copyWith(items: filtered, totalResults: filtered.length);
  }

  RecommendationResult recommendTrips(RecommendationRequest request) {
    return _service.buildRecommendations(request);
  }
}
