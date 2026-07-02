import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/ai_response.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// OpenAI Service
/// ===============================================================
///
/// OpenAI Responses API Enterprise Service
///
/// Responsibilities:
/// • Send prompt requests
/// • Stream response tokens progressively
/// • Standardized error handling
/// • Timeout handling
/// • Backward compatible response model
/// ===============================================================

class OpenAIService {
  OpenAIService._();

  static const String _apiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const String _endpoint = 'https://api.openai.com/v1/responses';
  static const String _model = 'gpt-5.5';
  static const Duration _requestTimeout = Duration(seconds: 30);
  static const Set<int> _retryableStatusCodes = {429, 500, 502, 503, 504};

  static bool get isConfigured => _apiKey.isNotEmpty;

  //--------------------------------------------------------------
  // Health Check
  //--------------------------------------------------------------

  static Future<bool> ping() async {
    final response = await sendPrompt('Hello');
    return response.success;
  }

  //--------------------------------------------------------------
  // Public API
  //--------------------------------------------------------------

  /// Sends a prompt to OpenAI Responses API and returns a complete AIResponse.
  static Future<AIResponse> sendPrompt(String prompt) async {
    if (_apiKey.isEmpty) {
      return _buildErrorResponse(
        'OpenAI API Key is not configured. Configure OPENAI_API_KEY before calling the service.',
      );
    }

    final client = http.Client();
    try {
      final request = _buildRequest(prompt, stream: false);
      final streamedResponse = await client
          .send(request)
          .timeout(
            _requestTimeout,
            onTimeout: () {
              throw TimeoutException(
                'OpenAI request exceeded $_requestTimeout.',
              );
            },
          );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != HttpStatus.ok) {
        return _buildErrorResponse(
          _buildHttpErrorMessage(response.statusCode, response.body),
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>?;
      if (json == null) {
        return _buildErrorResponse(
          'OpenAI returned an empty or malformed response.',
        );
      }

      final message = _extractResponseMessage(json);
      return AIResponse(
        message: message.isEmpty ? 'No response from OpenAI.' : message,
        success: true,
        model: _model,
        timestamp: DateTime.now().toUtc(),
      );
    } on TimeoutException catch (exception) {
      return _buildErrorResponse(
        'Request timeout: ${exception.message ?? 'The OpenAI service did not respond in time.'}',
      );
    } on SocketException catch (exception) {
      return _buildErrorResponse(
        'Network error: ${exception.message}. Check your internet connection and retry.',
      );
    } on FormatException catch (exception) {
      return _buildErrorResponse(
        'Response parsing failed: ${exception.message}. The OpenAI payload was not valid JSON.',
      );
    } catch (exception) {
      return _buildErrorResponse(
        'Unexpected OpenAI error: ${exception.toString()}',
      );
    } finally {
      client.close();
    }
  }

  /// Streams prompt output from OpenAI Responses API as text tokens.
  @visibleForTesting
  static Stream<String> Function(String prompt)? streamPromptOverride;

  @visibleForTesting
  static String extractStreamDeltaForTesting(
    String payload,
    String? eventName,
  ) {
    return _extractStreamDelta(payload, eventName);
  }

  @visibleForTesting
  static Stream<String> parseStreamingResponseForTesting(
    Stream<List<int>> source,
  ) {
    return _parseStreamingResponse(source);
  }

  static Stream<String> streamPrompt(String prompt) async* {
    if (streamPromptOverride != null) {
      yield* streamPromptOverride!(prompt);
      return;
    }

    if (_apiKey.isEmpty) {
      throw OpenAIServiceException(
        'OpenAI API Key is not configured. Configure OPENAI_API_KEY before calling the service.',
      );
    }

    final client = http.Client();
    try {
      final request = _buildRequest(prompt, stream: true);
      final streamedResponse = await client
          .send(request)
          .timeout(
            _requestTimeout,
            onTimeout: () {
              throw TimeoutException(
                'OpenAI stream request exceeded $_requestTimeout.',
              );
            },
          );

      if (streamedResponse.statusCode != HttpStatus.ok) {
        final body = await streamedResponse.stream.bytesToString();
        throw OpenAIServiceException(
          _buildHttpErrorMessage(streamedResponse.statusCode, body),
        );
      }

      await for (final token in _parseStreamingResponse(
        streamedResponse.stream,
      )) {
        yield token;
      }
    } on TimeoutException catch (exception) {
      throw OpenAIServiceException(
        'Stream timeout: ${exception.message ?? 'The OpenAI stream did not respond in time.'}',
      );
    } on SocketException catch (exception) {
      throw OpenAIServiceException(
        'Network error while streaming: ${exception.message}. Check your connection and retry.',
      );
    } on FormatException catch (exception) {
      throw OpenAIServiceException(
        'Stream parsing failure: ${exception.message}. The OpenAI stream payload was not valid JSON.',
      );
    } catch (exception) {
      throw OpenAIServiceException(
        'Unexpected OpenAI streaming error: ${exception.toString()}',
      );
    } finally {
      client.close();
    }
  }

  //--------------------------------------------------------------
  // Enterprise prompt helpers
  //--------------------------------------------------------------

  static Future<AIResponse> generateTrip(String destination) {
    return sendPrompt('''
Create a detailed travel itinerary for $destination.

Include:
- Attractions
- Food
- Hotel
- Transportation
- Estimated Budget

Reply in Bahasa Malaysia.
''');
  }

  static Future<AIResponse> recommendHotel(String city) {
    return sendPrompt(
      'Recommend the best hotels in $city with estimated prices. Reply in Bahasa Malaysia.',
    );
  }

  static Future<AIResponse> recommendFlight(String route) {
    return sendPrompt(
      'Recommend the best flight for $route. Reply in Bahasa Malaysia.',
    );
  }

  static Future<AIResponse> generateBudget(String destination) {
    return sendPrompt(
      'Generate a travel budget for $destination. Reply in Bahasa Malaysia.',
    );
  }

  //--------------------------------------------------------------
  // Internal helpers
  //--------------------------------------------------------------

  static http.Request _buildRequest(String prompt, {required bool stream}) {
    final request = http.Request('POST', Uri.parse(_endpoint));
    request.headers.addAll({
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    });

    request.body = jsonEncode({
      'model': _model,
      'input': prompt.trim(),
      if (stream) 'stream': true,
    });

    return request;
  }

  static AIResponse _buildErrorResponse(String message) {
    return AIResponse(
      message: message,
      success: false,
      model: _model,
      timestamp: DateTime.now().toUtc(),
    );
  }

  static String _buildHttpErrorMessage(int statusCode, String body) {
    final details = _extractErrorDetails(body);
    switch (statusCode) {
      case HttpStatus.unauthorized:
        return 'Unauthorized. Verify your OpenAI API key and permissions. $details';
      case HttpStatus.forbidden:
        return 'Forbidden. Your OpenAI account does not have access to this model or operation. $details';
      case HttpStatus.notFound:
        return 'Not found. Model or endpoint is unavailable. Check the model name and API endpoint. $details';
      case HttpStatus.requestTimeout:
        return 'Request timed out. The OpenAI service did not respond in time. $details';
      case HttpStatus.tooManyRequests:
        return 'Quota exceeded or rate limited. Reduce traffic or review OpenAI usage. $details';
      case HttpStatus.internalServerError:
        return 'Internal server error from OpenAI. Retry later. $details';
      case HttpStatus.badGateway:
      case HttpStatus.serviceUnavailable:
      case HttpStatus.gatewayTimeout:
        return 'OpenAI service unavailable. Retry after a short wait. $details';
      default:
        final retryNote = _retryableStatusCodes.contains(statusCode)
            ? ' This error may be retryable.'
            : '';
        return 'OpenAI error ($statusCode). $details$retryNote';
    }
  }

  static String _extractErrorDetails(String body) {
    if (body.trim().isEmpty) {
      return 'No additional details were provided by OpenAI.';
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final error = decoded['error'];
        if (error is Map<String, dynamic> && error['message'] is String) {
          return error['message'] as String;
        }
        if (decoded['message'] is String) {
          return decoded['message'] as String;
        }
      }
    } catch (_) {
      // Fall through to raw body.
    }

    return body.trim();
  }

