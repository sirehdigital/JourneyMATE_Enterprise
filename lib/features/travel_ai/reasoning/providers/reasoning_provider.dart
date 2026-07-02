import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/reasoning_engine.dart';
import '../services/reasoning_service.dart';

final reasoningServiceProvider = Provider<ReasoningService>((ref) {
  return const ReasoningService();
});

final reasoningEngineProvider = Provider<ReasoningEngine>((ref) {
  final service = ref.watch(reasoningServiceProvider);
  return ReasoningEngine(service: service);
});
