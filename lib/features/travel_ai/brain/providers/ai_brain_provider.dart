import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/ai_brain_engine.dart';
import '../models/ai_brain_status.dart';
import '../services/ai_brain_service.dart';

final aiBrainServiceProvider = Provider<AIBrainService>((ref) {
  return AIBrainService();
});

final aiBrainEngineProvider = Provider<AIBrainEngine>((ref) {
  final service = ref.watch(aiBrainServiceProvider);
  return AIBrainEngine(service: service);
});

final aiBrainStatusProvider = Provider<AIBrainStatus>((ref) {
  final engine = ref.watch(aiBrainEngineProvider);
  return engine.getStatus();
});
