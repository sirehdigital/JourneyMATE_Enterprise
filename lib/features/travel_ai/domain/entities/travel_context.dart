import '../enums/travel_style.dart';
import '../enums/transport_mode.dart';

class TravelContext {
  TravelContext({
    this.destination,
    this.origin,
    this.travellers,
    this.durationDays,
    this.budget,
    this.departureDate,
    this.returnDate,
    this.travelStyle = TravelStyle.unknown,
    this.transportMode = TransportMode.unknown,
    this.language,
    this.muslimFriendly = false,
    this.wheelchairAccess = false,
    this.familyFriendly = false,
    this.kidsFriendly = false,
    required this.rawPrompt,
  });

  final String? destination;
  final String? origin;
  final int? travellers;
  final int? durationDays;
  final double? budget;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final TravelStyle travelStyle;
  final TransportMode transportMode;
  final String? language;
  final bool muslimFriendly;
  final bool wheelchairAccess;
  final bool familyFriendly;
  final bool kidsFriendly;
  final String rawPrompt;

  TravelContext copyWith({
    String? destination,
    String? origin,
    int? travellers,
    int? durationDays,
    double? budget,
    DateTime? departureDate,
    DateTime? returnDate,
    TravelStyle? travelStyle,
    TransportMode? transportMode,
    String? language,
    bool? muslimFriendly,
    bool? wheelchairAccess,
    bool? familyFriendly,
    bool? kidsFriendly,
    String? rawPrompt,
  }) {
    return TravelContext(
      destination: destination ?? this.destination,
      origin: origin ?? this.origin,
      travellers: travellers ?? this.travellers,
      durationDays: durationDays ?? this.durationDays,
      budget: budget ?? this.budget,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      travelStyle: travelStyle ?? this.travelStyle,
      transportMode: transportMode ?? this.transportMode,
      language: language ?? this.language,
      muslimFriendly: muslimFriendly ?? this.muslimFriendly,
      wheelchairAccess: wheelchairAccess ?? this.wheelchairAccess,
      familyFriendly: familyFriendly ?? this.familyFriendly,
      kidsFriendly: kidsFriendly ?? this.kidsFriendly,
      rawPrompt: rawPrompt ?? this.rawPrompt,
    );
  }
}
