import '../models/ai_card.dart';
import '../models/ai_card_action.dart';
import '../models/ai_card_group.dart';

class AICardService {
  const AICardService();

  AICard buildDestinationCard({
    String id = 'destination-card',
    String title = 'Destination',
    String subtitle = '',
    String description = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    return _buildCard(
      id: id,
      type: 'destination',
      title: title,
      subtitle: subtitle,
      description: description,
      icon: 'map-pin',
      priority: 10,
      confidence: confidence,
      metadata: metadata,
    );
  }

  AICard buildHotelCard({
    String id = 'hotel-card',
    String title = 'Hotel',
    String subtitle = '',
    String description = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    return _buildCard(
      id: id,
      type: 'hotel',
      title: title,
      subtitle: subtitle,
      description: description,
      icon: 'hotel',
      priority: 20,
      confidence: confidence,
      metadata: metadata,
    );
  }

  AICard buildBudgetCard({
    String id = 'budget-card',
    String title = 'Budget',
    String subtitle = '',
    String description = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    return _buildCard(
      id: id,
      type: 'budget',
      title: title,
      subtitle: subtitle,
      description: description,
      icon: 'wallet',
      priority: 30,
      confidence: confidence,
      metadata: metadata,
    );
  }

  AICard buildItineraryCard({
    String id = 'itinerary-card',
    String title = 'Itinerary',
    String subtitle = '',
    String description = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    return _buildCard(
      id: id,
      type: 'itinerary',
      title: title,
      subtitle: subtitle,
      description: description,
      icon: 'route',
      priority: 40,
      confidence: confidence,
      metadata: metadata,
    );
  }

  AICard buildReasoningCard({
    String id = 'reasoning-card',
    String title = 'Reasoning',
    String subtitle = '',
    String description = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    return _buildCard(
      id: id,
      type: 'reasoning',
      title: title,
      subtitle: subtitle,
      description: description,
      icon: 'brain',
      priority: 50,
      confidence: confidence,
      metadata: metadata,
    );
  }

  AICard buildConfidenceCard({
    String id = 'confidence-card',
    String title = 'Confidence',
    String subtitle = '',
    String description = '',
    double confidence = 0,
    Map<String, dynamic>? metadata,
  }) {
    return _buildCard(
      id: id,
      type: 'confidence',
      title: title,
      subtitle: subtitle,
      description: description,
      icon: 'gauge',
      priority: 60,
      confidence: confidence,
      metadata: metadata,
    );
  }

  AICardGroup buildCardGroup({
    String id = 'ai-card-group',
    String title = 'JourneyMATE Smart AI Cards',
    String subtitle = '',
    List<AICard> cards = const <AICard>[],
    Map<String, dynamic>? metadata,
  }) {
    try {
      final sortedCards = List<AICard>.from(cards)
        ..sort((left, right) => left.priority.compareTo(right.priority));
      return AICardGroup(
        id: _safeText(id, fallback: 'ai-card-group'),
        title: _safeText(title, fallback: 'JourneyMATE Smart AI Cards'),
        subtitle: subtitle.trim(),
        cards: sortedCards,
        metadata: metadata,
      );
    } catch (_) {
      return AICardGroup(
        id: 'ai-card-group',
        title: 'JourneyMATE Smart AI Cards',
        cards: const <AICard>[],
        metadata: const <String, dynamic>{'safeFallback': true},
      );
    }
  }

  AICard _buildCard({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    required String description,
    required String icon,
    required int priority,
    required double confidence,
    Map<String, dynamic>? metadata,
  }) {
    try {
      return AICard(
        id: _safeText(id, fallback: '$type-card'),
        type: _safeText(type, fallback: 'generic'),
        title: _safeText(title, fallback: _titleCase(type)),
        subtitle: subtitle.trim(),
        description: _safeText(description),
        icon: _safeText(icon, fallback: 'info'),
        priority: priority,
        confidence: confidence.clamp(0.0, 1.0).toDouble(),
        actions: <AICardAction>[
          AICardAction(
            id: '$type-view-details',
            label: 'View details',
            actionType: 'view_details',
            payload: <String, dynamic>{'cardType': type},
          ),
        ],
        metadata: <String, dynamic>{
          ..._normalizeMap(metadata),
          'supportedTypes': const <String>[
            'destination',
            'hotel',
            'flight',
            'budget',
            'itinerary',
            'restaurant',
            'mosque',
            'transport',
            'reasoning',
            'explanation',
            'confidence',
            'emergency',
          ],
        },
      );
    } catch (_) {
      return AICard(
        id: '$type-card',
        type: type,
        title: _titleCase(type),
        description: 'No card details are available.',
        icon: 'info',
        priority: priority,
        confidence: 0,
      );
    }
  }

  String _safeText(String value, {String fallback = 'No details available.'}) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? fallback : trimmedValue;
  }

  String _titleCase(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      return 'Card';
    }
    return normalizedValue.substring(0, 1).toUpperCase() +
        normalizedValue.substring(1);
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic entry) =>
            MapEntry<String, dynamic>(key.toString(), entry),
      );
    }
    return <String, dynamic>{};
  }
}
