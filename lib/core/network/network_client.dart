import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../constants/api_constants.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// Network Client
/// ---------------------------------------------------------------
/// Central HTTP Client
///
/// Used by:
/// - OpenAI
/// - Gemini
/// - Supabase
/// - Future REST APIs
/// ===============================================================

class NetworkClient {
  NetworkClient._();

  static final http.Client _client = http.Client();

  //--------------------------------------------------------------
  // GET
  //--------------------------------------------------------------

  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    AppConfig.log('GET => $url');

    final response = await _client
        .get(Uri.parse(url), headers: headers ?? _defaultHeaders)
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  //--------------------------------------------------------------
  // POST
  //--------------------------------------------------------------

  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    AppConfig.log('POST => $url');

    final response = await _client
        .post(
          Uri.parse(url),
          headers: headers ?? _defaultHeaders,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  //--------------------------------------------------------------
  // PUT
  //--------------------------------------------------------------

  static Future<Map<String, dynamic>> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    AppConfig.log('PUT => $url');

    final response = await _client
        .put(
          Uri.parse(url),
          headers: headers ?? _defaultHeaders,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  //--------------------------------------------------------------
  // DELETE
  //--------------------------------------------------------------

  static Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    AppConfig.log('DELETE => $url');

    final response = await _client
        .delete(Uri.parse(url), headers: headers ?? _defaultHeaders)
        .timeout(ApiConstants.connectTimeout);

    return _handleResponse(response);
  }

  //--------------------------------------------------------------
  // Default Headers
  //--------------------------------------------------------------

  static Map<String, String> get _defaultHeaders => {
    'Content-Type': ApiConstants.jsonContentType,
    'Accept': ApiConstants.jsonContentType,
  };

  //--------------------------------------------------------------
  // Response Handler
  //--------------------------------------------------------------

  static Map<String, dynamic> _handleResponse(http.Response response) {
    AppConfig.log('Status Code: ${response.statusCode}');

    if (response.body.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {'data': decoded};
  }

  //--------------------------------------------------------------
  // Dispose
  //--------------------------------------------------------------

  static void dispose() {
    _client.close();
  }
}
