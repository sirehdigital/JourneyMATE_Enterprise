class ExplanationScore {
  const ExplanationScore({
    required this.recommendationConfidence,
    required this.knowledgeConfidence,
    required this.personalizationConfidence,
    required this.plannerConfidence,
    required this.overallConfidence,
  });

  final double recommendationConfidence;
  final double knowledgeConfidence;
  final double personalizationConfidence;
  final double plannerConfidence;
  final double overallConfidence;

  ExplanationScore copyWith({
    double? recommendationConfidence,
    double? knowledgeConfidence,
    double? personalizationConfidence,
    double? plannerConfidence,
    double? overallConfidence,
  }) {
    return ExplanationScore(
      recommendationConfidence:
          recommendationConfidence ?? this.recommendationConfidence,
      knowledgeConfidence: knowledgeConfidence ?? this.knowledgeConfidence,
      personalizationConfidence:
          personalizationConfidence ?? this.personalizationConfidence,
      plannerConfidence: plannerConfidence ?? this.plannerConfidence,
      overallConfidence: overallConfidence ?? this.overallConfidence,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recommendationConfidence': recommendationConfidence,
      'knowledgeConfidence': knowledgeConfidence,
      'personalizationConfidence': personalizationConfidence,
      'plannerConfidence': plannerConfidence,
      'overallConfidence': overallConfidence,
    };
  }

  factory ExplanationScore.fromMap(Map<String, dynamic> map) {
    return ExplanationScore(
      recommendationConfidence:
          (map['recommendationConfidence'] as num?)?.toDouble() ?? 0,
      knowledgeConfidence:
          (map['knowledgeConfidence'] as num?)?.toDouble() ?? 0,
      personalizationConfidence:
          (map['personalizationConfidence'] as num?)?.toDouble() ?? 0,
      plannerConfidence: (map['plannerConfidence'] as num?)?.toDouble() ?? 0,
      overallConfidence: (map['overallConfidence'] as num?)?.toDouble() ?? 0,
    );
  }
}
