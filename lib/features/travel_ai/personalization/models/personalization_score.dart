class PersonalizationScore {
  const PersonalizationScore({
    required this.destinationMatch,
    required this.budgetMatch,
    required this.travelStyleMatch,
    required this.accommodationMatch,
    required this.transportMatch,
    required this.overallScore,
    required this.confidence,
  });

  final double destinationMatch;
  final double budgetMatch;
  final double travelStyleMatch;
  final double accommodationMatch;
  final double transportMatch;
  final double overallScore;
  final double confidence;

  PersonalizationScore copyWith({
    double? destinationMatch,
    double? budgetMatch,
    double? travelStyleMatch,
    double? accommodationMatch,
    double? transportMatch,
    double? overallScore,
    double? confidence,
  }) {
    return PersonalizationScore(
      destinationMatch: destinationMatch ?? this.destinationMatch,
      budgetMatch: budgetMatch ?? this.budgetMatch,
      travelStyleMatch: travelStyleMatch ?? this.travelStyleMatch,
      accommodationMatch: accommodationMatch ?? this.accommodationMatch,
      transportMatch: transportMatch ?? this.transportMatch,
      overallScore: overallScore ?? this.overallScore,
      confidence: confidence ?? this.confidence,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'destinationMatch': destinationMatch,
      'budgetMatch': budgetMatch,
      'travelStyleMatch': travelStyleMatch,
      'accommodationMatch': accommodationMatch,
      'transportMatch': transportMatch,
      'overallScore': overallScore,
      'confidence': confidence,
    };
  }

  factory PersonalizationScore.fromMap(Map<String, dynamic> map) {
    return PersonalizationScore(
      destinationMatch: (map['destinationMatch'] as num?)?.toDouble() ?? 0,
      budgetMatch: (map['budgetMatch'] as num?)?.toDouble() ?? 0,
      travelStyleMatch: (map['travelStyleMatch'] as num?)?.toDouble() ?? 0,
      accommodationMatch: (map['accommodationMatch'] as num?)?.toDouble() ?? 0,
      transportMatch: (map['transportMatch'] as num?)?.toDouble() ?? 0,
      overallScore: (map['overallScore'] as num?)?.toDouble() ?? 0,
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0,
    );
  }
}
