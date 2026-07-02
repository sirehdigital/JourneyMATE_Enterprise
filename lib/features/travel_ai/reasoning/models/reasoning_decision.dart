class ReasoningDecision {
  const ReasoningDecision({
    required this.id,
    required this.title,
    required this.description,
    required this.confidence,
    required this.decisionType,
    required this.appliedRules,
    required this.recommendations,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String id;
  final String title;
  final String description;
  final double confidence;
  final String decisionType;
  final List<String> appliedRules;
  final List<String> recommendations;
  final Map<String, dynamic> metadata;

  ReasoningDecision copyWith({
    String? id,
    String? title,
    String? description,
    double? confidence,
    String? decisionType,
    List<String>? appliedRules,
    List<String>? recommendations,
    Map<String, dynamic>? metadata,
  }) {
    return ReasoningDecision(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      confidence: confidence ?? this.confidence,
      decisionType: decisionType ?? this.decisionType,
      appliedRules: appliedRules ?? this.appliedRules,
      recommendations: recommendations ?? this.recommendations,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'confidence': confidence,
      'decisionType': decisionType,
      'appliedRules': appliedRules,
      'recommendations': recommendations,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ReasoningDecision.fromMap(Map<String, dynamic> map) {
    return ReasoningDecision(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0,
      decisionType: map['decisionType']?.toString() ?? 'general',
      appliedRules:
          (map['appliedRules'] as List<dynamic>?)
              ?.map((dynamic item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
      recommendations:
          (map['recommendations'] as List<dynamic>?)
              ?.map((dynamic item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
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
