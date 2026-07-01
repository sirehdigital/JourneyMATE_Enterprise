import 'dart:convert';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:journeymate_enterprise/core/services/openai_service.dart';

void main() {
  group('OpenAIService._extractStreamDelta', () {
    test('handles response.output_text.delta', () {
      final payload = jsonEncode({
        'type': 'response.output_text.delta',
        'response': {
          'output_text': {'delta': 'Hello'},
        },
      });

      final delta = OpenAIService.extractStreamDeltaForTesting(
        payload,
        'response.output_text.delta',
      );

      expect(delta, 'Hello');
    });

    test('handles response.output_text.done', () {
      final payload = jsonEncode({
        'type': 'response.output_text.done',
        'response': {
          'output_text': {'delta': 'Done token'},
        },
      });

      final delta = OpenAIService.extractStreamDeltaForTesting(
        payload,
        'response.output_text.done',
      );

      expect(delta, 'Done token');
    });

    test('handles response.completed', () {
      final payload = jsonEncode({
        'type': 'response.completed',
        'response': {
          'output_text': {'delta': 'Completed text'},
        },
      });

      final delta = OpenAIService.extractStreamDeltaForTesting(
        payload,
        'response.completed',
      );

      expect(delta, 'Completed text');
    });

    test('returns empty string for response.error', () {
      final payload = jsonEncode({
        'type': 'response.error',
        'error': {'message': 'Bad request'},
      });

      final delta = OpenAIService.extractStreamDeltaForTesting(
        payload,
        'response.error',
      );

      expect(delta, isEmpty);
    });

    test('throws FormatException for invalid JSON', () {
      expect(
        () => OpenAIService.extractStreamDeltaForTesting('not-json', null),
        throwsFormatException,
      );
    });

    test('returns empty string for unknown event payload', () {
      final payload = jsonEncode({'unexpected': 123});
      final delta = OpenAIService.extractStreamDeltaForTesting(payload, null);
      expect(delta, isEmpty);
    });

    test('returns empty string for empty payload object', () {
      final delta = OpenAIService.extractStreamDeltaForTesting('{}', null);
      expect(delta, isEmpty);
    });
  });

  group('OpenAIService SSE parser', () {
    test('parses LF-separated stream event', () async {
      final sse =
          'data: {"type":"response.output_text.delta","response":{"output_text":{"delta":"hi"}}}\n\n';
      final stream = OpenAIService.parseStreamingResponseForTesting(
        Stream.value(utf8.encode(sse)),
      );

      expect(await stream.toList(), ['hi']);
    });

    test('parses CRLF-separated stream event', () async {
      final sse =
          'data: {"type":"response.output_text.delta","response":{"output_text":{"delta":"crlf"}}}\r\n\r\n';
      final stream = OpenAIService.parseStreamingResponseForTesting(
        Stream.value(utf8.encode(sse)),
      );

      expect(await stream.toList(), ['crlf']);
    });

    test('parses multiple SSE data events', () async {
      final sse =
          '''data: {"type":"response.output_text.delta","response":{"output_text":{"delta":"a"}}}

data: {"type":"response.output_text.delta","response":{"output_text":{"delta":"b"}}}

''';
      final stream = OpenAIService.parseStreamingResponseForTesting(
        Stream.value(utf8.encode(sse)),
      );

      expect(await stream.toList(), ['a', 'b']);
    });

    test('stops parsing on [DONE] event', () async {
      final sse = 'data: [DONE]\n\n';
      final stream = OpenAIService.parseStreamingResponseForTesting(
        Stream.value(utf8.encode(sse)),
      );

      expect(await stream.toList(), isEmpty);
    });

    test('parses partial chunks across source boundaries', () async {
      final firstChunk = utf8.encode(
        'data: {"type":"response.output_text.delta","response":{"output_text":{"delta":"part',
      );
      final secondChunk = utf8.encode('ial"}}}\n\n');
      final stream = OpenAIService.parseStreamingResponseForTesting(
        Stream.fromIterable([firstChunk, secondChunk]),
      );

      expect(await stream.toList(), ['partial']);
    });
  });
}
