/// Immutable section representation for a composed JourneyMATE response.
class ResponseSection {
  /// Creates a new immutable [ResponseSection].
  const ResponseSection({
    required this.title,
    required this.icon,
    required this.priority,
    required this.content,
    this.metadata = const {},
  });

  /// Section title, such as "✈ Flights" or "🏨 Hotels".
  final String title;

  /// Icon that represents the section.
  final String icon;

  /// Priority used for ordering sections in the composed response.
  final int priority;

  /// Main textual content for the section.
  final String content;

  /// Optional structured metadata for the section.
  final Map<String, dynamic> metadata;

  /// Returns a copy of this section with the provided overrides.
  ResponseSection copyWith({
    String? title,
    String? icon,
    int? priority,
    String? content,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseSection(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      priority: priority ?? this.priority,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts this section to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
      'priority': priority,
      'content': content,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  /// Creates a [ResponseSection] from a map representation.
  factory ResponseSection.fromMap(Map<String, dynamic> map) {
    return ResponseSection(
      title: map['title'] as String,
      icon: map['icon'] as String,
      priority: map['priority'] as int,
      content: map['content'] as String,
      metadata: Map<String, dynamic>.from(
        map['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
