import 'dart:convert';

import '../composer/composed_response.dart';
import '../composer/response_section.dart';
import 'render_format.dart';
import 'rendered_response.dart';

/// Converts a [ComposedResponse] into different structured output formats.
class ResponseRenderer {
  /// Renders the provided composed response in the requested format.
  RenderedResponse render({
    required ComposedResponse response,
    required RenderFormat format,
  }) {
    switch (format) {
      case RenderFormat.markdown:
        return RenderedResponse(
          format: format,
          content: _renderMarkdown(response),
          metadata: _renderMetadata(response),
        );
      case RenderFormat.plainText:
        return RenderedResponse(
          format: format,
          content: _renderPlainText(response),
          metadata: _renderMetadata(response),
        );
      case RenderFormat.json:
        return RenderedResponse(
          format: format,
          content: _renderJson(response),
          metadata: _renderMetadata(response),
        );
      case RenderFormat.card:
        return RenderedResponse(
          format: format,
          content: _renderCardPayload(response),
          metadata: _renderMetadata(response),
        );
      case RenderFormat.pdf:
      case RenderFormat.voice:
      case RenderFormat.html:
        return RenderedResponse(
          format: format,
          content: _renderPlaceholder(response, format),
          metadata: _renderMetadata(response),
        );
    }
  }

  String _renderMarkdown(ComposedResponse response) {
    final buffer = StringBuffer();
    buffer.writeln('# ${response.title}');
    buffer.writeln();
    buffer.writeln(response.summary);
    buffer.writeln();

    for (var index = 0; index < response.sections.length; index++) {
      final section = response.sections[index];
      buffer.writeln('--------------------------------');
      buffer.writeln();
      buffer.writeln('## ${section.icon} ${section.title}');
      buffer.writeln();
      buffer.writeln(section.content);
      if (section.metadata.isNotEmpty) {
        buffer.writeln();
        buffer.writeln('**Metadata**');
        buffer.writeln();
        section.metadata.forEach((key, value) {
          buffer.writeln('- **$key**: $value');
        });
      }
      if (index < response.sections.length - 1) {
        buffer.writeln();
      }
    }

    return buffer.toString().trim();
  }

  String _renderPlainText(ComposedResponse response) {
    final buffer = StringBuffer();
    buffer.writeln(response.title);
    buffer.writeln();
    buffer.writeln(response.summary);
    buffer.writeln();

    for (final section in response.sections) {
      buffer.writeln(section.title);
      buffer.writeln(section.content);
      buffer.writeln();
    }

    return buffer.toString().trim();
  }

  String _renderJson(ComposedResponse response) {
    return json.encode(response.toMap());
  }

  String _renderCardPayload(ComposedResponse response) {
    final cards = response.sections.map((section) {
      return {
        'title': section.title,
        'subtitle': response.summary,
        'icon': section.icon,
        'content': section.content,
        'metadata': section.metadata,
      };
    }).toList();

    return json.encode({'cards': cards});
  }

  String _renderPlaceholder(ComposedResponse response, RenderFormat format) {
    return json.encode({
      'format': format.name,
      'message':
          'Rendering for $format is available through a dedicated extension.',
      'response': response.toMap(),
    });
  }

  Map<String, dynamic> _renderMetadata(ComposedResponse response) {
    return {
      'generatedAt': response.generatedAt.toIso8601String(),
      'sectionCount': response.sections.length,
      'format': response.title,
    };
  }
}
