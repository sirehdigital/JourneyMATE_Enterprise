import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// Local Storage
/// ---------------------------------------------------------------
/// Wrapper for SharedPreferences.
///
/// Used for:
/// - Authentication
/// - Settings
/// - Offline Cache
/// - User Preferences
/// ===============================================================

class LocalStorage {
  LocalStorage._();

  static SharedPreferences? _preferences;

  //--------------------------------------------------------------
  // Initialize
  //--------------------------------------------------------------

  static Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();

    AppConfig.log('Local Storage Initialized');
  }

  //--------------------------------------------------------------
  // String
  //--------------------------------------------------------------

  static Future<bool> setString(String key, String value) async {
    return await _preferences!.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences!.getString(key);
  }

  //--------------------------------------------------------------
  // Bool
  //--------------------------------------------------------------

  static Future<bool> setBool(String key, bool value) async {
    return await _preferences!.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _preferences?.getBool(key) ?? defaultValue;
  }

  //--------------------------------------------------------------
  // Integer
  //--------------------------------------------------------------

  static Future<bool> setInt(String key, int value) async {
    return await _preferences!.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _preferences?.getInt(key) ?? defaultValue;
  }

  //--------------------------------------------------------------
  // Double
  //--------------------------------------------------------------

  static Future<bool> setDouble(String key, double value) async {
    return await _preferences!.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0}) {
    return _preferences?.getDouble(key) ?? defaultValue;
  }

  //--------------------------------------------------------------
  // Remove
  //--------------------------------------------------------------

  static Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }

  //--------------------------------------------------------------
  // Clear
  //--------------------------------------------------------------

  static Future<bool> clear() async {
    AppConfig.log('Local Storage Cleared');

    return await _preferences!.clear();
  }

  //--------------------------------------------------------------
  // Contains
  //--------------------------------------------------------------

  static bool contains(String key) {
    return _preferences!.containsKey(key);
  }
}
