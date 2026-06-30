import 'package:flutter/foundation.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// App Configuration
/// ---------------------------------------------------------------
/// Central configuration for application environment.
/// Future support:
/// - Development
/// - Staging
/// - Production
/// ===============================================================

class AppConfig {
  AppConfig._();

  //--------------------------------------------------------------
  // Application
  //--------------------------------------------------------------

  static const String appName = 'JourneyMATE Enterprise';

  static const String version = '0.7.0';

  static const bool enableLogging = true;

  //--------------------------------------------------------------
  // Environment
  //--------------------------------------------------------------

  static bool get isDebug => kDebugMode;

  static bool get isRelease => kReleaseMode;

  static bool get isProfile => kProfileMode;

  //--------------------------------------------------------------
  // AI
  //--------------------------------------------------------------

  static const bool enableAI = true;

  static const bool enableVoiceAI = true;

  static const bool enableAutonomousMode = false;

  //--------------------------------------------------------------
  // Backend
  //--------------------------------------------------------------

  static const bool enableSupabase = false;

  static const bool enableOfflineMode = true;

  //--------------------------------------------------------------
  // Feature Flags
  //--------------------------------------------------------------

  static const bool enableWallet = true;

  static const bool enableMarketplace = true;

  static const bool enableCommunity = true;

  static const bool enableAnalytics = true;

  //--------------------------------------------------------------
  // Timeouts
  //--------------------------------------------------------------

  static const Duration apiTimeout = Duration(seconds: 30);

  static const Duration aiTimeout = Duration(seconds: 60);

  //--------------------------------------------------------------
  // Logging
  //--------------------------------------------------------------

  static void log(Object message) {
    if (enableLogging && kDebugMode) {
      debugPrint('[JourneyMATE] $message');
    }
  }
}
