/// Immutable hotel recommendation returned by the hotel reservation agent.
class HotelRecommendation {
  /// Creates a new [HotelRecommendation].
  const HotelRecommendation({
    required this.hotelName,
    required this.hotelClass,
    required this.estimatedPrice,
    required this.currency,
    required this.location,
    required this.amenities,
    required this.checkInTime,
    required this.checkOutTime,
    required this.notes,
  });

  /// Recommended hotel name.
  final String hotelName;

  /// Hotel class or rating.
  final String hotelClass;

  /// Estimated price for the stay.
  final double estimatedPrice;

  /// Currency code for the price.
  final String currency;

  /// Hotel location description.
  final String location;

  /// Amenities included in the recommendation.
  final List<String> amenities;

  /// Recommended check-in time.
  final DateTime checkInTime;

  /// Recommended check-out time.
  final DateTime checkOutTime;

  /// Additional notes or guidance.
  final String notes;

  /// Returns a copy of this recommendation with the provided values updated.
  HotelRecommendation copyWith({
    String? hotelName,
    String? hotelClass,
    double? estimatedPrice,
    String? currency,
    String? location,
    List<String>? amenities,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? notes,
  }) {
    return HotelRecommendation(
      hotelName: hotelName ?? this.hotelName,
      hotelClass: hotelClass ?? this.hotelClass,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      currency: currency ?? this.currency,
      location: location ?? this.location,
      amenities: amenities ?? this.amenities,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      notes: notes ?? this.notes,
    );
  }

  /// Converts this recommendation to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'hotelName': hotelName,
      'hotelClass': hotelClass,
      'estimatedPrice': estimatedPrice,
      'currency': currency,
      'location': location,
      'amenities': List<String>.from(amenities),
      'checkInTime': checkInTime.toIso8601String(),
      'checkOutTime': checkOutTime.toIso8601String(),
      'notes': notes,
    };
  }

  /// Creates a [HotelRecommendation] from a map representation.
  factory HotelRecommendation.fromMap(Map<String, dynamic> map) {
    return HotelRecommendation(
      hotelName: map['hotelName'] as String,
      hotelClass: map['hotelClass'] as String,
      estimatedPrice: map['estimatedPrice'] is int
          ? (map['estimatedPrice'] as int).toDouble()
          : map['estimatedPrice'] as double,
      currency: map['currency'] as String,
      location: map['location'] as String,
      amenities: List<String>.from(map['amenities'] as List<dynamic>),
      checkInTime: DateTime.parse(map['checkInTime'] as String),
      checkOutTime: DateTime.parse(map['checkOutTime'] as String),
      notes: map['notes'] as String,
    );
  }
}
