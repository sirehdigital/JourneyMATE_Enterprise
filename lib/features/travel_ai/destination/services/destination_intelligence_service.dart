import '../../knowledge/engine/knowledge_engine.dart';
import '../../knowledge/entities/knowledge_node.dart';
import '../models/destination_request.dart';
import '../models/destination_result.dart';
import '../models/destination_score.dart';

class DestinationIntelligenceService {
  const DestinationIntelligenceService(this._engine);

  final KnowledgeEngine _engine;

  DestinationResult analyze(DestinationRequest request) {
    final normalizedDestination = request.destinationName.trim();
    final nodes = _engine.searchDestination(normalizedDestination);
    final recommendations = _collectRecommendations(nodes, request);
    final score = _scoreDestination(recommendations, request);

    final summary = _buildSummary(
      normalizedDestination,
      recommendations,
      score,
    );

    return DestinationResult(
      destinationName: normalizedDestination.isEmpty
          ? 'Unknown'
          : normalizedDestination,
      summary: summary,
      recommendedNodes: recommendations,
      score: score,
    );
  }

  List<KnowledgeNode> _collectRecommendations(
    List<KnowledgeNode> nodes,
    DestinationRequest request,
  ) {
    final results = <KnowledgeNode>[];
    final normalizedType = request.preferences['preferredType']
        ?.toString()
        .trim()
        .toLowerCase();

    for (final node in nodes) {
      if (normalizedType == null || normalizedType.isEmpty) {
        results.add(node);
      } else if (node.type.toLowerCase() == normalizedType) {
        results.add(node);
      }
    }

    if (results.isEmpty) {
      results.addAll(nodes);
    }

    return results.take(5).toList(growable: false);
  }

  DestinationScore _scoreDestination(
    List<KnowledgeNode> nodes,
    DestinationRequest request,
  ) {
    if (nodes.isEmpty) {
      return const DestinationScore();
    }

    final attractionScore = _scoreFromNodes(nodes, 'Attraction');
    final accommodationScore = _scoreFromNodes(nodes, 'Hotel');
    final foodScore = _scoreFromNodes(nodes, 'Restaurant');
    final transportScore = _scoreFromNodes(nodes, 'Airport');
    final overallScore =
        (attractionScore + accommodationScore + foodScore + transportScore) / 4;

    return DestinationScore(
      attractionScore: attractionScore,
      accommodationScore: accommodationScore,
      foodScore: foodScore,
      transportScore: transportScore,
      overallScore: overallScore,
    );
  }

  double _scoreFromNodes(List<KnowledgeNode> nodes, String type) {
    final matches = nodes.where((node) => node.type == type).length;
    return matches > 0 ? 0.8 : 0.2;
  }

  String _buildSummary(
    String destination,
    List<KnowledgeNode> nodes,
    DestinationScore score,
  ) {
    if (nodes.isEmpty) {
      return 'No destination intelligence available for $destination.';
    }

    return 'Destination $destination has ${nodes.length} relevant knowledge nodes with an overall intelligence score of ${score.overallScore.toStringAsFixed(2)}.';
  }
}
