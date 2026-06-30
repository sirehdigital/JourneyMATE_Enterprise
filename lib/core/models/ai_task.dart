import 'package:flutter/material.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Task Model
/// ===============================================================

enum AITaskStatus { pending, running, completed, failed }

@immutable
class AITask {
  const AITask({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.status,
    required this.icon,
    required this.createdAt,
  });

  final String id;

  final String title;

  final String description;

  final double progress;

  final AITaskStatus status;

  final IconData icon;

  final DateTime createdAt;

  AITask copyWith({
    String? id,
    String? title,
    String? description,
    double? progress,
    AITaskStatus? status,
    IconData? icon,
    DateTime? createdAt,
  }) {
    return AITask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
