class UserPreference {
  const UserPreference({
    required this.id,
    required this.category,
    required this.value,
    required this.weight,
    required this.confidence,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String id;
  final String category;
  final String value;
  final double weight;
  final double confidence;
  final Map<String, dynamic> metadata;

  UserPreference copyWith({
    String? id,
    String? category,
    String? value,
    double? weight,
    double? confidence,
    Map<String, dynamic>? metadata,
  }) {
    return UserPreference(
      id: id ?? this.id,
      category: category ?? this.category,
      value: value ?? this.value,
      weight: weight ?? this.weight,
      confidence: confidence ?? this.confidence,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'value': value,
      'weight': weight,
      'confidence': confidence,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory UserPreference.fromMap(Map<String, dynamic> map) {
    return UserPreference(
      id: map['id']?.toString() ?? '',
      category: map['category']?.toString() ?? 'general',
      value: map['value']?.toString() ?? '',
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0,
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
