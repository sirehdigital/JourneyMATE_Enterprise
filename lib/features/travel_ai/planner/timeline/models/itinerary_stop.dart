class ItineraryStop {
  ItineraryStop({
    required this.id,
    required this.title,
    this.description = '',
    this.category = 'activity',
    this.startTime = '',
    this.endTime = '',
    Duration? duration,
    this.latitude = 0,
    this.longitude = 0,
    Map<String, dynamic>? metadata,
  }) : duration = duration ?? Duration.zero,
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String id;
  final String title;
  final String description;
  final String category;
  final String startTime;
  final String endTime;
  final Duration duration;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> metadata;

  ItineraryStop copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? startTime,
    String? endTime,
    Duration? duration,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? metadata,
  }) {
    return ItineraryStop(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'startTime': startTime,
      'endTime': endTime,
      'durationMinutes': duration.inMinutes,
      'latitude': latitude,
      'longitude': longitude,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ItineraryStop.fromMap(Map<String, dynamic> map) {
    return ItineraryStop(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      category: map['category']?.toString() ?? 'activity',
      startTime: map['startTime']?.toString() ?? '',
      endTime: map['endTime']?.toString() ?? '',
      duration: Duration(minutes: _toInt(map['durationMinutes'])),
      latitude: _toDouble(map['latitude']),
      longitude: _toDouble(map['longitude']),
      metadata: _normalizeMap(map['metadata']),
    );
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

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim()) ?? 0;
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
