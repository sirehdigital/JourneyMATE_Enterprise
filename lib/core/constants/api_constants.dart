/// ===============================================================
/// JourneyMATE Enterprise
/// API Constants
/// ---------------------------------------------------------------
/// Central place for:
/// - API Endpoints
/// - Supabase Tables
/// - Storage Buckets
/// - AI Models
/// ===============================================================

class ApiConstants {
  ApiConstants._();

  //--------------------------------------------------------------
  // API Version
  //--------------------------------------------------------------

  static const String apiVersion = 'v1';

  //--------------------------------------------------------------
  // AI Models
  //--------------------------------------------------------------

  static const String openAIModel = 'gpt-5.5';

  static const String geminiModel = 'gemini-2.5-pro';

  //--------------------------------------------------------------
  // Supabase Tables
  //--------------------------------------------------------------

  static const String usersTable = 'users';

  static const String tripsTable = 'trips';

  static const String itinerariesTable = 'itineraries';

  static const String destinationsTable = 'destinations';

  static const String hotelsTable = 'hotels';

  static const String flightsTable = 'flights';

  static const String walletsTable = 'wallets';

  static const String notificationsTable = 'notifications';

  //--------------------------------------------------------------
  // Storage Buckets
  //--------------------------------------------------------------

  static const String profileBucket = 'profiles';

  static const String destinationBucket = 'destinations';

  static const String documentsBucket = 'documents';

  //--------------------------------------------------------------
  // HTTP Timeout
  //--------------------------------------------------------------

  static const Duration connectTimeout = Duration(seconds: 30);

  static const Duration receiveTimeout = Duration(seconds: 60);

  //--------------------------------------------------------------
  // Headers
  //--------------------------------------------------------------

  static const String jsonContentType = 'application/json';

  static const String authorization = 'Authorization';

  static const String bearer = 'Bearer';

  //--------------------------------------------------------------
  // Future Endpoints
  //--------------------------------------------------------------

  static const String aiChat = '/ai/chat';

  static const String aiPlanner = '/ai/planner';

  static const String aiRecommendation = '/ai/recommendation';

  static const String aiTask = '/ai/task';
}
