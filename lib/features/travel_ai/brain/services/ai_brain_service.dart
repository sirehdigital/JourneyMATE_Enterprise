import '../../destination/services/destination_intelligence_service.dart';
import '../../explainable/engine/explanation_engine.dart';
import '../../knowledge/engine/knowledge_engine.dart';
import '../../knowledge/entities/knowledge_graph.dart';
import '../../knowledge/services/graph_query_service.dart';
import '../../memory/engine/memory_engine.dart';
import '../../personalization/engine/personalization_engine.dart';
import '../../planner/engine/travel_planner_engine.dart';
import '../../planner/models/travel_plan_request.dart';
import '../../reasoning/engine/reasoning_engine.dart';
import '../../reasoning/models/reasoning_context.dart';
import '../../reasoning/models/reasoning_rule.dart';
import '../../recommendation/engine/recommendation_engine.dart';
import '../../recommendation/models/recommendation_request.dart';
import '../models/ai_brain_request.dart';
import '../models/ai_brain_response.dart';
import '../models/ai_brain_status.dart';

class AIBrainService {
  AIBrainService() : _status = const AIBrainStatus();

  AIBrainStatus _status;
  KnowledgeEngine? _knowledgeEngine;
  DestinationIntelligenceService? _destinationService;
  RecommendationEngine? _recommendationEngine;
  TravelPlannerEngine? _plannerEngine;
  MemoryEngine? _memoryEngine;
  PersonalizationEngine? _personalizationEngine;
  ExplanationEngine? _explanationEngine;
  ReasoningEngine? _reasoningEngine;
  final List<Map<String, dynamic>> _diagnostics = <Map<String, dynamic>>[];

  AIBrainStatus initialize() {
    _diagnostics.clear();

    try {
      final graph = KnowledgeGraph();
      final queryService = GraphQueryService(graph);
      _knowledgeEngine = KnowledgeEngine(queryService: queryService);
      _destinationService = DestinationIntelligenceService(_knowledgeEngine!);
      _recommendationEngine = RecommendationEngine(
        knowledgeEngine: _knowledgeEngine!,
        destinationService: _destinationService!,
      );
      _plannerEngine = TravelPlannerEngine(
        knowledgeEngine: _knowledgeEngine!,
        destinationService: _destinationService!,
      );
      _memoryEngine = MemoryEngine();
      _personalizationEngine = PersonalizationEngine();
      _explanationEngine = ExplanationEngine();
      _reasoningEngine = ReasoningEngine();

      _status = const AIBrainStatus(
        initialized: true,
        knowledgeReady: true,
        memoryReady: true,
        plannerReady: true,
        reasoningReady: true,
        recommendationReady: true,
        personalizationReady: true,
        explainableReady: true,
        metadata: <String, dynamic>{'mode': 'local-only'},
      );
    } catch (error, stackTrace) {
      _recordRecoverableError('initialize', error, stackTrace);
      _status = AIBrainStatus(
        initialized: true,
        knowledgeReady: false,
        memoryReady: false,
        plannerReady: false,
        reasoningReady: false,
        recommendationReady: false,
        personalizationReady: false,
        explainableReady: false,
        metadata: <String, dynamic>{
          'mode': 'local-only',
          'fallback': true,
          'error': _errorSummary(error),
        },
      );
    }

    return _status;
  }

  AIBrainResponse processRequest(AIBrainRequest request) {
    try {
      final status = _ensureInitialized();
      final context = buildContext(request);
      return buildResponse(request, context: context, status: status);
    } catch (error, stackTrace) {
      _recordRecoverableError('processRequest', error, stackTrace);
      return AIBrainResponse(
        recommendationSummary: 'Local recommendation layer unavailable.',
        travelPlanSummary: 'Local planner unavailable.',
        reasoningSummary: 'Local reasoning layer unavailable.',
        explanationSummary: 'Local explainability unavailable.',
        confidence: 0,
        generatedAt: DateTime.now(),
        metadata: <String, dynamic>{
          'status': _status.toMap(),
          'destination': request.destination,
          'error': _errorSummary(error),
          'diagnostics': _diagnosticsSnapshot(),
        },
      );
    }
  }

  ReasoningContext buildContext(AIBrainRequest request) {
    return ReasoningContext(
      destination: request.destination,
      travelStyle: request.travelStyle,
      budget: request.budget,
      durationDays: request.durationDays,
      travellers: request.travellers,
      preferences: request.preferences,
      metadata: <String, dynamic>{'userPrompt': request.userPrompt},
    );
  }

