/// Immutable summary object for budget analysis results.
class BudgetSummary {
  /// Creates a new [BudgetSummary].
  const BudgetSummary({
    required this.totalBudget,
    required this.estimatedTotalCost,
    required this.remainingBudget,
    required this.budgetStatus,
    required this.recommendations,
    required this.currency,
  });

  /// Total budget available for the trip.
  final double totalBudget;

  /// Total estimated cost for the trip.
  final double estimatedTotalCost;

  /// Remaining budget after estimated costs.
  final double remainingBudget;

  /// Budget status string.
  final String budgetStatus;

  /// Recommendations for improving the budget.
  final List<String> recommendations;

  /// Currency code for the budget.
  final String currency;

  /// Returns a copy of this summary with the provided overrides.
  BudgetSummary copyWith({
    double? totalBudget,
    double? estimatedTotalCost,
    double? remainingBudget,
    String? budgetStatus,
    List<String>? recommendations,
    String? currency,
  }) {
    return BudgetSummary(
      totalBudget: totalBudget ?? this.totalBudget,
      estimatedTotalCost: estimatedTotalCost ?? this.estimatedTotalCost,
      remainingBudget: remainingBudget ?? this.remainingBudget,
      budgetStatus: budgetStatus ?? this.budgetStatus,
      recommendations: recommendations ?? this.recommendations,
      currency: currency ?? this.currency,
    );
  }

  /// Converts this summary to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'totalBudget': totalBudget,
      'estimatedTotalCost': estimatedTotalCost,
      'remainingBudget': remainingBudget,
      'budgetStatus': budgetStatus,
      'recommendations': List<String>.from(recommendations),
      'currency': currency,
    };
  }

  /// Creates a [BudgetSummary] from a map representation.
  factory BudgetSummary.fromMap(Map<String, dynamic> map) {
    return BudgetSummary(
      totalBudget: map['totalBudget'] is int
          ? (map['totalBudget'] as int).toDouble()
          : map['totalBudget'] as double,
      estimatedTotalCost: map['estimatedTotalCost'] is int
          ? (map['estimatedTotalCost'] as int).toDouble()
          : map['estimatedTotalCost'] as double,
      remainingBudget: map['remainingBudget'] is int
          ? (map['remainingBudget'] as int).toDouble()
          : map['remainingBudget'] as double,
      budgetStatus: map['budgetStatus'] as String,
      recommendations: List<String>.from(
        map['recommendations'] as List<dynamic>,
      ),
      currency: map['currency'] as String,
    );
  }
}
