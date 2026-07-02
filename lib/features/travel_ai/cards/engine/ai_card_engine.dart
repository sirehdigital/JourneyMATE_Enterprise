import '../models/ai_card.dart';
import '../models/ai_card_group.dart';
import '../services/ai_card_service.dart';

class AICardEngine {
  AICardEngine({AICardService? service})
    : _service = service ?? const AICardService();

  final AICardService _service;

  List<AICard> generateCards({
    String destination = '',
    String hotelSummary = '',
    String budgetSummary = '',
    String itinerarySummary = '',
    String reasoningSummary = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    return <AICard>[
      if (destination.trim().isNotEmpty)
        _service.buildDestinationCard(
          title: destination,
          description: destination,
          confidence: confidence,
          metadata: metadata,
        ),
      if (hotelSummary.trim().isNotEmpty)
        _service.buildHotelCard(
          description: hotelSummary,
          confidence: confidence,
          metadata: metadata,
        ),
      if (budgetSummary.trim().isNotEmpty)
        _service.buildBudgetCard(
          description: budgetSummary,
          confidence: confidence,
          metadata: metadata,
        ),
      if (itinerarySummary.trim().isNotEmpty)
        _service.buildItineraryCard(
          description: itinerarySummary,
          confidence: confidence,
          metadata: metadata,
        ),
      if (reasoningSummary.trim().isNotEmpty)
        _service.buildReasoningCard(
          description: reasoningSummary,
          confidence: confidence,
          metadata: metadata,
        ),
      _service.buildConfidenceCard(
        subtitle: '${(confidence.clamp(0.0, 1.0) * 100).toStringAsFixed(0)}%',
        description:
            'Confidence score from the JourneyMATE AI intelligence layer.',
        confidence: confidence,
        metadata: metadata,
      ),
    ];
  }

  AICardGroup generateTravelPlanCards({
    String title = 'Travel Plan Cards',
    String destination = '',
    String itinerarySummary = '',
    String budgetSummary = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    final cards = <AICard>[
      if (destination.trim().isNotEmpty)
        _service.buildDestinationCard(
          title: destination,
          description: destination,
          confidence: confidence,
          metadata: metadata,
        ),
      _service.buildItineraryCard(
        description: itinerarySummary,
        confidence: confidence,
        metadata: metadata,
      ),
      _service.buildBudgetCard(
        description: budgetSummary,
        confidence: confidence,
        metadata: metadata,
      ),
    ];
    return _service.buildCardGroup(
      id: 'travel-plan-cards',
      title: title,
      cards: cards,
      metadata: metadata,
    );
  }

  AICardGroup generateRecommendationCards({
    String title = 'Recommendation Cards',
    String destination = '',
    String hotelSummary = '',
    String reasoningSummary = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    final cards = <AICard>[
      if (destination.trim().isNotEmpty)
        _service.buildDestinationCard(
          title: destination,
          description: destination,
          confidence: confidence,
          metadata: metadata,
        ),
      if (hotelSummary.trim().isNotEmpty)
        _service.buildHotelCard(
          description: hotelSummary,
          confidence: confidence,
          metadata: metadata,
        ),
      if (reasoningSummary.trim().isNotEmpty)
        _service.buildReasoningCard(
          description: reasoningSummary,
          confidence: confidence,
          metadata: metadata,
        ),
    ];
    return _service.buildCardGroup(
      id: 'recommendation-cards',
      title: title,
      cards: cards,
      metadata: metadata,
    );
  }

  AICardGroup generateBrainSummaryCards({
    String title = 'AI Brain Summary Cards',
    String recommendationSummary = '',
    String travelPlanSummary = '',
    String reasoningSummary = '',
    String explanationSummary = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    final cards = <AICard>[
      _service.buildDestinationCard(
        title: 'Recommendation',
        description: recommendationSummary,
        confidence: confidence,
        metadata: metadata,
      ),
      _service.buildItineraryCard(
        title: 'Travel Plan',
        description: travelPlanSummary,
        confidence: confidence,
        metadata: metadata,
      ),
      _service.buildReasoningCard(
        description: reasoningSummary,
        confidence: confidence,
        metadata: metadata,
      ),
      _service.buildConfidenceCard(
        description: explanationSummary,
        confidence: confidence,
        metadata: metadata,
      ),
    ];
    return _service.buildCardGroup(
      id: 'ai-brain-summary-cards',
      title: title,
      cards: cards,
      metadata: metadata,
    );
  }
}
