import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Status Provider
/// ===============================================================

enum AIStatus { ready, thinking, planning, completed, error }

class AIState {
  const AIState({
    this.status = AIStatus.ready,
    this.message = 'AI Ready',
    this.loading = false,
    this.currentModel = 'Gemini 2.5 Pro',
  });

  final AIStatus status;

  final String message;

  final bool loading;

  final String currentModel;

  AIState copyWith({
    AIStatus? status,
    String? message,
    bool? loading,
    String? currentModel,
  }) {
    return AIState(
      status: status ?? this.status,
      message: message ?? this.message,
      loading: loading ?? this.loading,
      currentModel: currentModel ?? this.currentModel,
    );
  }
}

class AIController extends StateNotifier<AIState> {
  AIController() : super(const AIState());

  void setReady() {
    state = state.copyWith(
      status: AIStatus.ready,
      message: 'AI Ready',
      loading: false,
    );
  }

  void setThinking() {
    state = state.copyWith(
      status: AIStatus.thinking,
      message: 'AI is thinking...',
      loading: true,
    );
  }

  void setPlanning() {
    state = state.copyWith(
      status: AIStatus.planning,
      message: 'Planning your journey...',
      loading: true,
    );
  }

  void setCompleted() {
    state = state.copyWith(
      status: AIStatus.completed,
      message: 'Task Completed',
      loading: false,
    );
  }

  void setError() {
    state = state.copyWith(
      status: AIStatus.error,
      message: 'AI Error',
      loading: false,
    );
  }
}

final aiProvider = StateNotifierProvider<AIController, AIState>(
  (ref) => AIController(),
);
