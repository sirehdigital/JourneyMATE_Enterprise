class TravelPlanRequest {
  TravelPlanRequest({
    required this.destination,
    this.durationDays = 1,
    this.travellers = 1,
    this.budget = 0,
    this.travelStyle = '',
    this.transportMode = '',
    Map<String, dynamic>? preferences,
    DateTime? startDate,
  }) : preferences = preferences ?? const <String, dynamic>{},
       startDate = startDate ?? DateTime.now();

  final String destination;
  final int durationDays;
  final int travellers;
  final double budget;
  final String travelStyle;
  final String transportMode;
  final Map<String, dynamic> preferences;
  final DateTime startDate;

  TravelPlanRequest copyWith({
    String? destination,
    int? durationDays,
    int? travellers,
    double? budget,
    String? travelStyle,
    String? transportMode,
    Map<String, dynamic>? preferences,
    DateTime? startDate,
  }) {
    return TravelPlanRequest(
      destination: destination ?? this.destination,
      durationDays: durationDays ?? this.durationDays,
      travellers: travellers ?? this.travellers,
      budget: budget ?? this.budget,
      travelStyle: travelStyle ?? this.travelStyle,
      transportMode: transportMode ?? this.transportMode,
      preferences: preferences ?? this.preferences,
      startDate: startDate ?? this.startDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'destination': destination,
      'durationDays': durationDays,
      'travellers': travellers,
      'budget': budget,
      'travelStyle': travelStyle,
      'transportMode': transportMode,
      'preferences': Map<String, dynamic>.from(preferences),
      'startDate': startDate.toIso8601String(),
    };
  }

  factory TravelPlanRequest.fromMap(Map<String, dynamic> map) {
    return TravelPlanRequest(
      destination: map['destination']?.toString() ?? '',
      durationDays: (map['durationDays'] as num?)?.toInt() ?? 1,
      travellers: (map['travellers'] as num?)?.toInt() ?? 1,
      budget: (map['budget'] as num?)?.toDouble() ?? 0,
      travelStyle: map['travelStyle']?.toString() ?? '',
      transportMode: map['transportMode']?.toString() ?? '',
      preferences: _normalizeMap(map['preferences']),
      startDate:
          DateTime.tryParse(map['startDate']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  static Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic entry) =>
            MapEntry<String, dynamic>(key.toString(), entry),
      );
    }
    return <String, dynamic>{};
  }
}
