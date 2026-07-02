class ItineraryActivity {
  const ItineraryActivity({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.estimatedCost,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String id;
  final String title;
  final String category;
  final String location;
  final String startTime;
  final String endTime;
  final double estimatedCost;
  final Map<String, dynamic> metadata;

  ItineraryActivity copyWith({
    String? id,
    String? title,
    String? category,
    String? location,
    String? startTime,
    String? endTime,
    double? estimatedCost,
    Map<String, dynamic>? metadata,
  }) {
    return ItineraryActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'location': location,
      'startTime': startTime,
      'endTime': endTime,
      'estimatedCost': estimatedCost,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ItineraryActivity.fromMap(Map<String, dynamic> map) {
    return ItineraryActivity(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      startTime: map['startTime']?.toString() ?? '',
      endTime: map['endTime']?.toString() ?? '',
      estimatedCost: (map['estimatedCost'] as num?)?.toDouble() ?? 0,
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
