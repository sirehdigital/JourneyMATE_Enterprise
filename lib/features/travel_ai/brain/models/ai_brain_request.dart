import 'dart:convert';

class AIBrainRequest {
  const AIBrainRequest({
    this.userPrompt = '',
    this.destination = '',
    this.durationDays = 1,
    this.budget = 0,
    this.travellers = 1,
    this.travelStyle = '',
    this.transportMode = '',
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? metadata,
  }) : preferences = preferences ?? const <String, dynamic>{},
       metadata = metadata ?? const <String, dynamic>{};

  final String userPrompt;
  final String destination;
  final int durationDays;
  final double budget;
  final int travellers;
  final String travelStyle;
  final String transportMode;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> metadata;

  AIBrainRequest copyWith({
    String? userPrompt,
    String? destination,
    int? durationDays,
    double? budget,
    int? travellers,
    String? travelStyle,
    String? transportMode,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? metadata,
  }) {
    return AIBrainRequest(
      userPrompt: userPrompt ?? this.userPrompt,
      destination: destination ?? this.destination,
      durationDays: _positiveIntOrDefault(
        durationDays,
        this.durationDays,
      ),
      budget: _nonNegativeDoubleOrDefault(budget, this.budget),
      travellers: _positiveIntOrDefault(travellers, this.travellers),
      travelStyle: travelStyle ?? this.travelStyle,
      transportMode: transportMode ?? this.transportMode,
      preferences: preferences ?? this.preferences,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userPrompt': userPrompt,
      'destination': destination,
      'durationDays': durationDays,
      'budget': budget,
      'travellers': travellers,
      'travelStyle': travelStyle,
      'transportMode': transportMode,
      'preferences': Map<String, dynamic>.from(preferences),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory AIBrainRequest.fromMap(Map<String, dynamic> map) {
    return AIBrainRequest(
      userPrompt: map['userPrompt']?.toString() ?? '',
      destination: map['destination']?.toString() ?? '',
      durationDays: _positiveIntOrDefault(map['durationDays'], 1),
      budget: _nonNegativeDoubleOrDefault(map['budget'], 0),
      travellers: _positiveIntOrDefault(map['travellers'], 1),
      travelStyle: map['travelStyle']?.toString() ?? '',
      transportMode: map['transportMode']?.toString() ?? '',
      preferences: _normalizeMap(map['preferences']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory AIBrainRequest.fromJson(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        return AIBrainRequest.fromMap(decoded);
      }
      if (decoded is Map) {
        return AIBrainRequest.fromMap(_normalizeMap(decoded));
      }
    } on FormatException {
      return const AIBrainRequest();
    }
    return const AIBrainRequest();
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

  static int _positiveIntOrDefault(dynamic value, int fallback) {
    final parsedValue = _tryParseInt(value);
    if (parsedValue == null || parsedValue <= 0) {
      return fallback > 0 ? fallback : 1;
    }
    return parsedValue;
  }

  static double _nonNegativeDoubleOrDefault(dynamic value, double fallback) {
    final parsedValue = _tryParseDouble(value);
    if (parsedValue == null || parsedValue < 0) {
      return fallback >= 0 ? fallback : 0;
    }
    return parsedValue;
  }

  static int? _tryParseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  static double? _tryParseDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }
}
