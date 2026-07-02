class MemorySnapshot {
  const MemorySnapshot({
    required this.timestamp,
    required this.summary,
    required this.totalMemories,
    required this.profileVersion,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final DateTime timestamp;
  final String summary;
  final int totalMemories;
  final int profileVersion;
  final Map<String, dynamic> metadata;

  MemorySnapshot copyWith({
    DateTime? timestamp,
    String? summary,
    int? totalMemories,
    int? profileVersion,
    Map<String, dynamic>? metadata,
  }) {
    return MemorySnapshot(
      timestamp: timestamp ?? this.timestamp,
      summary: summary ?? this.summary,
      totalMemories: totalMemories ?? this.totalMemories,
      profileVersion: profileVersion ?? this.profileVersion,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp.toIso8601String(),
      'summary': summary,
      'totalMemories': totalMemories,
      'profileVersion': profileVersion,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory MemorySnapshot.fromMap(Map<String, dynamic> map) {
    return MemorySnapshot(
      timestamp:
          DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      summary: map['summary']?.toString() ?? '',
      totalMemories: (map['totalMemories'] as num?)?.toInt() ?? 0,
      profileVersion: (map['profileVersion'] as num?)?.toInt() ?? 0,
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
