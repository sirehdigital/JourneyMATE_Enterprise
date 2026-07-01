/// Immutable result produced by the AI router.
///
/// The router provides the matched intent, a list of selected agent ids,
/// a confidence score, and the reasoning behind the routing decision.
class RoutingResult {
  /// Creates a new [RoutingResult].
  const RoutingResult({
    required this.matchedIntent,
    required this.selectedAgents,
    required this.confidence,
    required this.reasoning,
  });

  /// Identified intent that best matches the user prompt.
  final String matchedIntent;

  /// List of selected agent identifiers for the given prompt.
  final List<String> selectedAgents;

  /// Confidence score for the routing decision.
  final double confidence;

  /// Human-readable reasoning for the routing decision.
  final String reasoning;

  /// Returns a copy of this result with optional overrides.
  RoutingResult copyWith({
    String? matchedIntent,
    List<String>? selectedAgents,
    double? confidence,
    String? reasoning,
  }) {
    return RoutingResult(
      matchedIntent: matchedIntent ?? this.matchedIntent,
      selectedAgents: selectedAgents ?? this.selectedAgents,
      confidence: confidence ?? this.confidence,
      reasoning: reasoning ?? this.reasoning,
    );
  }

  /// Converts this routing result to a map.
  Map<String, dynamic> toMap() {
    return {
      'matchedIntent': matchedIntent,
      'selectedAgents': List<String>.from(selectedAgents),
      'confidence': confidence,
      'reasoning': reasoning,
    };
  }

  /// Creates a [RoutingResult] from a map.
  factory RoutingResult.fromMap(Map<String, dynamic> map) {
    return RoutingResult(
      matchedIntent: map['matchedIntent'] as String,
      selectedAgents: List<String>.from(map['selectedAgents'] as List<dynamic>),
      confidence: map['confidence'] as double,
      reasoning: map['reasoning'] as String,
    );
  }
}
