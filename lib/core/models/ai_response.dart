import 'package:flutter/foundation.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Response Model
/// ===============================================================

@immutable
class AIResponse {
  const AIResponse({
    required this.message,
    this.success = true,
    this.model = 'Gemini 2.5 Pro',
    this.timestamp,
  });

  /// AI reply message
  final String message;

  /// Response status
  final bool success;

  /// AI model name
  final String model;

  /// Response timestamp
  final DateTime? timestamp;

  AIResponse copyWith({
    String? message,
    bool? success,
    String? model,
    DateTime? timestamp,
  }) {
    return AIResponse(
      message: message ?? this.message,
      success: success ?? this.success,
      model: model ?? this.model,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return '''
AIResponse(
  message: $message,
  success: $success,
  model: $model,
  timestamp: $timestamp,
)
''';
  }
}
