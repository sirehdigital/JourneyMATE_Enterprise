import '../entities/knowledge_node.dart';
import '../services/graph_query_service.dart';

class KnowledgeEngine {
  KnowledgeEngine({required GraphQueryService queryService})
    : _queryService = queryService;

  final GraphQueryService _queryService;

  List<KnowledgeNode> searchDestination(String destination) {
    if (destination.trim().isEmpty) {
      return const <KnowledgeNode>[];
    }

    try {
      final exactMatch = _queryService.findNodeById(destination);
      if (exactMatch != null) {
        return <KnowledgeNode>[exactMatch];
      }
      return const <KnowledgeNode>[];
    } catch (_) {
      return const <KnowledgeNode>[];
    }
  }

  List<KnowledgeNode> nearbyNodes(String nodeId) {
    try {
      return _queryService.findNeighbors(nodeId);
    } catch (_) {
      return const <KnowledgeNode>[];
    }
  }

  List<KnowledgeNode> connectedNodes(
    String nodeId, {
    String relationship = '',
  }) {
    try {
      return _queryService.findConnected(nodeId, relationship);
    } catch (_) {
      return const <KnowledgeNode>[];
    }
  }

  List<KnowledgeNode> searchByType(String type) {
    try {
      return _queryService.findNodesByType(type);
    } catch (_) {
      return const <KnowledgeNode>[];
    }
  }
}
