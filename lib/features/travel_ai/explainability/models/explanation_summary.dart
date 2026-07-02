import 'explanation_item.dart';

class ExplanationSummary {
  const ExplanationSummary({
    required this.title,
    required this.summary,
    required this.items,
    required this.generatedAt,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String title;
  final String summary;
  final List<ExplanationItem> items;
  final DateTime generatedAt;
  final Map<String, dynamic> metadata;

  ExplanationSummary copyWith({
    String? title,
    String? summary,
    List<ExplanationItem>? items,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ExplanationSummary(
      title: title ?? this.title,
      summary: summary ?? this.summary,
      items: items ?? this.items,
      generatedAt: generatedAt ?? this.generatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'summary': summary,
      'items': items.map((item) => item.toMap()).toList(),
      'generatedAt': generatedAt.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ExplanationSummary.fromMap(Map<String, dynamic> map) {
    return ExplanationSummary(
      title: map['title']?.toString() ?? '',
      summary: map['summary']?.toString() ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((dynamic item) => ExplanationItem.fromMap(
                    item is Map<String, dynamic>
                        ? item
                        : Map<String, dynamic>.from(item as Map),
                  ))
              .toList(growable: false) ??
          const <ExplanationItem>[],
      generatedAt: DateTime.tryParse(map['generatedAt']?.toString() ?? '') ?? DateTime.now(),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic entry) => MapEntry<String, dynamic>(key.toString(), entry),
      );
    }
    return <String, dynamic>{};
  }
}
