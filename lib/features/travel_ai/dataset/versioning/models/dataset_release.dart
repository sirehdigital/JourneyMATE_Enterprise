class DatasetRelease {
  DatasetRelease({
    required this.releaseVersion,
    required this.releaseDate,
    List<String>? supportedStates,
    required this.minimumAppVersion,
    Map<String, dynamic>? metadata,
  }) : supportedStates = List<String>.unmodifiable(
         supportedStates ?? const <String>[],
       ),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String releaseVersion;
  final DateTime releaseDate;
  final List<String> supportedStates;
  final String minimumAppVersion;
  final Map<String, dynamic> metadata;

  DatasetRelease copyWith({
    String? releaseVersion,
    DateTime? releaseDate,
    List<String>? supportedStates,
    String? minimumAppVersion,
    Map<String, dynamic>? metadata,
  }) {
    return DatasetRelease(
      releaseVersion: releaseVersion ?? this.releaseVersion,
      releaseDate: releaseDate ?? this.releaseDate,
      supportedStates: supportedStates ?? this.supportedStates,
      minimumAppVersion: minimumAppVersion ?? this.minimumAppVersion,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'releaseVersion': releaseVersion,
      'releaseDate': releaseDate.toIso8601String(),
      'supportedStates': List<String>.from(supportedStates),
      'minimumAppVersion': minimumAppVersion,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory DatasetRelease.fromMap(Map<String, dynamic> map) {
    return DatasetRelease(
      releaseVersion: map['releaseVersion']?.toString() ?? '0.0.0',
      releaseDate: _toDateTime(map['releaseDate']),
      supportedStates: _toStringList(map['supportedStates']),
      minimumAppVersion: map['minimumAppVersion']?.toString() ?? '0.0.0',
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
