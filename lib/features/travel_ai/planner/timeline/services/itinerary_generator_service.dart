import '../../models/travel_plan_request.dart';
import '../models/itinerary_stop.dart';
import '../models/itinerary_timeline.dart';

class ItineraryGeneratorService {
  const ItineraryGeneratorService();

  ItineraryTimeline generateTimeline(TravelPlanRequest request) {
    try {
      final dayCount = request.durationDays.clamp(1, 14).toInt();
      final days = <int, List<ItineraryStop>>{};
      for (var day = 1; day <= dayCount; day++) {
        days[day] = <ItineraryStop>[
          _buildMorningStop(request, day),
          _buildAfternoonStop(request, day),
          _buildEveningStop(request, day),
        ];
      }
      return ItineraryTimeline(
        id: 'timeline-${_slug(request.destination)}-$dayCount-days',
        destination: request.destination.trim(),
        durationDays: dayCount,
        days: days,
        metadata: <String, dynamic>{
          'travelStyle': _resolveTravelStyle(request.travelStyle),
          'transportMode': request.transportMode,
          'travellers': request.travellers,
          'supports': const <String>[
            'googleMaps',
            'appleMaps',
            'calendarExport',
            'pdf',
            'smartCards',
          ],
        },
      );
    } catch (_) {
      return ItineraryTimeline(
        id: 'timeline-safe-fallback',
        destination: request.destination,
        durationDays: 1,
        days: <int, List<ItineraryStop>>{
          1: <ItineraryStop>[
            ItineraryStop(
              id: 'day-1-morning',
              title: 'Arrival and orientation',
              description: 'Start the journey at a comfortable pace.',
              category: 'morning',
              startTime: '09:00',
              endTime: '11:00',
              duration: const Duration(hours: 2),
            ),
          ],
        },
        metadata: const <String, dynamic>{'safeFallback': true},
      );
    }
  }

  List<ItineraryStop> generateDayStops(TravelPlanRequest request, int day) {
    final timeline = generateTimeline(request);
    return timeline.stopsForDay(day);
  }

  String exportMarkdown(ItineraryTimeline timeline) {
    try {
      final buffer = StringBuffer();
      for (var day = 1; day <= timeline.durationDays; day++) {
        final stops = timeline.stopsForDay(day);
        if (stops.isEmpty) {
          continue;
        }
        buffer
          ..writeln('Day $day')
          ..writeln();
        for (final stop in stops) {
          buffer
            ..writeln('- Time: ${_timeRange(stop)}')
            ..writeln('  - Activity: ${stop.title}')
            ..writeln('  - Category: ${_titleCase(stop.category)}')
            ..writeln(
              '  - Estimated Duration: ${_formatDuration(stop.duration)}',
            );
          if (stop.description.trim().isNotEmpty) {
            buffer.writeln('  - Notes: ${stop.description.trim()}');
          }
          buffer.writeln();
        }
      }
      return buffer.toString().trim();
    } catch (_) {
      return '';
    }
  }

  ItineraryStop _buildMorningStop(TravelPlanRequest request, int day) {
    final style = _resolveTravelStyle(request.travelStyle);
    return ItineraryStop(
      id: 'day-$day-morning',
      title: _activityTitle(
        style: style,
        slot: 'morning',
        destination: request.destination,
      ),
      description: _activityNote(style: style, slot: 'morning'),
      category: 'morning',
      startTime: '09:00',
      endTime: '11:00',
      duration: const Duration(hours: 2),
      metadata: <String, dynamic>{'day': day, 'travelStyle': style},
    );
  }

  ItineraryStop _buildAfternoonStop(TravelPlanRequest request, int day) {
    final style = _resolveTravelStyle(request.travelStyle);
    return ItineraryStop(
      id: 'day-$day-afternoon',
      title: _activityTitle(
        style: style,
        slot: 'afternoon',
        destination: request.destination,
      ),
      description: _activityNote(style: style, slot: 'afternoon'),
      category: 'afternoon',
      startTime: '14:00',
      endTime: '16:30',
      duration: const Duration(minutes: 150),
      metadata: <String, dynamic>{'day': day, 'travelStyle': style},
    );
  }

  ItineraryStop _buildEveningStop(TravelPlanRequest request, int day) {
    final style = _resolveTravelStyle(request.travelStyle);
    return ItineraryStop(
      id: 'day-$day-evening',
      title: _activityTitle(
        style: style,
        slot: 'evening',
        destination: request.destination,
      ),
      description: _activityNote(style: style, slot: 'evening'),
      category: 'evening',
      startTime: '19:00',
      endTime: '21:00',
      duration: const Duration(hours: 2),
      metadata: <String, dynamic>{'day': day, 'travelStyle': style},
    );
  }

  String _activityTitle({
    required String style,
    required String slot,
    required String destination,
  }) {
    final place = destination.trim().isEmpty ? 'the destination' : destination;
    if (style == 'business') {
      if (slot == 'morning') return 'Business arrival and briefing in $place';
      if (slot == 'afternoon') return 'Focused meeting window in $place';
      return 'Light dinner and recovery time in $place';
    }
    if (style == 'solo') {
      if (slot == 'morning') return 'Independent local discovery in $place';
      if (slot == 'afternoon') return 'Flexible attraction visit in $place';
      return 'Easy evening walk and dining in $place';
    }
    if (style == 'family') {
      if (slot == 'morning') return 'Family-friendly attraction in $place';
      if (slot == 'afternoon') return 'Relaxed food and culture stop in $place';
      return 'Comfortable family dinner in $place';
    }
    if (slot == 'morning') return 'Signature attraction visit in $place';
    if (slot == 'afternoon')
      return 'Local food and culture experience in $place';
    return 'Leisure evening experience in $place';
  }

  String _activityNote({required String style, required String slot}) {
    if (style == 'business') {
      return slot == 'evening'
          ? 'Keep the evening light to protect energy for the next day.'
          : 'Keep transfers efficient and allow buffer time between commitments.';
    }
    if (style == 'family') {
      return 'Designed with a manageable pace, rest time, and family comfort in mind.';
    }
    if (style == 'solo') {
      return 'Keep the schedule flexible and avoid overloading the day.';
    }
    return 'Balanced for comfort, discovery, and practical travel pacing.';
  }

  String _resolveTravelStyle(String value) {
    final style = value.trim().toLowerCase();
    if (style.contains('family')) return 'family';
    if (style.contains('solo')) return 'solo';
    if (style.contains('business')) return 'business';
    if (style.contains('leisure')) return 'leisure';
    return 'leisure';
  }

  String _timeRange(ItineraryStop stop) {
    if (stop.startTime.isEmpty && stop.endTime.isEmpty) {
      return 'Flexible';
    }
    if (stop.endTime.isEmpty) {
      return stop.startTime;
    }
    return '${stop.startTime} - ${stop.endTime}';
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes <= 0) {
      return 'Flexible';
    }
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    }
    if (hours > 0) {
      return '${hours}h';
    }
    return '${minutes}m';
  }

  String _titleCase(String value) {
    final text = value.trim();
    if (text.isEmpty) {
      return 'Activity';
    }
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  String _slug(String value) {
    final slug = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.isEmpty ? 'destination' : slug;
  }
}
