class DatasetVersion {
  DatasetVersion({
    required this.datasetId,
    required this.version,
    required this.installedAt,
    required this.source,
    required this.checksum,
    Map<String, dynamic>? metadata,
  }) : metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String datasetId;
  final String version;
  final DateTime installedAt;
  final String source;
  final String checksum;
  final Map<String, dynamic> metadata;

  DatasetVersion copyWith({
    String? datasetId,
    String? version,
    DateTime? installedAt,
    String? source,
    String? checksum,
    Map<String, dynamic>? metadata,
  }) {
    return DatasetVersion(
      datasetId: datasetId ?? this.datasetId,
      version: version ?? this.version,
      installedAt: installedAt ?? this.installedAt,
      source: source ?? this.source,
      checksum: checksum ?? this.checksum,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'datasetId': datasetId,
      'version': version,
      'installedAt': installedAt.toIso8601String(),
      'source': source,
      'checksum': checksum,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory DatasetVersion.fromMap(Map<String, dynamic> map) {
    return DatasetVersion(
      datasetId: map['datasetId']?.toString() ?? '',
      version: map['version']?.toString() ?? '0.0.0',
      installedAt: _toDateTime(map['installedAt']),
      source: map['source']?.toString() ?? 'local',
      checksum: map['checksum']?.toString() ?? '',
      metadata: _normalizeMap(map['metadata']),
    );
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