  AIBrainResponse buildResponse(
    AIBrainRequest request, {
    ReasoningContext? context,
    AIBrainStatus? status,
  }) {
    final effectiveStatus = status ?? _ensureInitialized();
    final effectiveContext = context ?? buildContext(request);

    final recommendationSummary = _buildRecommendationSummary(request);
    final travelPlanSummary = _buildTravelPlanSummary(request);
    final reasoningSummary = _buildReasoningSummary(request, effectiveContext);
    final explanationSummary = _buildExplanationSummary(request);
    final confidence = _calculateConfidence(request, effectiveStatus);

    return AIBrainResponse(
      recommendationSummary: recommendationSummary,
      travelPlanSummary: travelPlanSummary,
      reasoningSummary: reasoningSummary,
      explanationSummary: explanationSummary,
      confidence: confidence,
      generatedAt: DateTime.now(),
      metadata: <String, dynamic>{
        'status': effectiveStatus.toMap(),
        'destination': request.destination,
        if (_diagnostics.isNotEmpty) 'diagnostics': _diagnosticsSnapshot(),
      },
    );
  }

  AIBrainStatus healthCheck() {
    if (!_status.initialized) {
      return initialize();
    }
    return _status;
  }

  String _buildRecommendationSummary(AIBrainRequest request) {
    try {
      if (_recommendationEngine == null) {
        return 'Local recommendation layer ready.';
      }
      final recommendationRequest = RecommendationRequest(
        destination: request.destination,
        travelStyle: request.travelStyle,
        budget: request.budget,
        durationDays: request.durationDays,
        travellers: request.travellers,
        preferences: request.preferences,
      );
      final result = _recommendationEngine!.recommendTrips(
        recommendationRequest,
      );
      return 'Local recommendation engine generated ${result.totalResults} trip options for ${request.destination}.';
    } catch (error, stackTrace) {
      _recordRecoverableError(
        'buildRecommendationSummary',
        error,
        stackTrace,
      );
      return 'Local recommendation layer ready.';
    }
  }

  String _buildTravelPlanSummary(AIBrainRequest request) {
    try {
      if (_plannerEngine == null) {
        return 'Local planner ready.';
      }
      final planRequest = TravelPlanRequest(
        destination: request.destination,
        durationDays: request.durationDays,
        travellers: request.travellers,
        budget: request.budget,
        travelStyle: request.travelStyle,
        transportMode: request.transportMode,
        preferences: request.preferences,
      );
      final plan = _plannerEngine!.createTravelPlan(planRequest);
      return 'Local planner produced ${plan.summary.totalActivities} '
          'activities for ${request.destination}.';
    } catch (error, stackTrace) {
      _recordRecoverableError('buildTravelPlanSummary', error, stackTrace);
      return 'Local planner ready.';
    }
  }

  String _buildReasoningSummary(
    AIBrainRequest request,
    ReasoningContext context,
  ) {
    try {
      if (_reasoningEngine == null) {
        return 'Local reasoning layer ready.';
      }
      final decision = _reasoningEngine!.evaluateScenario(
        context: context,
        rules: const <ReasoningRule>[],
      );
      return 'Reasoning engine produced ${decision.title} with confidence ${decision.confidence.toStringAsFixed(2)}.';
    } catch (error, stackTrace) {
      _recordRecoverableError('buildReasoningSummary', error, stackTrace);
      return 'Local reasoning layer ready.';
    }
  }

  String _buildExplanationSummary(AIBrainRequest request) {
    try {
      if (_explanationEngine == null) {
        return 'Local explainability ready.';
      }
      final report = _explanationEngine!.explainRecommendation(
        title: 'JourneyMATE Recommendation',
        destination: request.destination,
        score: request.budget > 0 ? 0.8 : 0.6,
      );
      return 'Local explanation engine generated ${report.items.length} explanation points.';
    } catch (error, stackTrace) {
      _recordRecoverableError('buildExplanationSummary', error, stackTrace);
      return 'Local explainability ready.';
    }
  }

  double _calculateConfidence(AIBrainRequest request, AIBrainStatus status) {
    final base = status.initialized ? 0.7 : 0.2;
    final destinationBonus = request.destination.isEmpty ? 0.0 : 0.1;
    final preferenceBonus = request.preferences.isEmpty ? 0.0 : 0.1;
    return (base + destinationBonus + preferenceBonus)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  AIBrainStatus _ensureInitialized() {
    if (_status.initialized) {
      return _status;
    }
    return initialize();
  }

  void _recordRecoverableError(
    String operation,
    Object error,
    StackTrace stackTrace,
  ) {
    _diagnostics.add(
      <String, dynamic>{
        'operation': operation,
        'error': _errorSummary(error),
        'stackTrace': stackTrace.toString(),
      },
    );

    const maximumDiagnostics = 10;
    if (_diagnostics.length > maximumDiagnostics) {
      _diagnostics.removeAt(0);
    }
  }

  List<Map<String, dynamic>> _diagnosticsSnapshot() {
    return List<Map<String, dynamic>>.unmodifiable(
      _diagnostics.map(
        (diagnostic) => Map<String, dynamic>.unmodifiable(diagnostic),
      ),
    );
  }

  String _errorSummary(Object error) {
    final message = error.toString().trim();
    return message.isEmpty ? error.runtimeType.toString() : message;
  }
}
