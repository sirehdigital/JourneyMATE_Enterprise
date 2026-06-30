import '../core/config/app_config.dart';
import '../core/services/ai_service.dart';
import '../core/storage/local_storage.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// App Initializer
/// ---------------------------------------------------------------
/// Responsible for initializing all application services.
///
/// Initialization Order:
/// 1. Local Storage
/// 2. AI Service
/// 3. Future Services
/// ===============================================================

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    AppConfig.log('Initializing JourneyMATE...');

    //------------------------------------------------------------
    // Local Storage
    //------------------------------------------------------------
    await LocalStorage.initialize();

    //------------------------------------------------------------
    // AI Service
    //------------------------------------------------------------
    await AIService.initialize();

    //------------------------------------------------------------
    // Future Initializers
    //------------------------------------------------------------
    // await SupabaseService.initialize(...);
    // await NotificationService.initialize();
    // await AnalyticsService.initialize();

    AppConfig.log('JourneyMATE Ready');
  }
}
