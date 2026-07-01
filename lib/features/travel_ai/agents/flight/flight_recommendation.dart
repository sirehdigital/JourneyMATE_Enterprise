/// Immutable flight recommendation produced by the FlightAgent.
class FlightRecommendation {
  /// Creates a new [FlightRecommendation].
  const FlightRecommendation({
    required this.airline,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.estimatedPrice,
    required this.currency,
    required this.notes,
  });

  /// Airline operating the flight.
  final String airline;

  /// Flight number.
  final String flightNumber;

  /// Scheduled departure time.
  final DateTime departureTime;

  /// Scheduled arrival time.
  final DateTime arrivalTime;

  /// Estimated price for the itinerary.
  final double estimatedPrice;

  /// Currency code for the estimated price.
  final String currency;

  /// Human-readable notes about the recommendation.
  final String notes;

  /// Converts this recommendation to a map.
  Map<String, dynamic> toMap() {
    return {
      'airline': airline,
      'flightNumber': flightNumber,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'estimatedPrice': estimatedPrice,
      'currency': currency,
      'notes': notes,
    };
  }

  /// Creates a [FlightRecommendation] from a map.
  factory FlightRecommendation.fromMap(Map<String, dynamic> map) {
    return FlightRecommendation(
      airline: map['airline'] as String,
      flightNumber: map['flightNumber'] as String,
      departureTime: DateTime.parse(map['departureTime'] as String),
      arrivalTime: DateTime.parse(map['arrivalTime'] as String),
      estimatedPrice: map['estimatedPrice'] as double,
      currency: map['currency'] as String,
      notes: map['notes'] as String,
    );
  }
}
