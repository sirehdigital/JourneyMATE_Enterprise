class RecommendationItem {
  const RecommendationItem({
    required this.id,
    required this.title,
    required this.category,
    required this.score,
    required this.confidence,
    required this.reason,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String id;
  final String title;
  final String category;
  final double score;
  final double confidence;
  final String reason;
  final Map<String, dynamic> metadata;

  RecommendationItem copyWith({
    String? id,
    String? title,
    String? category,
    double? score,
    double? confidence,
    String? reason,
    Map<String, dynamic>? metadata,
  }) {
    return RecommendationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      score: score ?? this.score,
      confidence: confidence ?? this.confidence,
      reason: reason ?? this.reason,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'score': score,
      'confidence': confidence,
      'reason': reason,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory RecommendationItem.fromMap(Map<String, dynamic> map) {
    return RecommendationItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0,
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0,
      reason: map['reason']?.toString() ?? '',
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
