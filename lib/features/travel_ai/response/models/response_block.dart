class ResponseBlock {
  ResponseBlock({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.icon,
    this.priority = 0,
    Map<String, dynamic>? metadata,
  }) : metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String id;
  final String type;
  final String title;
  final String content;
  final String icon;
  final int priority;
  final Map<String, dynamic> metadata;

  ResponseBlock copyWith({
    String? id,
    String? type,
    String? title,
    String? content,
    String? icon,
    int? priority,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseBlock(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      icon: icon ?? this.icon,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'title': title,
      'content': content,
      'icon': icon,
      'priority': priority,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ResponseBlock.fromMap(Map<String, dynamic> map) {
    return ResponseBlock(
      id: map['id']?.toString() ?? '',
      type: map['type']?.toString() ?? 'text',
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      icon: map['icon']?.toString() ?? 'info',
      priority: _parseInt(map['priority']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }
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
