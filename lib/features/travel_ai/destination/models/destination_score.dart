class DestinationScore {
  const DestinationScore({
    this.attractionScore = 0.0,
    this.accommodationScore = 0.0,
    this.foodScore = 0.0,
    this.transportScore = 0.0,
    this.overallScore = 0.0,
  });

  final double attractionScore;
  final double accommodationScore;
  final double foodScore;
  final double transportScore;
  final double overallScore;

  DestinationScore copyWith({
    double? attractionScore,
    double? accommodationScore,
    double? foodScore,
    double? transportScore,
    double? overallScore,
  }) {
    return DestinationScore(
      attractionScore: attractionScore ?? this.attractionScore,
      accommodationScore: accommodationScore ?? this.accommodationScore,
      foodScore: foodScore ?? this.foodScore,
      transportScore: transportScore ?? this.transportScore,
      overallScore: overallScore ?? this.overallScore,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attractionScore': attractionScore,
      'accommodationScore': accommodationScore,
      'foodScore': foodScore,
      'transportScore': transportScore,
      'overallScore': overallScore,
    };
  }
}
