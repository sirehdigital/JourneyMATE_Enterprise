/// Immutable request object for budget analysis operations.
class BudgetRequest {
  /// Creates a new [BudgetRequest].
  const BudgetRequest({
    required this.totalBudget,
    required this.currency,
    required this.travellers,
    required this.tripDays,
    required this.destination,
    required this.estimatedFlightCost,
    required this.estimatedHotelCost,
    required this.estimatedTransportCost,
    required this.estimatedFoodCost,
    required this.estimatedActivityCost,
  });

  /// Total budget for the trip.
  final double totalBudget;

  /// Currency code for the budget.
  final String currency;

  /// Total number of travellers.
  final int travellers;

  /// Number of days for the trip.
  final int tripDays;

  /// Destination city or region.
  final String destination;

  /// Estimated flight cost for the trip.
  final double estimatedFlightCost;

  /// Estimated hotel cost for the trip.
  final double estimatedHotelCost;

  /// Estimated transport cost for the trip.
  final double estimatedTransportCost;

  /// Estimated food cost for the trip.
  final double estimatedFoodCost;

  /// Estimated activity cost for the trip.
  final double estimatedActivityCost;

  /// Returns a copy of this request with the provided overrides.
  BudgetRequest copyWith({
    double? totalBudget,
    String? currency,
    int? travellers,
    int? tripDays,
    String? destination,
    double? estimatedFlightCost,
    double? estimatedHotelCost,
    double? estimatedTransportCost,
    double? estimatedFoodCost,
    double? estimatedActivityCost,
  }) {
    return BudgetRequest(
      totalBudget: totalBudget ?? this.totalBudget,
      currency: currency ?? this.currency,
      travellers: travellers ?? this.travellers,
      tripDays: tripDays ?? this.tripDays,
      destination: destination ?? this.destination,
      estimatedFlightCost: estimatedFlightCost ?? this.estimatedFlightCost,
      estimatedHotelCost: estimatedHotelCost ?? this.estimatedHotelCost,
      estimatedTransportCost:
          estimatedTransportCost ?? this.estimatedTransportCost,
      estimatedFoodCost: estimatedFoodCost ?? this.estimatedFoodCost,
      estimatedActivityCost:
          estimatedActivityCost ?? this.estimatedActivityCost,
    );
  }

  /// Converts this request to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'totalBudget': totalBudget,
      'currency': currency,
      'travellers': travellers,
      'tripDays': tripDays,
      'destination': destination,
      'estimatedFlightCost': estimatedFlightCost,
      'estimatedHotelCost': estimatedHotelCost,
      'estimatedTransportCost': estimatedTransportCost,
      'estimatedFoodCost': estimatedFoodCost,
      'estimatedActivityCost': estimatedActivityCost,
    };
  }

  /// Creates a [BudgetRequest] from a map representation.
  factory BudgetRequest.fromMap(Map<String, dynamic> map) {
    return BudgetRequest(
      totalBudget: map['totalBudget'] is int
          ? (map['totalBudget'] as int).toDouble()
          : map['totalBudget'] as double,
      currency: map['currency'] as String,
      travellers: map['travellers'] as int,
      tripDays: map['tripDays'] as int,
      destination: map['destination'] as String,
      estimatedFlightCost: map['estimatedFlightCost'] is int
          ? (map['estimatedFlightCost'] as int).toDouble()
          : map['estimatedFlightCost'] as double,
      estimatedHotelCost: map['estimatedHotelCost'] is int
          ? (map['estimatedHotelCost'] as int).toDouble()
          : map['estimatedHotelCost'] as double,
      estimatedTransportCost: map['estimatedTransportCost'] is int
          ? (map['estimatedTransportCost'] as int).toDouble()
          : map['estimatedTransportCost'] as double,
      estimatedFoodCost: map['estimatedFoodCost'] is int
          ? (map['estimatedFoodCost'] as int).toDouble()
          : map['estimatedFoodCost'] as double,
      estimatedActivityCost: map['estimatedActivityCost'] is int
          ? (map['estimatedActivityCost'] as int).toDouble()
          : map['estimatedActivityCost'] as double,
    );
  }
}
