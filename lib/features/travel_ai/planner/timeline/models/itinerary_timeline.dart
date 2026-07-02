import 'itinerary_stop.dart';

class ItineraryTimeline {
  ItineraryTimeline({
    required this.id,
    required this.destination,
    required this.durationDays,
    Map<int, List<ItineraryStop>>? days,
    Map<String, dynamic>? metadata,
  }) : days = _freezeDays(days),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String id;
  final String destination;
  final int durationDays;
  final Map<int, List<ItineraryStop>> days;
  final Map<String, dynamic> metadata;

  ItineraryTimeline copyWith({
    String? id,
    String? destination,
    int? durationDays,
    Map<int, List<ItineraryStop>>? days,
    Map<String, dynamic>? metadata,
  }) {
    return ItineraryTimeline(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      durationDays: durationDays ?? this.durationDays,
      days: days ?? this.days,
      metadata: metadata ?? this.metadata,
    );
  }

  List<ItineraryStop> stopsForDay(int day) {
    return days[day] ?? const <ItineraryStop>[];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'destination': destination,
      'durationDays': durationDays,
      'days': days.map<String, dynamic>(
        (day, stops) => MapEntry<String, dynamic>(
          day.toString(),
          stops.map((stop) => stop.toMap()).toList(growable: false),
        ),
      ),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ItineraryTimeline.fromMap(Map<String, dynamic> map) {
    return ItineraryTimeline(
      id: map['id']?.toString() ?? 'itinerary-timeline',
      destination: map['destination']?.toString() ?? '',
      durationDays: _toPositiveInt(map['durationDays']),
      days: _parseDays(map['days']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static Map<int, List<ItineraryStop>> _freezeDays(
    Map<int, List<ItineraryStop>>? value,
  ) {
    final source = value ?? const <int, List<ItineraryStop>>{};
    return Map<int, List<ItineraryStop>>.unmodifiable(
      source.map<int, List<ItineraryStop>>(
        (day, stops) => MapEntry<int, List<ItineraryStop>>(
          day,
          List<ItineraryStop>.unmodifiable(stops),
        ),
      ),
    );
  }

  static Map<int, List<ItineraryStop>> _parseDays(dynamic value) {
    if (value is! Map) {
      return const <int, List<ItineraryStop>>{};
    }
    final parsedDays = <int, List<ItineraryStop>>{};
    for (final entry in value.entries) {
      final day = int.tryParse(entry.key.toString()) ?? 0;
      if (day <= 0 || entry.value is! List) {
        continue;
      }
      parsedDays[day] = (entry.value as List)
          .whereType<Map>()
          .map(
            (stop) => ItineraryStop.fromMap(
              stop.map<String, dynamic>(
                (dynamic key, dynamic value) =>
                    MapEntry<String, dynamic>(key.toString(), value),
              ),
            ),
          )
          .toList(growable: false);
    }
    return parsedDays;
  }

  static int _toPositiveInt(dynamic value) {
    final parsed = value is num
        ? value.toInt()
        : int.tryParse(value?.toString() ?? '');
    if (parsed == null || parsed <= 0) {
      return 1;
    }
    return parsed;
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
