class DestinationRequest {
  const DestinationRequest({
    required this.destinationName,
    this.travelStyle = '',
    this.budget = 0,
    this.travellers = 1,
    this.durationDays = 1,
    Map<String, dynamic>? preferences,
  }) : preferences = preferences ?? const <String, dynamic>{};

  final String destinationName;
  final String travelStyle;
  final double budget;
  final int travellers;
  final int durationDays;
  final Map<String, dynamic> preferences;

  DestinationRequest copyWith({
    String? destinationName,
    String? travelStyle,
    double? budget,
    int? travellers,
    int? durationDays,
    Map<String, dynamic>? preferences,
  }) {
    return DestinationRequest(
      destinationName: destinationName ?? this.destinationName,
      travelStyle: travelStyle ?? this.travelStyle,
      budget: budget ?? this.budget,
      travellers: travellers ?? this.travellers,
      durationDays: durationDays ?? this.durationDays,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'destinationName': destinationName,
      'travelStyle': travelStyle,
      'budget': budget,
      'travellers': travellers,
      'durationDays': durationDays,
      'preferences': Map<String, dynamic>.from(preferences),
    };
  }

  factory DestinationRequest.fromMap(Map<String, dynamic> map) {
    return DestinationRequest(
      destinationName: map['destinationName']?.toString() ?? '',
      travelStyle: map['travelStyle']?.toString() ?? '',
      budget: (map['budget'] as num?)?.toDouble() ?? 0,
      travellers: (map['travellers'] as num?)?.toInt() ?? 1,
      durationDays: (map['durationDays'] as num?)?.toInt() ?? 1,
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
