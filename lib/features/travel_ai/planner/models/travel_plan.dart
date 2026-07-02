import 'travel_plan_request.dart';
import 'travel_plan_summary.dart';
import 'itinerary_day.dart';

class TravelPlan {
  const TravelPlan({
    required this.request,
    required this.summary,
    required this.itinerary,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final TravelPlanRequest request;
  final TravelPlanSummary summary;
  final List<ItineraryDay> itinerary;
  final Map<String, dynamic> metadata;

  TravelPlan copyWith({
    TravelPlanRequest? request,
    TravelPlanSummary? summary,
    List<ItineraryDay>? itinerary,
    Map<String, dynamic>? metadata,
  }) {
    return TravelPlan(
      request: request ?? this.request,
      summary: summary ?? this.summary,
      itinerary: itinerary ?? this.itinerary,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'request': request.toMap(),
      'summary': summary.toMap(),
      'itinerary': itinerary.map((day) => day.toMap()).toList(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory TravelPlan.fromMap(Map<String, dynamic> map) {
    return TravelPlan(
      request: TravelPlanRequest.fromMap(
        map['request'] is Map<String, dynamic>
            ? map['request'] as Map<String, dynamic>
            : Map<String, dynamic>.from(map['request'] as Map),
      ),
      summary: TravelPlanSummary.fromMap(
        map['summary'] is Map<String, dynamic>
            ? map['summary'] as Map<String, dynamic>
            : Map<String, dynamic>.from(map['summary'] as Map),
      ),
      itinerary:
          (map['itinerary'] as List<dynamic>?)
              ?.map(
                (dynamic day) => ItineraryDay.fromMap(
                  day is Map<String, dynamic>
                      ? day
                      : Map<String, dynamic>.from(day as Map),
                ),
              )
              .toList(growable: false) ??
          const <ItineraryDay>[],
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
