/// Immutable request object for hotel search and recommendation operations.
class HotelRequest {
  /// Creates a new [HotelRequest].
  const HotelRequest({
    required this.destination,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.rooms,
    required this.hotelClass,
    required this.budget,
    required this.preferredArea,
  });

  /// Destination city or region.
  final String destination;

  /// Check-in date for the hotel booking.
  final DateTime checkInDate;

  /// Check-out date for the hotel booking.
  final DateTime checkOutDate;

  /// Number of guests staying.
  final int guests;

  /// Number of rooms required.
  final int rooms;

  /// Hotel class or tier, such as economy, business, or luxury.
  final String hotelClass;

  /// Budget limit for the hotel booking.
  final double budget;

  /// Preferred area or neighborhood.
  final String preferredArea;

  /// Returns a copy of this request with the provided values updated.
  HotelRequest copyWith({
    String? destination,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guests,
    int? rooms,
    String? hotelClass,
    double? budget,
    String? preferredArea,
  }) {
    return HotelRequest(
      destination: destination ?? this.destination,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guests: guests ?? this.guests,
      rooms: rooms ?? this.rooms,
      hotelClass: hotelClass ?? this.hotelClass,
      budget: budget ?? this.budget,
      preferredArea: preferredArea ?? this.preferredArea,
    );
  }

  /// Converts this request to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'destination': destination,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'guests': guests,
      'rooms': rooms,
      'hotelClass': hotelClass,
      'budget': budget,
      'preferredArea': preferredArea,
    };
  }

  /// Creates a [HotelRequest] from a map representation.
  factory HotelRequest.fromMap(Map<String, dynamic> map) {
    return HotelRequest(
      destination: map['destination'] as String,
      checkInDate: DateTime.parse(map['checkInDate'] as String),
      checkOutDate: DateTime.parse(map['checkOutDate'] as String),
      guests: map['guests'] as int,
      rooms: map['rooms'] as int,
      hotelClass: map['hotelClass'] as String,
      budget: map['budget'] is int
          ? (map['budget'] as int).toDouble()
          : map['budget'] as double,
      preferredArea: map['preferredArea'] as String,
    );
  }
}
