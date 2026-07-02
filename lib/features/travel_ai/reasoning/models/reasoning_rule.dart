class ReasoningRule {
  const ReasoningRule({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.enabled,
    Map<String, dynamic>? conditions,
    Map<String, dynamic>? actions,
    Map<String, dynamic>? metadata,
  }) : conditions = conditions ?? const <String, dynamic>{},
       actions = actions ?? const <String, dynamic>{},
       metadata = metadata ?? const <String, dynamic>{};

  final String id;
  final String name;
  final String description;
  final int priority;
  final bool enabled;
  final Map<String, dynamic> conditions;
  final Map<String, dynamic> actions;
  final Map<String, dynamic> metadata;

  ReasoningRule copyWith({
    String? id,
    String? name,
    String? description,
    int? priority,
    bool? enabled,
    Map<String, dynamic>? conditions,
    Map<String, dynamic>? actions,
    Map<String, dynamic>? metadata,
  }) {
    return ReasoningRule(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      enabled: enabled ?? this.enabled,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'priority': priority,
      'enabled': enabled,
      'conditions': Map<String, dynamic>.from(conditions),
      'actions': Map<String, dynamic>.from(actions),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ReasoningRule.fromMap(Map<String, dynamic> map) {
    return ReasoningRule(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      priority: (map['priority'] as num?)?.toInt() ?? 0,
      enabled: map['enabled'] as bool? ?? true,
      conditions: _normalizeMap(map['conditions']),
      actions: _normalizeMap(map['actions']),
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
