class ExplanationItem {
  const ExplanationItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.score,
    required this.category,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String id;
  final String title;
  final String detail;
  final double score;
  final String category;
  final Map<String, dynamic> metadata;

  ExplanationItem copyWith({
    String? id,
    String? title,
    String? detail,
    double? score,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return ExplanationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      score: score ?? this.score,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'detail': detail,
      'score': score,
      'category': category,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ExplanationItem.fromMap(Map<String, dynamic> map) {
    return ExplanationItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      detail: map['detail']?.toString() ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0,
      category: map['category']?.toString() ?? 'general',
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
