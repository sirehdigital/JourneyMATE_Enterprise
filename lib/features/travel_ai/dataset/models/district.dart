class District {
  District({
    required this.id,
    required this.name,
    required this.state,
    this.latitude = 0,
    this.longitude = 0,
    Map<String, dynamic>? metadata,
  }) : metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String id;
  final String name;
  final String state;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> metadata;

  District copyWith({
    String? id,
    String? name,
    String? state,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? metadata,
  }) {
    return District(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      state: map['state']?.toString() ?? '',
      latitude: _toDouble(map['latitude']),
      longitude: _toDouble(map['longitude']),
      metadata: _normalizeMap(map['metadata']),
    );
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
