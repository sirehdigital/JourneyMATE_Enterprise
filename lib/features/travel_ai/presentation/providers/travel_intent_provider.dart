import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/travel_intent.dart';
import '../../domain/enums/travel_intent_type.dart';
import '../../data/services/travel_intent_service.dart';

class TravelIntentState {
  const TravelIntentState({
    required this.intent,
    this.isLoading = false,
    this.errorMessage,
  });

  final TravelIntent intent;
  final bool isLoading;
  final String? errorMessage;

  TravelIntentState copyWith({
    TravelIntent? intent,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TravelIntentState(
      intent: intent ?? this.intent,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TravelIntentController extends StateNotifier<TravelIntentState> {
  TravelIntentController()
    : super(
        TravelIntentState(
          intent: TravelIntent(
            type: TravelIntentType.unknown,
            destination: null,
            origin: null,
            durationDays: null,
            budget: null,
            travellers: null,
            rawPrompt: '',
          ),
        ),
      );

  Future<void> detectIntent(String prompt) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final intent = TravelIntentService.detectIntent(prompt);
      state = state.copyWith(intent: intent, isLoading: false);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to detect travel intent.',
      );
    }
  }
}

final travelIntentProvider =
    StateNotifierProvider<TravelIntentController, TravelIntentState>(
      (ref) => TravelIntentController(),
    );
