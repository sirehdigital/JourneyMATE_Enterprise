class ExplanationItem {
  const ExplanationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.confidence,
    required this.evidence,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String id;
  final String title;
  final String description;
  final String category;
  final double confidence;
  final List<String> evidence;
  final Map<String, dynamic> metadata;

  ExplanationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? confidence,
    List<String>? evidence,
    Map<String, dynamic>? metadata,
  }) {
    return ExplanationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
      evidence: evidence ?? this.evidence,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'confidence': confidence,
      'evidence': evidence,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ExplanationItem.fromMap(Map<String, dynamic> map) {
    return ExplanationItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      category: map['category']?.toString() ?? 'general',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0,
      evidence:
          (map['evidence'] as List<dynamic>?)
              ?.map((dynamic item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
      metadata: _normalizeMap(map['metadata']),
    );
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
