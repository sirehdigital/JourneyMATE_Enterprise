import '../../knowledge/entities/knowledge_node.dart';

class DestinationResult {
  const DestinationResult({
    required this.destinationName,
    required this.summary,
    required this.recommendedNodes,
    required this.score,
  });

  final String destinationName;
  final String summary;
  final List<KnowledgeNode> recommendedNodes;
  final dynamic score;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'destinationName': destinationName,
      'summary': summary,
      'recommendedNodes': recommendedNodes.map((node) => node.toMap()).toList(),
      'score': score,
    };
  }
}
