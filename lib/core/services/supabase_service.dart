import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// Supabase Service
/// ===============================================================

class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  //--------------------------------------------------------------
  // Initialize
  //--------------------------------------------------------------

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);

    AppConfig.log('Supabase Initialized');
  }

  //--------------------------------------------------------------
  // Auth
  //--------------------------------------------------------------

  static User? get currentUser => client.auth.currentUser;

  static bool get isLoggedIn => currentUser != null;

  //--------------------------------------------------------------
  // Sign Out
  //--------------------------------------------------------------

  static Future<void> signOut() async {
    await client.auth.signOut();
  }
}
