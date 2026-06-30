import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ai_response.dart';
import '../repositories/ai_repository.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Provider
/// ===============================================================

enum AIStatus { ready, thinking, planning, completed, error }

class AIState {
  const AIState({
    this.status = AIStatus.ready,
    this.message = 'AI Ready',
    this.loading = false,
    this.currentModel = 'Gemini 2.5 Pro',
    this.response,
  });

  final AIStatus status;
  final String message;
  final bool loading;
  final String currentModel;
  final AIResponse? response;

  AIState copyWith({
    AIStatus? status,
    String? message,
    bool? loading,
    String? currentModel,
    AIResponse? response,
  }) {
    return AIState(
      status: status ?? this.status,
      message: message ?? this.message,
      loading: loading ?? this.loading,
      currentModel: currentModel ?? this.currentModel,
      response: response ?? this.response,
    );
  }
}

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return AIRepository();
});

class AIController extends StateNotifier<AIState> {
  AIController(this._repository) : super(const AIState());

  final AIRepository _repository;

  //--------------------------------------------------------------
  // Ask AI
  //--------------------------------------------------------------

  Future<void> askAI(String prompt) async {
    state = state.copyWith(
      status: AIStatus.thinking,
      loading: true,
      message: 'AI is thinking...',
    );

    try {
      final result = await _repository.askAI(prompt);

      state = state.copyWith(
        status: AIStatus.completed,
        loading: false,
        message: result.message,
        response: result,
      );
    } catch (_) {
      state = state.copyWith(
        status: AIStatus.error,
        loading: false,
        message: 'Unable to contact AI.',
      );
    }
  }

  //--------------------------------------------------------------
  // Manual Status
  //--------------------------------------------------------------

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
      message: 'Completed',
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
  (ref) => AIController(ref.watch(aiRepositoryProvider)),
);
