import 'itinerary_activity.dart';

class ItineraryDay {
  const ItineraryDay({
    required this.dayNumber,
    required this.title,
    required this.activities,
    required this.estimatedBudget,
  });

  final int dayNumber;
  final String title;
  final List<ItineraryActivity> activities;
  final double estimatedBudget;

  ItineraryDay copyWith({
    int? dayNumber,
    String? title,
    List<ItineraryActivity>? activities,
    double? estimatedBudget,
  }) {
    return ItineraryDay(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      activities: activities ?? this.activities,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dayNumber': dayNumber,
      'title': title,
      'activities': activities.map((activity) => activity.toMap()).toList(),
      'estimatedBudget': estimatedBudget,
    };
  }

  factory ItineraryDay.fromMap(Map<String, dynamic> map) {
    return ItineraryDay(
      dayNumber: (map['dayNumber'] as num?)?.toInt() ?? 1,
      title: map['title']?.toString() ?? '',
      activities:
          (map['activities'] as List<dynamic>?)
              ?.map(
                (dynamic activity) => ItineraryActivity.fromMap(
                  activity is Map<String, dynamic>
                      ? activity
                      : Map<String, dynamic>.from(activity as Map),
                ),
              )
              .toList(growable: false) ??
          const <ItineraryActivity>[],
      estimatedBudget: (map['estimatedBudget'] as num?)?.toDouble() ?? 0,
    );
  }
}
