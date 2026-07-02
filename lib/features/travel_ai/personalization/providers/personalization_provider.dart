import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/personalization_engine.dart';
import '../services/personalization_service.dart';

final Provider<PersonalizationService> personalizationServiceProvider =
    Provider<PersonalizationService>((_) => const PersonalizationService());

final Provider<PersonalizationEngine> personalizationEngineProvider =
    Provider<PersonalizationEngine>(
      (ref) => PersonalizationEngine(
        service: ref.watch(personalizationServiceProvider),
      ),
    );
