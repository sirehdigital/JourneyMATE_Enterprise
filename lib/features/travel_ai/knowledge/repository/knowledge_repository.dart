import '../entities/knowledge_graph.dart';
import '../entities/knowledge_node.dart';

abstract class KnowledgeRepository {
  KnowledgeGraph getGraph();

  KnowledgeNode? getNode(String id);

  List<KnowledgeNode> getNeighbors(String nodeId);

  bool containsNode(String id);
}
