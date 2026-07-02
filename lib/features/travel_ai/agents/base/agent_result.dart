import 'agent_result.dart';

///
/// The result contains success state, message payload, and optional
/// metadata useful for downstream processing.
class AgentResult {
  /// Creates a new immutable [AgentResult].
  const AgentResult({
    required this.agentId,
    required this.success,
    required this.message,
    this.metadata = const {},
  });

  /// Identifier of the agent that produced this result.
  final String agentId;

  /// Indicates whether the agent execution succeeded.
  final bool success;

  /// Primary response message produced by the agent.
  final String message;

  /// Additional structured metadata associated with the result.
  final Map<String, dynamic> metadata;

  /// Returns a copy of this result with the provided overrides.
  AgentResult copyWith({
    String? agentId,
    bool? success,
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    return AgentResult(
      agentId: agentId ?? this.agentId,
      success: success ?? this.success,
      message: message ?? this.message,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts the result to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'agentId': agentId,
      'success': success,
      'message': message,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  /// Creates an [AgentResult] from a map representation.
  factory AgentResult.fromMap(Map<String, dynamic> map) {
    return AgentResult(
      agentId: map['agentId'] as String,
      success: map['success'] as bool,
      message: map['message'] as String,
      metadata: Map<String, dynamic>.from(
        map['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
