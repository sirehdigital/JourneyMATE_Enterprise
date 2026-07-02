import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/explanation_engine.dart';
import '../services/explanation_service.dart';

final Provider<ExplanationService> explanationServiceProvider =
    Provider<ExplanationService>((_) => const ExplanationService());

final Provider<ExplanationEngine> explanationEngineProvider =
    Provider<ExplanationEngine>(
      (ref) =>
          ExplanationEngine(service: ref.watch(explanationServiceProvider)),
    );
