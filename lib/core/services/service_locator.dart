/// ===============================================================
/// JourneyMATE Enterprise
/// Service Locator
/// ---------------------------------------------------------------
/// Central access point for repositories and services.
///
/// Future:
/// - get_it
/// - Dependency Injection
/// ===============================================================

import '../repositories/ai_repository.dart';

class ServiceLocator {
  ServiceLocator._();

  static final AIRepository aiRepository = AIRepository();
}
