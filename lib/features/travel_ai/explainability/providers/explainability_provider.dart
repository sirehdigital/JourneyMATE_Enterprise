import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/explainability_engine.dart';
import '../services/explainability_service.dart';

final Provider<ExplainabilityService> explainabilityServiceProvider =
    Provider<ExplainabilityService>(
  (_) => const ExplainabilityService(),
);

final Provider<ExplainabilityEngine> explainabilityEngineProvider =
    Provider<ExplainabilityEngine>(
  (ref) => ExplainabilityEngine(service: ref.watch(explainabilityServiceProvider)),
);
