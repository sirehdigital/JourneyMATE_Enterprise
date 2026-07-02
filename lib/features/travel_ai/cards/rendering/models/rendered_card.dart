import '../../models/ai_card_action.dart';

class RenderedCard {
  RenderedCard({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle = '',
    this.icon = 'info',
    this.image = '',
    List<AICardAction>? actions,
    Map<String, dynamic>? metadata,
    this.expandable = true,
    this.shareable = true,
    this.savable = true,
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
  final String icon;
  final String image;
  final List<AICardAction> actions;
  final Map<String, dynamic> metadata;
  final bool expandable;
  final bool shareable;
  final bool savable;

  RenderedCard copyWith({
    String? id,
    String? type,
    String? title,
    String? subtitle,
    String? icon,
    String? image,
    List<AICardAction>? actions,
    Map<String, dynamic>? metadata,
    bool? expandable,
    bool? shareable,
    bool? savable,
  }) {
    return RenderedCard(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      actions: actions ?? this.actions,
      metadata: metadata ?? this.metadata,
      expandable: expandable ?? this.expandable,
      shareable: shareable ?? this.shareable,
      savable: savable ?? this.savable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'image': image,
      'actions': actions
          .map((action) => action.toMap())
          .toList(growable: false),
      'metadata': Map<String, dynamic>.from(metadata),
      'expandable': expandable,
      'shareable': shareable,
      'savable': savable,
    };
  }

  factory RenderedCard.fromMap(Map<String, dynamic> map) {
    return RenderedCard(
      id: map['id']?.toString() ?? '',
      type: map['type']?.toString() ?? 'insight',
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      icon: map['icon']?.toString() ?? 'info',
      image: map['image']?.toString() ?? '',
      actions: _parseActions(map['actions']),
      metadata: _normalizeMap(map['metadata']),
      expandable: _toBool(map['expandable'], fallback: true),
      shareable: _toBool(map['shareable'], fallback: true),
      savable: _toBool(map['savable'], fallback: true),
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

  static bool _toBool(dynamic value, {required bool fallback}) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      final normalizedValue = value.trim().toLowerCase();
      if (normalizedValue == 'true') return true;
      if (normalizedValue == 'false') return false;
    }
    return fallback;
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
