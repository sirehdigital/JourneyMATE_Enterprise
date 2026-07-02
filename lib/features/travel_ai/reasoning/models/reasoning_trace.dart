class ReasoningTrace {
  const ReasoningTrace({
    required this.timestamp,
    required this.executedRules,
    required this.skippedRules,
    required this.decisionTime,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final DateTime timestamp;
  final List<String> executedRules;
  final List<String> skippedRules;
  final int decisionTime;
  final Map<String, dynamic> metadata;

  ReasoningTrace copyWith({
    DateTime? timestamp,
    List<String>? executedRules,
    List<String>? skippedRules,
    int? decisionTime,
    Map<String, dynamic>? metadata,
  }) {
    return ReasoningTrace(
      timestamp: timestamp ?? this.timestamp,
      executedRules: executedRules ?? this.executedRules,
      skippedRules: skippedRules ?? this.skippedRules,
      decisionTime: decisionTime ?? this.decisionTime,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp.toIso8601String(),
      'executedRules': executedRules,
      'skippedRules': skippedRules,
      'decisionTime': decisionTime,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ReasoningTrace.fromMap(Map<String, dynamic> map) {
    return ReasoningTrace(
      timestamp:
          DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      executedRules:
          (map['executedRules'] as List<dynamic>?)
              ?.map((dynamic item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
      skippedRules:
          (map['skippedRules'] as List<dynamic>?)
              ?.map((dynamic item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
      decisionTime: (map['decisionTime'] as num?)?.toInt() ?? 0,
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic entry) =>
            MapEntry<String, dynamic>(key.toString(), entry),
      );
    }
    return <String, dynamic>{};
  }
}