  static String _extractResponseMessage(Map<String, dynamic> json) {
    final output = json['output'];
    if (output is List && output.isNotEmpty) {
      final buffer = StringBuffer();
      for (final element in output) {
        if (element is Map<String, dynamic>) {
          final content = element['content'];
          if (content is List) {
            for (final item in content) {
              if (item is Map<String, dynamic>) {
                final text = item['text'] ?? item['content'];
                if (text is String && text.isNotEmpty) {
                  buffer.write(text);
                }
              }
            }
          }
        }
      }
      final built = buffer.toString().trim();
      if (built.isNotEmpty) {
        return built;
      }
    }

    final directText = json['output_text'];
    if (directText is String && directText.isNotEmpty) {
      return directText;
    }

    return '';
  }

  static Stream<String> _parseStreamingResponse(
    Stream<List<int>> source,
  ) async* {
    final lines = source
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    final buffer = StringBuffer();

    await for (final rawLine in lines) {
      final line = rawLine;
      if (line.trim().isEmpty) {
        final eventText = buffer.toString();
        buffer.clear();
        final event = _parseSseEvent(eventText);
        if (event == null) {
          continue;
        }

        debugPrint('STREAM EVENT: ${event.eventName ?? 'data'}');

        if (event.isDone) {
          debugPrint('STREAM COMPLETE: [DONE] received');
          break;
        }

        if (event.errorMessage != null) {
          throw OpenAIServiceException(
            'OpenAI stream error: ${event.errorMessage}',
          );
        }

        final delta = _extractStreamDelta(event.payload, event.eventName);
        if (delta.isNotEmpty) {
          debugPrint('STREAM DELTA: $delta');
          yield delta;
        }

        if (event.eventName?.contains('response.output_text.done') == true ||
            event.eventName?.contains('response.completed') == true ||
            (event.decodedJson?['type']?.toString().contains(
                  'response.output_text.done',
                ) ==
                true) ||
            (event.decodedJson?['type']?.toString().contains(
                  'response.completed',
                ) ==
                true)) {
          debugPrint('STREAM COMPLETE: response.done/completed event');
          break;
        }

        continue;
      }

      buffer.writeln(line);
    }

    if (buffer.isNotEmpty) {
      final eventText = buffer.toString();
      final event = _parseSseEvent(eventText);
      if (event != null) {
        if (event.isDone) {
          debugPrint('STREAM COMPLETE: [DONE] received');
        } else if (event.errorMessage != null) {
          throw OpenAIServiceException(
            'OpenAI stream error: ${event.errorMessage}',
          );
        } else {
          final delta = _extractStreamDelta(event.payload, event.eventName);
          if (delta.isNotEmpty) {
            debugPrint('STREAM DELTA: $delta');
            yield delta;
          }
        }
      }
    }
  }

