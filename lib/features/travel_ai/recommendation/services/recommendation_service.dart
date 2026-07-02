import '../../destination/models/destination_request.dart';
import '../../destination/models/destination_result.dart';
import '../../destination/services/destination_intelligence_service.dart';
import '../../knowledge/engine/knowledge_engine.dart';
import '../../knowledge/entities/knowledge_node.dart';
import '../models/recommendation_item.dart';
import '../models/recommendation_request.dart';
import '../models/recommendation_result.dart';

class RecommendationService {
  const RecommendationService(this._engine, this._destinationService);

  final KnowledgeEngine _engine;
  final DestinationIntelligenceService _destinationService;

  RecommendationResult buildRecommendations(RecommendationRequest request) {
    final destinationRequest = DestinationRequest(
      destinationName: request.destination,
      travelStyle: request.travelStyle,
      budget: request.budget,
      travellers: request.travellers,
      durationDays: request.durationDays,
      preferences: request.preferences,
    );

    final destinationResult = _destinationService.analyze(destinationRequest);
    final items = _buildItemsFromDestination(destinationResult, request);

    return RecommendationResult(
      items: items,
      totalResults: items.length,
      generatedAt: DateTime.now(),
      metadata: <String, dynamic>{
        'destination': request.destination,
        'travelStyle': request.travelStyle,
      },
    );
  }

  List<RecommendationItem> rankResults(List<RecommendationItem> items) {
    if (items.isEmpty) {
      return const <RecommendationItem>[];
    }

    final ranked = List<RecommendationItem>.from(items);
    ranked.sort((left, right) => right.score.compareTo(left.score));
    return ranked;
  }

  List<RecommendationItem> sortByScore(List<RecommendationItem> items) {
    return rankResults(items);
  }

  List<RecommendationItem> filterByCategory(
    List<RecommendationItem> items,
    String category,
  ) {
    if (category.trim().isEmpty) {
      return const <RecommendationItem>[];
    }

    return items
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList(growable: false);
  }

  List<RecommendationItem> filterByBudget(
    List<RecommendationItem> items,
    double budget,
  ) {
    if (budget <= 0) {
      return const <RecommendationItem>[];
    }

    return items
        .where(
          (item) =>
              item.metadata['budget'] is num &&
              (item.metadata['budget'] as num).toDouble() <= budget,
        )
        .toList(growable: false);
  }

  List<RecommendationItem> _buildItemsFromDestination(
    DestinationResult destinationResult,
    RecommendationRequest request,
  ) {
    final items = <RecommendationItem>[];

    for (final node in destinationResult.recommendedNodes) {
      final score = _scoreForNode(node, request);
      items.add(
        RecommendationItem(
          id: node.id,
          title: node.name,
          category: node.type,
          score: score,
          confidence: 0.8,
          reason: 'Recommended based on destination knowledge.',
          metadata: <String, dynamic>{
            'nodeId': node.id,
            'budget': request.budget,
            'destination': request.destination,
          },
        ),
      );
    }

    return rankResults(items);
  }

  double _scoreForNode(KnowledgeNode node, RecommendationRequest request) {
    final baseScore = node.type.toLowerCase() == 'hotel'
        ? 0.92
        : node.type.toLowerCase() == 'restaurant'
        ? 0.88
        : node.type.toLowerCase() == 'attraction'
        ? 0.9
        : 0.8;

    final budgetFactor = request.budget > 0 ? 1.0 : 1.0;
    return baseScore + budgetFactor * 0.01;
  }
}
