import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/itinerary_timeline_engine.dart';
import '../services/itinerary_generator_service.dart';

final Provider<ItineraryGeneratorService> itineraryGeneratorServiceProvider =
    Provider<ItineraryGeneratorService>((ref) {
      return const ItineraryGeneratorService();
    });

final Provider<ItineraryTimelineEngine> itineraryTimelineEngineProvider =
    Provider<ItineraryTimelineEngine>((ref) {
      final service = ref.watch(itineraryGeneratorServiceProvider);
      return ItineraryTimelineEngine(service: service);
    });
