import 'package:flutter/foundation.dart';
import '../models/ai_activity.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Response Model
/// ---------------------------------------------------------------
/// Standard response model for all AI providers.
/// Supported:
/// - OpenAI
/// - Gemini
/// - Claude
/// - Future AI Engines
/// ===============================================================

@immutable
class AIResponse {
  const AIResponse({
    required this.success,
    required this.message,
    this.data,
    this.model,
    this.tokens = 0,
    this.processingTime = Duration.zero,
    this.createdAt,
  });

  /// Indicates whether the AI request succeeded.
  final bool success;

  /// AI response message.
  final String message;

  /// Optional structured data returned by AI.
  final Map<String, dynamic>? data;

  /// AI model used.
  final String? model;

  /// Token usage.
  final int tokens;

  /// Processing time.
  final Duration processingTime;

  /// Timestamp.
  final DateTime? createdAt;

  /// Empty response.
  factory AIResponse.empty() {
    return AIResponse(success: false, message: '', createdAt: DateTime.now());
  }

  /// Success response.
  factory AIResponse.success({
    required String message,
    Map<String, dynamic>? data,
    String? model,
    int tokens = 0,
    Duration processingTime = Duration.zero,
  }) {
    return AIResponse(
      success: true,
      message: message,
      data: data,
      model: model,
      tokens: tokens,
      processingTime: processingTime,
      createdAt: DateTime.now(),
    );
  }

  /// Error response.
  factory AIResponse.error(String message) {
    return AIResponse(
      success: false,
      message: message,
      createdAt: DateTime.now(),
    );
  }

  /// JSON Serialization.
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'model': model,
      'tokens': tokens,
      'processingTime': processingTime.inMilliseconds,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// JSON Deserialization.
  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      model: json['model'],
      tokens: json['tokens'] ?? 0,
      processingTime: Duration(milliseconds: json['processingTime'] ?? 0),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  /// Clone object.
  AIResponse copyWith({
    bool? success,
    String? message,
    Map<String, dynamic>? data,
    String? model,
    int? tokens,
    Duration? processingTime,
    DateTime? createdAt,
  }) {
    return AIResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      model: model ?? this.model,
      tokens: tokens ?? this.tokens,
      processingTime: processingTime ?? this.processingTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return '''
AIResponse(
  success: $success,
  message: $message,
  model: $model,
  tokens: $tokens,
)
''';
  }
}
