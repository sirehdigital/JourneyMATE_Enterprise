import '../../agents/base/ai_agent.dart';
import '../../agents/base/agent_result.dart';
import 'flight_recommendation.dart';
import 'flight_request.dart';

/// Flight AI agent responsible for handling flight request execution.
class FlightAgent extends AIAgent {
  /// Creates a new [FlightAgent].
  const FlightAgent({
    required super.id,
    required super.name,
    required super.description,
    required super.priority,
  });

  @override
  Future<AgentResult> execute({
    required String prompt,
    required Map<String, dynamic> context,
  }) async {
    final request = _buildFlightRequest(context);
    final recommendation = _buildRecommendation(request);

    return AgentResult(
      agentId: id,
      success: true,
      message: _formatMessage(recommendation),
      metadata: {
        'request': request.toMap(),
        'recommendation': recommendation.toMap(),
      },
    );
  }

  FlightRequest _buildFlightRequest(Map<String, dynamic> context) {
    final origin = context['origin'] as String?;
    final destination = context['destination'] as String?;
    final departureDate = context['departureDate'] as DateTime?;
    final returnDate = context['returnDate'] as DateTime?;
    final travellers = context['travellers'] as int?;
    final cabinClass = context['cabinClass'] as String?;

    if (origin == null || origin.isEmpty) {
      throw ArgumentError.value(origin, 'origin', 'Origin is required.');
    }
    if (destination == null || destination.isEmpty) {
      throw ArgumentError.value(
        destination,
        'destination',
        'Destination is required.',
      );
    }
    if (departureDate == null) {
      throw ArgumentError.value(
        departureDate,
        'departureDate',
        'Departure date is required.',
      );
    }
    if (returnDate == null) {
      throw ArgumentError.value(
        returnDate,
        'returnDate',
        'Return date is required.',
      );
    }
    if (departureDate.isAfter(returnDate)) {
      throw ArgumentError.value(
        returnDate,
        'returnDate',
        'Return date must be after departure date.',
      );
    }
    if (travellers == null || travellers <= 0) {
      throw ArgumentError.value(
        travellers,
        'travellers',
        'Travellers must be greater than zero.',
      );
    }
    if (cabinClass == null || cabinClass.isEmpty) {
      throw ArgumentError.value(
        cabinClass,
        'cabinClass',
        'Cabin class is required.',
      );
    }

    return FlightRequest(
      origin: origin,
      destination: destination,
      departureDate: departureDate,
      returnDate: returnDate,
      travellers: travellers,
      cabinClass: cabinClass,
    );
  }

  FlightRecommendation _buildRecommendation(FlightRequest request) {
    final travelDuration = request.returnDate.difference(request.departureDate);
    final estimatedPrice = _estimatePrice(
      request.travellers,
      travelDuration.inDays,
      request.cabinClass,
    );
    final departureTime = DateTime(
      request.departureDate.year,
      request.departureDate.month,
      request.departureDate.day,
      9,
      0,
    );
    final arrivalTime = departureTime.add(const Duration(hours: 2));

    return FlightRecommendation(
      airline: 'JourneyMATE Airways',
      flightNumber:
          'JM${request.origin.substring(0, 2).toUpperCase()}${request.destination.substring(0, 2).toUpperCase()}1',
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      estimatedPrice: estimatedPrice,
      currency: 'MYR',
      notes:
          'This recommendation is a structural placeholder for future flight provider integrations.',
    );
  }

  double _estimatePrice(int travellers, int durationDays, String cabinClass) {
    final basePrice = 250.0;
    final cabinMultiplier = _cabinClassMultiplier(cabinClass);
    final durationFactor = durationDays > 0 ? durationDays.toDouble() : 1.0;
    return basePrice * cabinMultiplier * travellers * durationFactor;
  }

  double _cabinClassMultiplier(String cabinClass) {
    switch (cabinClass.toLowerCase()) {
      case 'business':
        return 2.4;
      case 'premium economy':
        return 1.6;
      case 'economy':
        return 1.0;
      case 'first':
        return 3.2;
      default:
        return 1.0;
    }
  }

  String _formatMessage(FlightRecommendation recommendation) {
    return '''Flight recommendation generated.
Airline: ${recommendation.airline}
Flight: ${recommendation.flightNumber}
Departure: ${recommendation.departureTime.toIso8601String()}
Arrival: ${recommendation.arrivalTime.toIso8601String()}
Price: ${recommendation.estimatedPrice.toStringAsFixed(2)} ${recommendation.currency}
Notes: ${recommendation.notes}
''';
  }
}
