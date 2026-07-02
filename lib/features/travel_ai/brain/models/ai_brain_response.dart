import 'dart:convert';

class AIBrainResponse {
  const AIBrainResponse({
    this.recommendationSummary = '',
    this.travelPlanSummary = '',
    this.reasoningSummary = '',
    this.explanationSummary = '',
    this.confidence = 0,
    required this.generatedAt,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String recommendationSummary;
  final String travelPlanSummary;
  final String reasoningSummary;
  final String explanationSummary;
  final double confidence;
  final DateTime generatedAt;
  final Map<String, dynamic> metadata;

  AIBrainResponse copyWith({
    String? recommendationSummary,
    String? travelPlanSummary,
    String? reasoningSummary,
    String? explanationSummary,
    double? confidence,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return AIBrainResponse(
      recommendationSummary:
          recommendationSummary ?? this.recommendationSummary,
      travelPlanSummary: travelPlanSummary ?? this.travelPlanSummary,
      reasoningSummary: reasoningSummary ?? this.reasoningSummary,
      explanationSummary: explanationSummary ?? this.explanationSummary,
      confidence: _confidenceOrDefault(confidence, this.confidence),
      generatedAt: generatedAt ?? this.generatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recommendationSummary': recommendationSummary,
      'travelPlanSummary': travelPlanSummary,
      'reasoningSummary': reasoningSummary,
      'explanationSummary': explanationSummary,
      'confidence': confidence,
      'generatedAt': generatedAt.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory AIBrainResponse.fromMap(Map<String, dynamic> map) {
    return AIBrainResponse(
      recommendationSummary: map['recommendationSummary']?.toString() ?? '',
      travelPlanSummary: map['travelPlanSummary']?.toString() ?? '',
      reasoningSummary: map['reasoningSummary']?.toString() ?? '',
      explanationSummary: map['explanationSummary']?.toString() ?? '',
      confidence: _confidenceOrDefault(map['confidence'], 0),
      generatedAt: _dateTimeOrDefault(map['generatedAt'], DateTime.now()),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory AIBrainResponse.fromJson(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        return AIBrainResponse.fromMap(decoded);
      }
      if (decoded is Map) {
        return AIBrainResponse.fromMap(_normalizeMap(decoded));
      }
    } on FormatException {
      return AIBrainResponse(generatedAt: DateTime.now());
    }
    return AIBrainResponse(generatedAt: DateTime.now());
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

  static double _confidenceOrDefault(dynamic value, double fallback) {
    final parsedValue = _tryParseDouble(value);
    if (parsedValue == null) {
      return fallback.clamp(0.0, 1.0);
    }
    return parsedValue.clamp(0.0, 1.0);
  }

  static DateTime _dateTimeOrDefault(dynamic value, DateTime fallback) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value.trim()) ?? fallback;
    }
    return fallback;
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
