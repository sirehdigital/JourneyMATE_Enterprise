import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/response_generator_engine.dart';
import '../services/response_generator_service.dart';

final Provider<ResponseGeneratorService> responseGeneratorServiceProvider =
    Provider<ResponseGeneratorService>((ref) {
      return ResponseGeneratorService();
    });

final Provider<ResponseGeneratorEngine> responseGeneratorEngineProvider =
    Provider<ResponseGeneratorEngine>((ref) {
      final service = ref.watch(responseGeneratorServiceProvider);
      return ResponseGeneratorEngine(service: service);
    });
