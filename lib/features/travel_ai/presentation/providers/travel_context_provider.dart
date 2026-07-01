import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/travel_context.dart';
import '../../data/services/travel_context_service.dart';

class TravelContextController extends StateNotifier<TravelContext?> {
  TravelContextController() : super(null);

  Future<void> buildContext(String prompt) async {
    try {
      final context = TravelContextService.buildContext(prompt);
      state = context;
    } catch (_) {
      state = null;
    }
  }
}

final travelContextProvider =
    StateNotifierProvider<TravelContextController, TravelContext?>(
      (ref) => TravelContextController(),
    );
