class RecommendationRequest {
  const RecommendationRequest({
    required this.destination,
    this.travelStyle = '',
    this.budget = 0,
    this.durationDays = 1,
    this.travellers = 1,
    Map<String, dynamic>? preferences,
  }) : preferences = preferences ?? const <String, dynamic>{};

  final String destination;
  final String travelStyle;
  final double budget;
  final int durationDays;
  final int travellers;
  final Map<String, dynamic> preferences;

  RecommendationRequest copyWith({
    String? destination,
    String? travelStyle,
    double? budget,
    int? durationDays,
    int? travellers,
    Map<String, dynamic>? preferences,
  }) {
    return RecommendationRequest(
      destination: destination ?? this.destination,
      travelStyle: travelStyle ?? this.travelStyle,
      budget: budget ?? this.budget,
      durationDays: durationDays ?? this.durationDays,
      travellers: travellers ?? this.travellers,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'destination': destination,
      'travelStyle': travelStyle,
      'budget': budget,
      'durationDays': durationDays,
      'travellers': travellers,
      'preferences': Map<String, dynamic>.from(preferences),
    };
  }

  factory RecommendationRequest.fromMap(Map<String, dynamic> map) {
    return RecommendationRequest(
      destination: map['destination']?.toString() ?? '',
      travelStyle: map['travelStyle']?.toString() ?? '',
      budget: (map['budget'] as num?)?.toDouble() ?? 0,
      durationDays: (map['durationDays'] as num?)?.toInt() ?? 1,
      travellers: (map['travellers'] as num?)?.toInt() ?? 1,
      preferences: _normalizeMap(map['preferences']),
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
