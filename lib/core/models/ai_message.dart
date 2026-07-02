import 'package:flutter/foundation.dart';

@immutable
class AIMessage {
  const AIMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.metadata = const <String, dynamic>{},
  });

  final String message;
  final bool isUser;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  AIMessage copyWith({
    String? message,
    bool? isUser,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return AIMessage(
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }
}
