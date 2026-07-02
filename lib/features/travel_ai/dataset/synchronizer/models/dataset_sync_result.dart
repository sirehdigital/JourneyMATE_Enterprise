class DatasetSyncResult {
  DatasetSyncResult({
    required this.success,
    List<String>? synchronizedDatasets,
    List<String>? skippedDatasets,
    List<String>? failedDatasets,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) : synchronizedDatasets = List<String>.unmodifiable(
         synchronizedDatasets ?? const <String>[],
       ),
       skippedDatasets = List<String>.unmodifiable(
         skippedDatasets ?? const <String>[],
       ),
       failedDatasets = List<String>.unmodifiable(
         failedDatasets ?? const <String>[],
       ),
       timestamp = timestamp ?? DateTime.now(),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final bool success;
  final List<String> synchronizedDatasets;
  final List<String> skippedDatasets;
  final List<String> failedDatasets;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  DatasetSyncResult copyWith({
    bool? success,
    List<String>? synchronizedDatasets,
    List<String>? skippedDatasets,
    List<String>? failedDatasets,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return DatasetSyncResult(
      success: success ?? this.success,
      synchronizedDatasets: synchronizedDatasets ?? this.synchronizedDatasets,
      skippedDatasets: skippedDatasets ?? this.skippedDatasets,
      failedDatasets: failedDatasets ?? this.failedDatasets,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'synchronizedDatasets': List<String>.from(synchronizedDatasets),
      'skippedDatasets': List<String>.from(skippedDatasets),
      'failedDatasets': List<String>.from(failedDatasets),
      'timestamp': timestamp.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory DatasetSyncResult.fromMap(Map<String, dynamic> map) {
    return DatasetSyncResult(
      success: _toBool(map['success']),
      synchronizedDatasets: _toStringList(map['synchronizedDatasets']),
      skippedDatasets: _toStringList(map['skippedDatasets']),
      failedDatasets: _toStringList(map['failedDatasets']),
      timestamp: _toDateTime(map['timestamp']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      return value.trim().toLowerCase() == 'true';
    }
    return false;
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value.trim()) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList(growable: false);
    }
    return const <String>[];
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
