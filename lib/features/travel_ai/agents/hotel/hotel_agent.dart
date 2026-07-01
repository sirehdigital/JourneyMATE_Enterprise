import '../../agents/base/ai_agent.dart';
import '../../agents/base/agent_result.dart';
import 'hotel_recommendation.dart';
import 'hotel_request.dart';

/// Hotel AI agent responsible for validating hotel requests and producing
/// structured hotel recommendations.
class HotelAgent extends AIAgent {
  /// Creates a new [HotelAgent].
  const HotelAgent({
    required super.id,
    required super.name,
    required super.description,
    required super.priority,
  });

  /// Returns the capabilities exposed by this hotel agent.
  static const capabilities = <String>[
    'hotel_search',
    'hotel_compare',
    'hotel_price',
    'hotel_information',
    'hotel_recommendation',
  ];

  @override
  Future<AgentResult> execute({
    required String prompt,
    required Map<String, dynamic> context,
  }) async {
    final request = _buildHotelRequest(context);
    final recommendation = _buildRecommendation(request);

    return AgentResult(
      agentId: id,
      success: true,
      message: _formatMessage(recommendation),
      metadata: {
        'destination': request.destination,
        'guests': request.guests,
        'rooms': request.rooms,
        'budget': request.budget,
        'hotelClass': request.hotelClass,
        'preferredArea': request.preferredArea,
        'recommendation': recommendation.toMap(),
      },
    );
  }

  HotelRequest _buildHotelRequest(Map<String, dynamic> context) {
    final destination = context['destination'] as String?;
    final checkInDate = context['checkInDate'] as DateTime?;
    final checkOutDate = context['checkOutDate'] as DateTime?;
    final guests = context['guests'] as int?;
    final rooms = context['rooms'] as int?;
    final hotelClass = context['hotelClass'] as String?;
    final budget = context['budget'] is int
        ? (context['budget'] as int).toDouble()
        : context['budget'] as double?;
    final preferredArea = context['preferredArea'] as String?;

    if (destination == null || destination.isEmpty) {
      throw ArgumentError.value(
        destination,
        'destination',
        'Destination cannot be empty.',
      );
    }
    if (checkInDate == null) {
      throw ArgumentError.value(
        checkInDate,
        'checkInDate',
        'Check-in date is required.',
      );
    }
    if (checkOutDate == null) {
      throw ArgumentError.value(
        checkOutDate,
        'checkOutDate',
        'Check-out date is required.',
      );
    }
    if (checkOutDate.isBefore(checkInDate) ||
        checkOutDate.isAtSameMomentAs(checkInDate)) {
      throw ArgumentError.value(
        checkOutDate,
        'checkOutDate',
        'Check-out date must be after check-in date.',
      );
    }
    if (guests == null || guests <= 0) {
      throw ArgumentError.value(
        guests,
        'guests',
        'Guests must be greater than zero.',
      );
    }
    if (rooms == null || rooms <= 0) {
      throw ArgumentError.value(
        rooms,
        'rooms',
        'Rooms must be greater than zero.',
      );
    }
    if (budget == null || budget < 0) {
      throw ArgumentError.value(budget, 'budget', 'Budget cannot be negative.');
    }
    if (hotelClass == null || hotelClass.isEmpty) {
      throw ArgumentError.value(
        hotelClass,
        'hotelClass',
        'Hotel class is required.',
      );
    }

    return HotelRequest(
      destination: destination,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      guests: guests,
      rooms: rooms,
      hotelClass: hotelClass,
      budget: budget,
      preferredArea: preferredArea ?? 'Any',
    );
  }

  HotelRecommendation _buildRecommendation(HotelRequest request) {
    final stayDuration = request.checkOutDate
        .difference(request.checkInDate)
        .inDays;
    final baseRate = _baseRateForClass(request.hotelClass);
    final estimatedPrice = _estimatePrice(
      baseRate,
      stayDuration,
      request.rooms,
      request.guests,
      request.budget,
    );
    final checkInTime = DateTime(
      request.checkInDate.year,
      request.checkInDate.month,
      request.checkInDate.day,
      15,
      0,
    );
    final checkOutTime = DateTime(
      request.checkOutDate.year,
      request.checkOutDate.month,
      request.checkOutDate.day,
      11,
      0,
    );

    return HotelRecommendation(
      hotelName: 'JourneyMATE Grand ${request.destination}',
      hotelClass: request.hotelClass,
      estimatedPrice: estimatedPrice,
      currency: 'MYR',
      location: request.preferredArea.isNotEmpty
          ? request.preferredArea
          : 'City center',
      amenities: _defaultAmenitiesForClass(request.hotelClass),
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      notes:
          'Recommendation is based on the provided request context and is structured for future booking provider integration.',
    );
  }

  double _baseRateForClass(String hotelClass) {
    switch (hotelClass.toLowerCase()) {
      case 'budget':
        return 120.0;
      case 'standard':
        return 220.0;
      case 'business':
        return 360.0;
      case 'luxury':
        return 520.0;
      default:
        return 240.0;
    }
  }

  double _estimatePrice(
    double baseRate,
    int stayDuration,
    int rooms,
    int guests,
    double budget,
  ) {
    final durationFactor = stayDuration > 0 ? stayDuration.toDouble() : 1.0;
    final roomFactor = rooms.toDouble();
    final guestSurcharge = guests > 2 ? (guests - 2) * 25.0 : 0.0;
    final rawPrice = (baseRate * durationFactor * roomFactor) + guestSurcharge;
    return rawPrice > budget ? budget : rawPrice;
  }

  List<String> _defaultAmenitiesForClass(String hotelClass) {
    switch (hotelClass.toLowerCase()) {
      case 'budget':
        return ['Free Wi-Fi', 'Daily breakfast', '24-hour front desk'];
      case 'standard':
        return [
          'Free Wi-Fi',
          'Breakfast included',
          'Gym access',
          'Airport shuttle',
        ];
      case 'business':
        return ['Free Wi-Fi', 'Business lounge', 'Meeting rooms', 'Gym access'];
      case 'luxury':
        return ['Spa access', 'Fine dining', 'Concierge', 'Pool'];
      default:
        return ['Free Wi-Fi', 'Breakfast included', 'Flexible check-in'];
    }
  }

  String _formatMessage(HotelRecommendation recommendation) {
    return '''Hotel recommendation generated.
Hotel: ${recommendation.hotelName}
Class: ${recommendation.hotelClass}
Location: ${recommendation.location}
Check-in: ${recommendation.checkInTime.toIso8601String()}
Check-out: ${recommendation.checkOutTime.toIso8601String()}
Price: ${recommendation.estimatedPrice.toStringAsFixed(2)} ${recommendation.currency}
Amenities: ${recommendation.amenities.join(', ')}
Notes: ${recommendation.notes}
''';
  }
}
