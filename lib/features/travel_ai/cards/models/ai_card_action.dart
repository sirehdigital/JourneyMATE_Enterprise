class AICardAction {
  AICardAction({
    required this.id,
    required this.label,
    required this.actionType,
    Map<String, dynamic>? payload,
    Map<String, dynamic>? metadata,
  }) : payload = Map<String, dynamic>.unmodifiable(
         payload ?? const <String, dynamic>{},
       ),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String id;
  final String label;
  final String actionType;
  final Map<String, dynamic> payload;
  final Map<String, dynamic> metadata;

  AICardAction copyWith({
    String? id,
    String? label,
    String? actionType,
    Map<String, dynamic>? payload,
    Map<String, dynamic>? metadata,
  }) {
    return AICardAction(
      id: id ?? this.id,
      label: label ?? this.label,
      actionType: actionType ?? this.actionType,
      payload: payload ?? this.payload,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'actionType': actionType,
      'payload': Map<String, dynamic>.from(payload),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory AICardAction.fromMap(Map<String, dynamic> map) {
    return AICardAction(
      id: map['id']?.toString() ?? '',
      label: map['label']?.toString() ?? '',
      actionType: map['actionType']?.toString() ?? 'none',
      payload: _normalizeMap(map['payload']),
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
