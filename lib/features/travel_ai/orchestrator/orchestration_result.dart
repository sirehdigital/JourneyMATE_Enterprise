import '../agents/base/agent_result.dart';

/// Immutable result returned by the AI orchestrator after executing agents.
class OrchestrationResult {
  /// Creates a new orchestration result.
  const OrchestrationResult({
    required this.success,
    required this.executedAgents,
    required this.agentResults,
    required this.executionTime,
    this.metadata = const {},
  });

  /// Indicates whether the orchestration completed successfully.
  ///
  /// This value is `true` when all available agents were executed without
  /// unhandled failures.
  final bool success;

  /// Ordered list of agent ids that were executed.
  final List<String> executedAgents;

  /// Collected results from each executed agent.
  final List<AgentResult> agentResults;

  /// Total duration of orchestration execution.
  final Duration executionTime;

  /// Additional structured metadata for orchestration diagnostics.
  final Map<String, dynamic> metadata;

  /// Returns a modified copy of this result.
  OrchestrationResult copyWith({
    bool? success,
    List<String>? executedAgents,
    List<AgentResult>? agentResults,
    Duration? executionTime,
    Map<String, dynamic>? metadata,
  }) {
    return OrchestrationResult(
      success: success ?? this.success,
      executedAgents: executedAgents ?? this.executedAgents,
      agentResults: agentResults ?? this.agentResults,
      executionTime: executionTime ?? this.executionTime,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts this result to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'executedAgents': List<String>.from(executedAgents),
      'agentResults': agentResults.map((result) => result.toMap()).toList(),
      'executionTimeMs': executionTime.inMilliseconds,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  /// Creates an [OrchestrationResult] from a map representation.
  factory OrchestrationResult.fromMap(Map<String, dynamic> map) {
    return OrchestrationResult(
      success: map['success'] as bool,
      executedAgents: List<String>.from(map['executedAgents'] as List<dynamic>),
      agentResults: List<Map<String, dynamic>>.from(
        (map['agentResults'] as List<dynamic>).cast<Map<String, dynamic>>(),
      ).map(AgentResult.fromMap).toList(),
      executionTime: Duration(milliseconds: map['executionTimeMs'] as int),
      metadata: Map<String, dynamic>.from(
        map['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
