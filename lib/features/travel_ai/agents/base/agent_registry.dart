import 'ai_agent.dart';

/// Registry for AI agents used by the JourneyMATE multi-agent framework.
class AgentRegistry {
  AgentRegistry();

  final Map<String, AIAgent> _agents = {};

  /// Registers an [agent] in the registry.
  ///
  /// If an agent with the same [id] already exists, it will be replaced.
  void registerAgent(AIAgent agent) {
    _agents[agent.id] = agent;
  }

  /// Unregisters the agent with the provided [agentId].
  ///
  /// Returns `true` when the agent was removed, otherwise `false`.
  bool unregisterAgent(String agentId) {
    return _agents.remove(agentId) != null;
  }

  /// Retrieves the agent by [agentId], or `null` if not registered.
  AIAgent? getAgent(String agentId) {
    return _agents[agentId];
  }

  /// Returns a list of all registered agents.
  List<AIAgent> getAllAgents() {
    return List<AIAgent>.unmodifiable(_agents.values.toList());
  }

  /// Indicates whether the registry contains an agent with [agentId].
  bool contains(String agentId) {
    return _agents.containsKey(agentId);
  }

  /// Removes all agents from the registry.
  void clear() {
    _agents.clear();
  }
}
