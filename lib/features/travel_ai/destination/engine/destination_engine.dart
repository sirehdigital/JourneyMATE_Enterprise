import '../../knowledge/engine/knowledge_engine.dart';
import '../models/destination_request.dart';
import '../models/destination_result.dart';
import '../services/destination_intelligence_service.dart';

class DestinationEngine {
  DestinationEngine({required KnowledgeEngine knowledgeEngine})
    : _service = DestinationIntelligenceService(knowledgeEngine);

  final DestinationIntelligenceService _service;

  DestinationResult analyzeDestination(DestinationRequest request) {
    return _service.analyze(request);
  }
}
