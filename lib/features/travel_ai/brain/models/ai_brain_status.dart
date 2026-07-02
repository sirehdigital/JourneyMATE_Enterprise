import 'dart:convert';

class AIBrainStatus {
  const AIBrainStatus({
    this.initialized = false,
    this.knowledgeReady = false,
    this.memoryReady = false,
    this.plannerReady = false,
    this.reasoningReady = false,
    this.recommendationReady = false,
    this.personalizationReady = false,
    this.explainableReady = false,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final bool initialized;
  final bool knowledgeReady;
  final bool memoryReady;
  final bool plannerReady;
  final bool reasoningReady;
  final bool recommendationReady;
  final bool personalizationReady;
  final bool explainableReady;
  final Map<String, dynamic> metadata;

  AIBrainStatus copyWith({
    bool? initialized,
    bool? knowledgeReady,
    bool? memoryReady,
    bool? plannerReady,
    bool? reasoningReady,
    bool? recommendationReady,
    bool? personalizationReady,
    bool? explainableReady,
    Map<String, dynamic>? metadata,
  }) {
    return AIBrainStatus(
      initialized: initialized ?? this.initialized,
      knowledgeReady: knowledgeReady ?? this.knowledgeReady,
      memoryReady: memoryReady ?? this.memoryReady,
      plannerReady: plannerReady ?? this.plannerReady,
      reasoningReady: reasoningReady ?? this.reasoningReady,
      recommendationReady: recommendationReady ?? this.recommendationReady,
      personalizationReady: personalizationReady ?? this.personalizationReady,
      explainableReady: explainableReady ?? this.explainableReady,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'initialized': initialized,
      'knowledgeReady': knowledgeReady,
      'memoryReady': memoryReady,
      'plannerReady': plannerReady,
      'reasoningReady': reasoningReady,
      'recommendationReady': recommendationReady,
      'personalizationReady': personalizationReady,
      'explainableReady': explainableReady,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory AIBrainStatus.fromMap(Map<String, dynamic> map) {
    return AIBrainStatus(
      initialized: _boolOrDefault(map['initialized']),
      knowledgeReady: _boolOrDefault(map['knowledgeReady']),
      memoryReady: _boolOrDefault(map['memoryReady']),
      plannerReady: _boolOrDefault(map['plannerReady']),
      reasoningReady: _boolOrDefault(map['reasoningReady']),
      recommendationReady: _boolOrDefault(map['recommendationReady']),
      personalizationReady: _boolOrDefault(map['personalizationReady']),
      explainableReady: _boolOrDefault(map['explainableReady']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory AIBrainStatus.fromJson(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        return AIBrainStatus.fromMap(decoded);
      }
      if (decoded is Map) {
        return AIBrainStatus.fromMap(_normalizeMap(decoded));
      }
    } on FormatException {
      return const AIBrainStatus();
    }
    return const AIBrainStatus();
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

  static bool _boolOrDefault(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalizedValue = value.trim().toLowerCase();
      if (normalizedValue == 'true' || normalizedValue == '1') {
        return true;
      }
      if (normalizedValue == 'false' || normalizedValue == '0') {
        return false;
      }
    }
    return false;
  }
}
