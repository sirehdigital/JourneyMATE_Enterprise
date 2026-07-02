import 'response_section.dart';

class ResponseDocument {
  ResponseDocument({
    required this.title,
    this.summary = '',
    List<ResponseSection>? sections,
    this.footer = '',
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) : sections = List<ResponseSection>.unmodifiable(
         sections ?? const <ResponseSection>[],
       ),
       generatedAt = generatedAt ?? DateTime.now(),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String title;
  final String summary;
  final List<ResponseSection> sections;
  final String footer;
  final DateTime generatedAt;
  final Map<String, dynamic> metadata;

  ResponseDocument copyWith({
    String? title,
    String? summary,
    List<ResponseSection>? sections,
    String? footer,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseDocument(
      title: title ?? this.title,
      summary: summary ?? this.summary,
      sections: sections ?? this.sections,
      footer: footer ?? this.footer,
      generatedAt: generatedAt ?? this.generatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'summary': summary,
      'sections': sections
          .map((section) => section.toMap())
          .toList(growable: false),
      'footer': footer,
      'generatedAt': generatedAt.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ResponseDocument.fromMap(Map<String, dynamic> map) {
    return ResponseDocument(
      title: map['title']?.toString() ?? 'JourneyMATE Response',
      summary: map['summary']?.toString() ?? '',
      sections: _parseSections(map['sections']),
      footer: map['footer']?.toString() ?? '',
      generatedAt:
          DateTime.tryParse(map['generatedAt']?.toString() ?? '') ??
          DateTime.now(),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static List<ResponseSection> _parseSections(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) => ResponseSection.fromMap(
              item.map<String, dynamic>(
                (dynamic key, dynamic entry) =>
                    MapEntry<String, dynamic>(key.toString(), entry),
              ),
            ),
          )
          .toList(growable: false);
    }
    return const <ResponseSection>[];
  }

  static Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic entry) =>
            MapEntry<String, dynamic>(key.toString(), entry),
      );
    }
    return <String, dynamic>{};
  }
}
