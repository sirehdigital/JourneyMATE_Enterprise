class KnowledgeNode {
  KnowledgeNode({
    required this.id,
    required this.type,
    required this.name,
    Map<String, dynamic>? attributes,
    Map<String, dynamic>? metadata,
  }) : attributes = Map<String, dynamic>.unmodifiable(
         attributes ?? const <String, dynamic>{},
       ),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String id;
  final String type;
  final String name;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> metadata;

  KnowledgeNode copyWith({
    String? id,
    String? type,
    String? name,
    Map<String, dynamic>? attributes,
    Map<String, dynamic>? metadata,
  }) {
    return KnowledgeNode(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      attributes: attributes ?? this.attributes,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'name': name,
      'attributes': Map<String, dynamic>.from(attributes),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory KnowledgeNode.fromMap(Map<String, dynamic> map) {
    return KnowledgeNode(
      id: map['id']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      attributes: _normalizeMap(map['attributes']),
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
