import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/ai_card_engine.dart';
import '../services/ai_card_service.dart';

final Provider<AICardService> aiCardServiceProvider = Provider<AICardService>((
  ref,
) {
  return const AICardService();
});

final Provider<AICardEngine> aiCardEngineProvider = Provider<AICardEngine>((
  ref,
) {
  final service = ref.watch(aiCardServiceProvider);
  return AICardEngine(service: service);
});
