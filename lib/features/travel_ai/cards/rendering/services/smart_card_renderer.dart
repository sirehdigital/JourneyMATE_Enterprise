import '../../models/ai_card.dart';
import '../../models/ai_card_action.dart';
import '../models/rendered_card.dart';
import '../models/rendered_card_group.dart';

class SmartCardRenderer {
  const SmartCardRenderer();

  RenderedCardGroup renderGroup({
    required List<AICard> cards,
    Map<String, dynamic>? metadata,
    String id = 'journeymate-smart-cards',
    String title = 'JourneyMATE Smart Cards',
    String subtitle = '',
  }) {
    try {
      final normalizedMetadata = _normalizeMap(metadata);
      final renderedCards = <RenderedCard>[
        ...cards.map((card) => renderCard(card, metadata: normalizedMetadata)),
        ..._buildTimelineCards(normalizedMetadata),
      ];

      return RenderedCardGroup(
        id: _safeText(id, fallback: 'journeymate-smart-cards'),
        title: _safeText(title, fallback: 'JourneyMATE Smart Cards'),
        subtitle: subtitle.trim(),
        cards: renderedCards,
        metadata: <String, dynamic>{
          ...normalizedMetadata,
          'cardCount': renderedCards.length,
          'supportedIntegrations': const <String>[
            'googleMaps',
            'booking',
            'pdf',
            'voice',
            'dashboard',
            'offlineDataset',
          ],
        },
      );
    } catch (_) {
      return RenderedCardGroup(
        id: 'journeymate-smart-cards',
        title: 'JourneyMATE Smart Cards',
        cards: const <RenderedCard>[],
        metadata: const <String, dynamic>{'safeFallback': true},
      );
    }
  }

  RenderedCard renderCard(AICard card, {Map<String, dynamic>? metadata}) {
    final mergedMetadata = <String, dynamic>{
      ..._normalizeMap(metadata),
      ...card.metadata,
      'confidence': card.confidence,
      'sourceCardType': card.type,
    };
    final type = _resolveCardType(card.type);
    return RenderedCard(
      id: _safeText(card.id, fallback: '$type-card'),
      type: type,
      title: _safeText(card.title, fallback: _titleForType(type)),
      subtitle: _safeText(
        card.subtitle.isNotEmpty ? card.subtitle : card.description,
        fallback: '',
      ),
      icon: _iconForType(type, fallback: card.icon),
      image: _imageForType(type, mergedMetadata),
      actions: _actionsForType(type, card.actions, mergedMetadata),
      metadata: mergedMetadata,
      expandable: true,
      shareable: true,
      savable: type != 'insight',
    );
  }

  List<RenderedCard> _buildTimelineCards(Map<String, dynamic> metadata) {
    final timeline = _firstTimeline(<dynamic>[
      metadata['itineraryTimeline'],
      _nestedValue(metadata, <String>[
        'travelPlan',
        'metadata',
        'itineraryTimeline',
      ]),
      _nestedValue(metadata, <String>[
        'planner',
        'metadata',
        'itineraryTimeline',
      ]),
    ]);
    final timelineMap = _normalizeMap(timeline);
    final days = timelineMap['days'];
    if (days is! Map || days.isEmpty) {
      return const <RenderedCard>[];
    }

    final dayNumbers =
        days.keys
            .map((key) => int.tryParse(key.toString()) ?? 0)
            .where((day) => day > 0)
            .toList(growable: false)
          ..sort();

    return dayNumbers
        .map(
          (day) => RenderedCard(
            id: 'timeline-day-$day',
            type: 'timeline',
            title: 'Day $day',
            subtitle: _timelineSubtitle(days[day.toString()] ?? days[day]),
            icon: 'calendar',
            actions: <AICardAction>[
              AICardAction(
                id: 'timeline-day-$day-expand',
                label: 'View timeline',
                actionType: 'expand_timeline',
                payload: <String, dynamic>{'day': day},
              ),
            ],
            metadata: <String, dynamic>{
              ...metadata,
              'day': day,
              'stops': days[day.toString()] ?? days[day],
            },
            expandable: true,
            shareable: true,
            savable: true,
          ),
        )
        .toList(growable: false);
  }

  String _timelineSubtitle(dynamic stops) {
    if (stops is List) {
      return '${stops.length} planned stops';
    }
    return 'Timeline ready';
  }

  List<AICardAction> _actionsForType(
    String type,
    List<AICardAction> existingActions,
    Map<String, dynamic> metadata,
  ) {
    if (existingActions.isNotEmpty) {
      return existingActions;
    }
    return <AICardAction>[
      AICardAction(
        id: '$type-view',
        label: 'View details',
        actionType: 'view_details',
        payload: <String, dynamic>{'cardType': type},
      ),
      if (type == 'destination' || type == 'transport')
        AICardAction(
          id: '$type-open-map',
          label: 'Open map',
          actionType: 'open_map',
          payload: <String, dynamic>{
            'destination': metadata['destination']?.toString() ?? '',
          },
        ),
    ];
  }

  String _resolveCardType(String value) {
    final type = value.trim().toLowerCase();
    if (type == 'destination') return 'destination';
    if (type == 'hotel') return 'hotel';
    if (type == 'restaurant' || type == 'food') return 'restaurant';
    if (type == 'attraction') return 'attraction';
    if (type == 'timeline' || type == 'itinerary') return 'timeline';
    if (type == 'budget') return 'budget';
    if (type == 'transport') return 'transport';
    return 'insight';
  }

  String _iconForType(String type, {required String fallback}) {
    switch (type) {
      case 'destination':
        return 'map-pin';
      case 'hotel':
        return 'hotel';
      case 'restaurant':
        return 'utensils';
      case 'attraction':
        return 'landmark';
      case 'timeline':
        return 'calendar';
      case 'budget':
        return 'wallet';
      case 'transport':
        return 'car';
      default:
        return fallback.trim().isEmpty ? 'sparkles' : fallback;
    }
  }

  String _imageForType(String type, Map<String, dynamic> metadata) {
    final image = metadata['image']?.toString().trim() ?? '';
    if (image.isNotEmpty) {
      return image;
    }
    return metadata['${type}Image']?.toString().trim() ?? '';
  }

  String _titleForType(String type) {
    switch (type) {
      case 'destination':
        return 'Destination';
      case 'hotel':
        return 'Recommended Hotel';
      case 'restaurant':
        return 'Food Recommendation';
      case 'attraction':
        return 'Attraction';
      case 'timeline':
        return 'Itinerary Timeline';
      case 'budget':
        return 'Budget';
      case 'transport':
        return 'Transportation';
      default:
        return 'Insight';
    }
  }

  dynamic _firstTimeline(List<dynamic> values) {
    for (final value in values) {
      final timeline = _normalizeMap(value);
      final days = timeline['days'];
      if (days is Map && days.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  dynamic _nestedValue(Map<String, dynamic> source, List<String> path) {
    dynamic current = source;
    for (final segment in path) {
      final currentMap = _normalizeMap(current);
      if (!currentMap.containsKey(segment)) {
        return null;
      }
      current = currentMap[segment];
    }
    return current;
  }

  String _safeText(String value, {required String fallback}) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? fallback : trimmedValue;
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
