import 'render_format.dart';

/// Immutable rendered response returned by the JourneyMATE response renderer.
class RenderedResponse {
  /// Creates a new immutable [RenderedResponse].
  const RenderedResponse({
    required this.format,
    required this.content,
    this.metadata = const {},
  });

  /// Format of the rendered response.
  final RenderFormat format;

  /// Rendered output content.
  final String content;

  /// Additional structured metadata.
  final Map<String, dynamic> metadata;

  /// Returns a copy of this response with the provided overrides.
  RenderedResponse copyWith({
    RenderFormat? format,
    String? content,
    Map<String, dynamic>? metadata,
  }) {
    return RenderedResponse(
      format: format ?? this.format,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts this rendered response to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'format': format.name,
      'content': content,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  /// Creates a [RenderedResponse] from a map representation.
  factory RenderedResponse.fromMap(Map<String, dynamic> map) {
    return RenderedResponse(
      format: RenderFormat.values.firstWhere(
        (value) => value.name == map['format'] as String,
        orElse: () => RenderFormat.plainText,
      ),
      content: map['content'] as String,
      metadata: Map<String, dynamic>.from(
        map['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
