class KnowledgeEdge {
  KnowledgeEdge({
    required this.sourceId,
    required this.targetId,
    required this.relationship,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String sourceId;
  final String targetId;
  final String relationship;
  final Map<String, dynamic> metadata;

  KnowledgeEdge copyWith({
    String? sourceId,
    String? targetId,
    String? relationship,
    Map<String, dynamic>? metadata,
  }) {
    return KnowledgeEdge(
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      relationship: relationship ?? this.relationship,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sourceId': sourceId,
      'targetId': targetId,
      'relationship': relationship,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory KnowledgeEdge.fromMap(Map<String, dynamic> map) {
    return KnowledgeEdge(
      sourceId: map['sourceId']?.toString() ?? '',
      targetId: map['targetId']?.toString() ?? '',
      relationship: map['relationship']?.toString() ?? '',
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
