class MemoryItem {
  const MemoryItem({
    required this.id,
    required this.category,
    required this.title,
    required this.value,
    required this.confidence,
    required this.createdAt,
    required this.updatedAt,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String id;
  final String category;
  final String title;
  final String value;
  final double confidence;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;

  MemoryItem copyWith({
    String? id,
    String? category,
    String? title,
    String? value,
    double? confidence,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return MemoryItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      value: value ?? this.value,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'title': title,
      'value': value,
      'confidence': confidence,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory MemoryItem.fromMap(Map<String, dynamic> map) {
    return MemoryItem(
      id: map['id']?.toString() ?? '',
      category: map['category']?.toString() ?? 'general',
      title: map['title']?.toString() ?? '',
      value: map['value']?.toString() ?? '',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0,
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
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
