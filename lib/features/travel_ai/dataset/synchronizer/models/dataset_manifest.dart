class DatasetManifest {
  DatasetManifest({
    required this.datasetId,
    required this.version,
    required this.state,
    required this.checksum,
    required this.createdAt,
    required this.updatedAt,
    required this.totalRecords,
    Map<String, dynamic>? metadata,
  }) : metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String datasetId;
  final String version;
  final String state;
  final String checksum;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalRecords;
  final Map<String, dynamic> metadata;

  DatasetManifest copyWith({
    String? datasetId,
    String? version,
    String? state,
    String? checksum,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalRecords,
    Map<String, dynamic>? metadata,
  }) {
    return DatasetManifest(
      datasetId: datasetId ?? this.datasetId,
      version: version ?? this.version,
      state: state ?? this.state,
      checksum: checksum ?? this.checksum,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalRecords: totalRecords ?? this.totalRecords,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'datasetId': datasetId,
      'version': version,
      'state': state,
      'checksum': checksum,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'totalRecords': totalRecords,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory DatasetManifest.fromMap(Map<String, dynamic> map) {
    return DatasetManifest(
      datasetId: map['datasetId']?.toString() ?? '',
      version: map['version']?.toString() ?? '0.0.0',
      state: map['state']?.toString() ?? '',
      checksum: map['checksum']?.toString() ?? '',
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
      totalRecords: _toInt(map['totalRecords']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value.trim()) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static int _toInt(dynamic value) {
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
