import 'response_section.dart';

/// Immutable composed response returned by the JourneyMATE response composer.
class ComposedResponse {
  /// Creates a new immutable [ComposedResponse].
  const ComposedResponse({
    required this.title,
    required this.summary,
    required this.sections,
    required this.generatedAt,
    this.metadata = const {},
  });

  /// Primary title for the composed response.
  final String title;

  /// Summary content for the composed response.
  final String summary;

  /// Ordered sections included in the response.
  final List<ResponseSection> sections;

  /// Timestamp when the response was generated.
  final DateTime generatedAt;

  /// Additional structured metadata for the composed response.
  final Map<String, dynamic> metadata;

  /// Returns a copy of this response with the provided overrides.
  ComposedResponse copyWith({
    String? title,
    String? summary,
    List<ResponseSection>? sections,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ComposedResponse(
      title: title ?? this.title,
      summary: summary ?? this.summary,
      sections: sections ?? this.sections,
      generatedAt: generatedAt ?? this.generatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts this response to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'sections': sections.map((section) => section.toMap()).toList(),
      'generatedAt': generatedAt.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  /// Creates a [ComposedResponse] from a map representation.
  factory ComposedResponse.fromMap(Map<String, dynamic> map) {
    return ComposedResponse(
      title: map['title'] as String,
      summary: map['summary'] as String,
      sections: List<Map<String, dynamic>>.from(
        (map['sections'] as List<dynamic>).cast<Map<String, dynamic>>(),
      ).map(ResponseSection.fromMap).toList(),
      generatedAt: DateTime.parse(map['generatedAt'] as String),
      metadata: Map<String, dynamic>.from(
        map['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
