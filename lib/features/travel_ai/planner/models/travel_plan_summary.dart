class TravelPlanSummary {
  const TravelPlanSummary({
    required this.totalBudget,
    required this.estimatedSpent,
    required this.remainingBudget,
    required this.totalActivities,
    required this.recommendationScore,
  });

  final double totalBudget;
  final double estimatedSpent;
  final double remainingBudget;
  final int totalActivities;
  final double recommendationScore;

  TravelPlanSummary copyWith({
    double? totalBudget,
    double? estimatedSpent,
    double? remainingBudget,
    int? totalActivities,
    double? recommendationScore,
  }) {
    return TravelPlanSummary(
      totalBudget: totalBudget ?? this.totalBudget,
      estimatedSpent: estimatedSpent ?? this.estimatedSpent,
      remainingBudget: remainingBudget ?? this.remainingBudget,
      totalActivities: totalActivities ?? this.totalActivities,
      recommendationScore: recommendationScore ?? this.recommendationScore,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalBudget': totalBudget,
      'estimatedSpent': estimatedSpent,
      'remainingBudget': remainingBudget,
      'totalActivities': totalActivities,
      'recommendationScore': recommendationScore,
    };
  }

  factory TravelPlanSummary.fromMap(Map<String, dynamic> map) {
    return TravelPlanSummary(
      totalBudget: (map['totalBudget'] as num?)?.toDouble() ?? 0,
      estimatedSpent: (map['estimatedSpent'] as num?)?.toDouble() ?? 0,
      remainingBudget: (map['remainingBudget'] as num?)?.toDouble() ?? 0,
      totalActivities: (map['totalActivities'] as num?)?.toInt() ?? 0,
      recommendationScore:
          (map['recommendationScore'] as num?)?.toDouble() ?? 0,
    );
  }
}
