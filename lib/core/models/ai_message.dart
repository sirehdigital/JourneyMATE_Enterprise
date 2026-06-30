import 'package:flutter/foundation.dart';

@immutable
class AIMessage {
  const AIMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  final String message;
  final bool isUser;
  final DateTime timestamp;

  AIMessage copyWith({String? message, bool? isUser, DateTime? timestamp}) {
    return AIMessage(
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
