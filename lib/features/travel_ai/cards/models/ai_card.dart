import 'ai_card_action.dart';

class AICard {
  AICard({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle = '',
    this.description = '',
    this.icon = 'info',
    this.priority = 0,
    this.confidence = 0,
    List<AICardAction>? actions,
    Map<String, dynamic>? metadata,
  }) : actions = List<AICardAction>.unmodifiable(
         actions ?? const <AICardAction>[],
       ),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String description;
  final String icon;
  final int priority;
  final double confidence;
  final List<AICardAction> actions;
  final Map<String, dynamic> metadata;

  AICard copyWith({
    String? id,
    String? type,
    String? title,
    String? subtitle,
    String? description,
    String? icon,
    int? priority,
    double? confidence,
    List<AICardAction>? actions,
    Map<String, dynamic>? metadata,
  }) {
    return AICard(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      priority: priority ?? this.priority,
      confidence: confidence ?? this.confidence,
      actions: actions ?? this.actions,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'icon': icon,
      'priority': priority,
      'confidence': confidence,
      'actions': actions
          .map((action) => action.toMap())
          .toList(growable: false),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory AICard.fromMap(Map<String, dynamic> map) {
    return AICard(
      id: map['id']?.toString() ?? '',
      type: map['type']?.toString() ?? 'generic',
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      icon: map['icon']?.toString() ?? 'info',
      priority: _toInt(map['priority']),
      confidence: _toDouble(map['confidence']).clamp(0.0, 1.0).toDouble(),
      actions: _parseActions(map['actions']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static List<AICardAction> _parseActions(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) => AICardAction.fromMap(
              item.map<String, dynamic>(
                (dynamic key, dynamic entry) =>
                    MapEntry<String, dynamic>(key.toString(), entry),
              ),
            ),
          )
          .toList(growable: false);
    }
    return const <AICardAction>[];
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? 0;
    return 0;
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
