import '../entities/knowledge_graph.dart';
import '../entities/knowledge_node.dart';

class GraphQueryService {
  const GraphQueryService(this._graph);

  final KnowledgeGraph _graph;

  KnowledgeNode? findNodeById(String id) {
    if (id.trim().isEmpty) {
      return null;
    }

    try {
      return _graph.getNode(id);
    } catch (_) {
      return null;
    }
  }

  List<KnowledgeNode> findNodesByType(String type) {
    if (type.trim().isEmpty) {
      return const <KnowledgeNode>[];
    }

    try {
      final normalizedType = type.trim().toLowerCase();
      final nodes = _graph.getNodes();
      return nodes
          .where((node) => node.type.toLowerCase() == normalizedType)
          .toList(growable: false);
    } catch (_) {
      return const <KnowledgeNode>[];
    }
  }

  List<KnowledgeNode> findNeighbors(String nodeId) {
    if (nodeId.trim().isEmpty) {
      return const <KnowledgeNode>[];
    }

    try {
      return _graph.getNeighbors(nodeId);
    } catch (_) {
      return const <KnowledgeNode>[];
    }
  }

  List<KnowledgeNode> findConnected(String nodeId, String relationship) {
    if (nodeId.trim().isEmpty) {
      return const <KnowledgeNode>[];
    }

    try {
      final normalizedRelationship = relationship.trim().toLowerCase();
      final matchingNodes = <KnowledgeNode>[];
      for (final edge in _graph.getEdges()) {
        if (edge.sourceId != nodeId) {
          continue;
        }

        if (normalizedRelationship.isEmpty ||
            edge.relationship.toLowerCase() == normalizedRelationship) {
          final targetNode = _graph.getNode(edge.targetId);
          if (targetNode != null) {
            matchingNodes.add(targetNode);
          }
        }
      }

      return matchingNodes;
    } catch (_) {
      return const <KnowledgeNode>[];
    }
  }

  bool containsNode(String id) {
    if (id.trim().isEmpty) {
      return false;
    }

    try {
      return _graph.containsNode(id);
    } catch (_) {
      return false;
    }
  }
}
