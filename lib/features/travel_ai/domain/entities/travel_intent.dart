import '../enums/travel_intent_type.dart';

class TravelIntent {
  TravelIntent({
    required this.type,
    this.destination,
    this.origin,
    this.durationDays,
    this.budget,
    this.travellers,
    required this.rawPrompt,
  });

  final TravelIntentType type;
  final String? destination;
  final String? origin;
  final int? durationDays;
  final double? budget;
  final int? travellers;
  final String rawPrompt;

  TravelIntent copyWith({
    TravelIntentType? type,
    String? destination,
    String? origin,
    int? durationDays,
    double? budget,
    int? travellers,
    String? rawPrompt,
  }) {
    return TravelIntent(
      type: type ?? this.type,
      destination: destination ?? this.destination,
      origin: origin ?? this.origin,
      durationDays: durationDays ?? this.durationDays,
      budget: budget ?? this.budget,
      travellers: travellers ?? this.travellers,
      rawPrompt: rawPrompt ?? this.rawPrompt,
    );
  }
}
