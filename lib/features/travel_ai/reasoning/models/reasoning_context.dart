class ReasoningContext {
  const ReasoningContext({
    required this.destination,
    required this.travelStyle,
    required this.budget,
    required this.durationDays,
    required this.travellers,
    Map<String, dynamic>? preferences,
    this.memorySummary = '',
    this.recommendationSummary = '',
    Map<String, dynamic>? metadata,
  }) : preferences = preferences ?? const <String, dynamic>{},
       metadata = metadata ?? const <String, dynamic>{};

  final String destination;
  final String travelStyle;
  final double budget;
  final int durationDays;
  final int travellers;
  final Map<String, dynamic> preferences;
  final String memorySummary;
  final String recommendationSummary;
  final Map<String, dynamic> metadata;

  ReasoningContext copyWith({
    String? destination,
    String? travelStyle,
    double? budget,
    int? durationDays,
    int? travellers,
    Map<String, dynamic>? preferences,
    String? memorySummary,
    String? recommendationSummary,
    Map<String, dynamic>? metadata,
  }) {
    return ReasoningContext(
      destination: destination ?? this.destination,
      travelStyle: travelStyle ?? this.travelStyle,
      budget: budget ?? this.budget,
      durationDays: durationDays ?? this.durationDays,
      travellers: travellers ?? this.travellers,
      preferences: preferences ?? this.preferences,
      memorySummary: memorySummary ?? this.memorySummary,
      recommendationSummary:
          recommendationSummary ?? this.recommendationSummary,
      metadata: metadata ?? this.metadata,
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
      'memorySummary': memorySummary,
      'recommendationSummary': recommendationSummary,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ReasoningContext.fromMap(Map<String, dynamic> map) {
    return ReasoningContext(
      destination: map['destination']?.toString() ?? '',
      travelStyle: map['travelStyle']?.toString() ?? '',
      budget: (map['budget'] as num?)?.toDouble() ?? 0,
      durationDays: (map['durationDays'] as num?)?.toInt() ?? 1,
      travellers: (map['travellers'] as num?)?.toInt() ?? 1,
      preferences: _normalizeMap(map['preferences']),
      memorySummary: map['memorySummary']?.toString() ?? '',
      recommendationSummary: map['recommendationSummary']?.toString() ?? '',
      metadata: _normalizeMap(map['metadata']),
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
