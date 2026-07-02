import 'agent_result.dart';

/// Base class for all JourneyMATE AI agents.
///
/// Every concrete agent must extend this class and implement the
/// [execute] method to perform its domain-specific action.
abstract class AIAgent {
  /// Creates a new AI agent.
  const AIAgent({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
  });

  /// Unique identifier for the agent.
  final String id;

  /// Human-readable name for the agent.
  final String name;

  /// Descriptive text that explains the purpose of the agent.
  final String description;

  /// Execution priority used by routing or orchestration logic.
  final int priority;

  /// Executes the agent with the provided prompt and context.
  ///
  /// Implementations should use the provided [prompt] and [context]
  /// to produce an [AgentResult].
  Future<AgentResult> execute({
    required String prompt,
    required Map<String, dynamic> context,
  });
}
