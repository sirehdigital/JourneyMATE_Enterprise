/// Immutable request payload for the FlightAgent.
class FlightRequest {
  /// Creates a new [FlightRequest].
  const FlightRequest({
    required this.origin,
    required this.destination,
    required this.departureDate,
    required this.returnDate,
    required this.travellers,
    required this.cabinClass,
  });

  /// Departure location.
  final String origin;

  /// Arrival location.
  final String destination;

  /// Departure date.
  final DateTime departureDate;

  /// Return date.
  final DateTime returnDate;

  /// Number of travellers.
  final int travellers;

  /// Cabin class preference.
  final String cabinClass;

  /// Converts this request to a map.
  Map<String, dynamic> toMap() {
    return {
      'origin': origin,
      'destination': destination,
      'departureDate': departureDate.toIso8601String(),
      'returnDate': returnDate.toIso8601String(),
      'travellers': travellers,
      'cabinClass': cabinClass,
    };
  }

  /// Creates a [FlightRequest] from a map.
  factory FlightRequest.fromMap(Map<String, dynamic> map) {
    return FlightRequest(
      origin: map['origin'] as String,
      destination: map['destination'] as String,
      departureDate: DateTime.parse(map['departureDate'] as String),
      returnDate: DateTime.parse(map['returnDate'] as String),
      travellers: map['travellers'] as int,
      cabinClass: map['cabinClass'] as String,
    );
  }
}
