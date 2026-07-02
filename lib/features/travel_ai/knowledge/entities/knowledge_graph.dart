import 'knowledge_edge.dart';
import 'knowledge_node.dart';

class KnowledgeGraph {
  final Map<String, KnowledgeNode> _nodes = <String, KnowledgeNode>{};
  final Map<String, KnowledgeEdge> _edges = <String, KnowledgeEdge>{};
  final Map<String, Set<String>> _adjacency = <String, Set<String>>{};

  bool addNode(KnowledgeNode node) {
    if (node.id.isEmpty) {
      return false;
    }

    _nodes[node.id] = node;
    _adjacency.putIfAbsent(node.id, () => <String>{});
    return true;
  }

  bool removeNode(String nodeId) {
    if (!_nodes.containsKey(nodeId)) {
      return false;
    }

    _nodes.remove(nodeId);
    _adjacency.remove(nodeId);

    final edgesToRemove = _edges.keys
        .where((edgeKey) {
          final parts = edgeKey.split('|');
          return parts.length >= 2 &&
              (parts[0] == nodeId || parts[1] == nodeId);
        })
        .toList(growable: false);

    for (final edgeKey in edgesToRemove) {
      _edges.remove(edgeKey);
    }

    for (final adjacency in _adjacency.values) {
      adjacency.remove(nodeId);
    }

    return true;
  }

  bool addEdge(KnowledgeEdge edge) {
    if (edge.sourceId.isEmpty || edge.targetId.isEmpty) {
      return false;
    }

    if (!_nodes.containsKey(edge.sourceId) ||
        !_nodes.containsKey(edge.targetId)) {
      return false;
    }

    final edgeKey = _edgeKey(edge.sourceId, edge.targetId, edge.relationship);
    _edges[edgeKey] = edge;
    _adjacency.putIfAbsent(edge.sourceId, () => <String>{}).add(edge.targetId);
    _adjacency.putIfAbsent(edge.targetId, () => <String>{});
    return true;
  }

  bool removeEdge(String sourceId, String targetId, {String? relationship}) {
    final edgeKey = _edgeKey(sourceId, targetId, relationship ?? '');
    final removed = _edges.remove(edgeKey);
    if (removed == null) {
      return false;
    }

    _adjacency[sourceId]?.remove(targetId);
    return true;
  }

  bool containsNode(String nodeId) {
    return _nodes.containsKey(nodeId);
  }

  bool containsEdge(String sourceId, String targetId, {String? relationship}) {
    return _edges.containsKey(_edgeKey(sourceId, targetId, relationship ?? ''));
  }

  KnowledgeNode? getNode(String nodeId) {
    return _nodes[nodeId];
  }

  List<KnowledgeNode> getNeighbors(String nodeId) {
    final neighborIds = _adjacency[nodeId] ?? const <String>{};
    return neighborIds
        .map<KnowledgeNode?>((neighborId) => _nodes[neighborId])
        .whereType<KnowledgeNode>()
        .toList(growable: false);
  }

  List<KnowledgeNode> getNodes() {
    return _nodes.values.toList(growable: false);
  }

  List<KnowledgeEdge> getEdges() {
    return _edges.values.toList(growable: false);
  }

  void clear() {
    _nodes.clear();
    _edges.clear();
    _adjacency.clear();
  }

  int get nodeCount => _nodes.length;

  int get edgeCount => _edges.length;

  String _edgeKey(String sourceId, String targetId, String relationship) {
    return '$sourceId|$targetId|$relationship';
  }
}