  static _SseEvent? _parseSseEvent(String eventText) {
    final lines = eventText.split(RegExp(r'\r?\n'));
    String? eventName;
    final dataLines = <String>[];

    for (final line in lines) {
      if (line.isEmpty) {
        continue;
      }
      if (line.startsWith('event:')) {
        eventName = line.substring(6).trim();
        continue;
      }
      if (line.startsWith('data:')) {
        final payload = line.substring(5).trim();
        if (payload.isNotEmpty) {
          dataLines.add(payload);
        }
      }
    }

    if (dataLines.isEmpty) {
      return null;
    }

    final payload = dataLines.join('\n');
    if (payload.trim() == '[DONE]') {
      return _SseEvent(eventName: eventName, payload: payload, isDone: true);
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        final errorMessage = _extractStreamError(decoded);
        return _SseEvent(
          eventName: eventName,
          payload: payload,
          decodedJson: decoded,
          errorMessage: errorMessage,
        );
      }
    } catch (_) {
      throw FormatException('Invalid SSE JSON payload: $payload');
    }

    return _SseEvent(eventName: eventName, payload: payload);
  }

  static String? _extractStreamError(Map<String, dynamic> event) {
    final type = event['type']?.toString() ?? '';
    if (type.contains('response.error')) {
      final error = event['error'] ?? event['response']?['error'];
      if (error is Map<String, dynamic> && error['message'] is String) {
        return error['message'] as String;
      }
      if (error is String) {
        return error;
      }
      return 'Unknown OpenAI stream error.';
    }

    if (event.containsKey('error')) {
      final error = event['error'];
      if (error is Map<String, dynamic> && error['message'] is String) {
        return error['message'] as String;
      }
      if (error is String) {
        return error;
      }
    }

    return null;
  }

  static String _extractStreamDelta(String payload, String? eventName) {
    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, dynamic>) {
      return '';
    }

    final type = eventName ?? decoded['type']?.toString() ?? '';

    if (type.contains('response.output_text.delta') ||
        type.contains('response.output_text.done') ||
        type.contains('response.completed')) {
      final token = _extractOutputTextDelta(decoded);
      if (token.isNotEmpty) {
        return token;
      }
    }

    if (decoded.containsKey('delta')) {
      final delta = decoded['delta'];
      if (delta is String && delta.isNotEmpty) {
        return delta;
      }
      if (delta is Map<String, dynamic>) {
        final text = delta['content'] ?? delta['text'];
        if (text is String && text.isNotEmpty) {
          return text;
        }
      }
    }

    final token = _extractNestedText(decoded);
    return token;
  }

  static String _extractNestedText(Map<String, dynamic> decoded) {
    String extract(dynamic node) {
      if (node is String) {
        return node;
      }
      if (node is Map<String, dynamic>) {
        for (final key in ['delta', 'content', 'text', 'output_text']) {
          if (node.containsKey(key)) {
            final value = node[key];
            final extracted = extract(value);
            if (extracted.isNotEmpty) {
              return extracted;
            }
          }
        }
        for (final value in node.values) {
          final extracted = extract(value);
          if (extracted.isNotEmpty) {
            return extracted;
          }
        }
      }
      if (node is List) {
        for (final item in node) {
          final extracted = extract(item);
          if (extracted.isNotEmpty) {
            return extracted;
          }
        }
      }
      return '';
    }

    return extract(decoded);
  }

  static String _extractOutputTextDelta(Map<String, dynamic> decoded) {
    if (decoded.containsKey('response')) {
      final response = decoded['response'];
      if (response is Map<String, dynamic>) {
        final outputText = response['output_text'];
        if (outputText is Map<String, dynamic>) {
          final delta =
              outputText['delta'] ??
              outputText['text'] ??
              outputText['content'];
          if (delta is String && delta.isNotEmpty) {
            return delta;
          }
        }
      }
    }
    return '';
  }
}

class _SseEvent {
  const _SseEvent({
    this.eventName,
    required this.payload,
    this.decodedJson,
    this.errorMessage,
    this.isDone = false,
  });

  final String? eventName;
  final String payload;
  final Map<String, dynamic>? decodedJson;
  final String? errorMessage;
  final bool isDone;
}

class OpenAIServiceException implements Exception {
  const OpenAIServiceException(this.message);

  final String message;

  @override
  String toString() => 'OpenAIServiceException: $message';
}
