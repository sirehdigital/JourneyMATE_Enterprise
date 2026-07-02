import 'memory_item.dart';

class MemoryProfile {
  const MemoryProfile({
    required this.userId,
    required this.memories,
    required this.lastUpdated,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String userId;
  final List<MemoryItem> memories;
  final DateTime lastUpdated;
  final Map<String, dynamic> metadata;

  MemoryProfile copyWith({
    String? userId,
    List<MemoryItem>? memories,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) {
    return MemoryProfile(
      userId: userId ?? this.userId,
      memories: memories ?? this.memories,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'memories': memories.map((item) => item.toMap()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory MemoryProfile.fromMap(Map<String, dynamic> map) {
    return MemoryProfile(
      userId: map['userId']?.toString() ?? '',
      memories:
          (map['memories'] as List<dynamic>?)
              ?.map(
                (dynamic item) => MemoryItem.fromMap(
                  item is Map<String, dynamic>
                      ? item
                      : Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false) ??
          const <MemoryItem>[],
      lastUpdated:
          DateTime.tryParse(map['lastUpdated']?.toString() ?? '') ??
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
