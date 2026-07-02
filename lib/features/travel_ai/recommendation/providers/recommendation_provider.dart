import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../destination/services/destination_intelligence_service.dart';
import '../../destination/providers/destination_provider.dart';
import '../../knowledge/engine/knowledge_engine.dart';
import '../../knowledge/providers/knowledge_provider.dart';
import '../engine/recommendation_engine.dart';
import '../services/recommendation_service.dart';

final Provider<RecommendationService> recommendationServiceProvider =
    Provider<RecommendationService>(
      (ref) => RecommendationService(
        ref.watch(knowledgeEngineProvider),
        DestinationIntelligenceService(ref.watch(knowledgeEngineProvider)),
      ),
    );

final Provider<RecommendationEngine> recommendationEngineProvider =
    Provider<RecommendationEngine>(
      (ref) => RecommendationEngine(
        knowledgeEngine: ref.watch(knowledgeEngineProvider),
        destinationService: DestinationIntelligenceService(
          ref.watch(knowledgeEngineProvider),
        ),
      ),
    );
