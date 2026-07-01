import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/prompt_context.dart';
import '../../domain/entities/travel_context.dart';
import '../../domain/entities/travel_intent.dart';
import '../../data/services/prompt_builder_service.dart';

class PromptBuilderState {
  const PromptBuilderState({this.currentPrompt});

  final PromptContext? currentPrompt;

  PromptBuilderState copyWith({PromptContext? currentPrompt}) {
    return PromptBuilderState(
      currentPrompt: currentPrompt ?? this.currentPrompt,
    );
  }
}

class PromptBuilderController extends StateNotifier<PromptBuilderState> {
  PromptBuilderController() : super(const PromptBuilderState());

  Future<void> generatePrompt(
    TravelIntent intent,
    TravelContext context,
    String userPrompt,
  ) async {
    final promptContext = PromptBuilderService.buildPrompt(
      intent,
      context,
      userPrompt,
    );

    state = state.copyWith(currentPrompt: promptContext);
  }
}

final promptBuilderProvider =
    StateNotifierProvider<PromptBuilderController, PromptBuilderState>(
      (ref) => PromptBuilderController(),
    );
