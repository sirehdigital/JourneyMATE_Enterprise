import '../../models/travel_plan_request.dart';
import '../models/itinerary_stop.dart';
import '../models/itinerary_timeline.dart';
import '../services/itinerary_generator_service.dart';

class ItineraryTimelineEngine {
  ItineraryTimelineEngine({ItineraryGeneratorService? service})
    : _service = service ?? const ItineraryGeneratorService();

  final ItineraryGeneratorService _service;

  ItineraryTimeline generate(TravelPlanRequest request) {
    return _service.generateTimeline(request);
  }

  List<ItineraryStop> generateDayStops(TravelPlanRequest request, int day) {
    return _service.generateDayStops(request, day);
  }

  String generateMarkdown(TravelPlanRequest request) {
    return _service.exportMarkdown(generate(request));
  }

  String exportMarkdown(ItineraryTimeline timeline) {
    return _service.exportMarkdown(timeline);
  }
}
