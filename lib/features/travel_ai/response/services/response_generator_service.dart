import '../models/response_block.dart';
import '../models/response_document.dart';
import '../models/response_section.dart';
import '../models/response_theme.dart';

class ResponseGeneratorService {
  ResponseGeneratorService();

  ResponseDocument generateDocument({
    String title = 'JourneyMATE AI Brain',
    String summary = '',
    String recommendationSummary = '',
    String travelPlanSummary = '',
    String reasoningSummary = '',
    String explanationSummary = '',
    double confidence = 0,
    ResponseTheme? theme,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    try {
      final resolvedTheme = theme ?? ResponseTheme();
      final resolvedMetadata = <String, dynamic>{
        ..._normalizeMap(metadata),
        'confidence': _safeConfidence(confidence),
        'theme': resolvedTheme.toMap(),
        'formats': const <String>[
          'markdown',
          'plainText',
          'richCards',
          'json',
          'voiceSummary',
        ],
      };

      final sections = _buildConciergeSections(
        recommendationSummary: recommendationSummary,
        travelPlanSummary: travelPlanSummary,
        reasoningSummary: reasoningSummary,
        explanationSummary: explanationSummary,
        confidence: confidence,
        metadata: resolvedMetadata,
      );

      return ResponseDocument(
        title: _safeText(title, fallback: 'JourneyMATE AI Brain'),
        summary: generateTravelSummary(
          summary: summary,
          recommendationSummary: recommendationSummary,
          travelPlanSummary: travelPlanSummary,
          confidence: confidence,
        ),
        sections: sections,
        footer: buildFooter(confidence: confidence),
        generatedAt: generatedAt,
        metadata: resolvedMetadata,
      );
    } catch (error) {
      return _fallbackDocument(error);
    }
  }

  String generateTravelSummary({
    String summary = '',
    String recommendationSummary = '',
    String travelPlanSummary = '',
    double confidence = 0,
  }) {
    try {
      final explicitSummary = summary.trim();
      if (explicitSummary.isNotEmpty) {
        return explicitSummary;
      }

      final recommendation = recommendationSummary.trim();
      final plan = travelPlanSummary.trim();
      if (recommendation.isNotEmpty && plan.isNotEmpty) {
        return '$recommendation $plan';
      }
      if (recommendation.isNotEmpty) {
        return recommendation;
      }
      if (plan.isNotEmpty) {
        return plan;
      }

      final confidencePercent = (_safeConfidence(confidence) * 100)
          .toStringAsFixed(0);
      return 'JourneyMATE has prepared a concise travel concierge response '
          'with $confidencePercent% confidence.';
    } catch (_) {
      return 'JourneyMATE generated a structured travel response.';
    }
  }

  ResponseSection generateRecommendationSection(String content) {
    return _buildSingleBlockSection(
      title: '📍 Destination',
      subtitle: '',
      blockId: 'recommendation-summary',
      blockType: 'destination',
      blockTitle: '',
      content: content,
      icon: 'map-pin',
      priority: 10,
    );
  }

  ResponseSection generatePlannerSection(String content) {
    return _buildSingleBlockSection(
      title: '📅 Suggested Itinerary',
      subtitle: '',
      blockId: 'travel-plan-summary',
      blockType: 'itinerary',
      blockTitle: '',
      content: content,
      icon: 'calendar',
      priority: 20,
    );
  }

  ResponseSection generateReasoningSection(String content) {
    return _buildSingleBlockSection(
      title: '💡 Why This Recommendation',
      subtitle: '',
      blockId: 'reasoning-summary',
      blockType: 'reasoning',
      blockTitle: '',
      content: content,
      icon: 'lightbulb',
      priority: 30,
    );
  }

  ResponseSection generateExplanationSection(String content) {
    return _buildSingleBlockSection(
      title: '💡 Why This Recommendation',
      subtitle: '',
      blockId: 'explanation-summary',
      blockType: 'explanation',
      blockTitle: '',
      content: content,
      icon: 'lightbulb',
      priority: 40,
    );
  }

  String buildFooter({double confidence = 0}) {
    try {
      final confidencePercent = (_safeConfidence(confidence) * 100)
          .toStringAsFixed(0);
      return '⭐ Confidence: $confidencePercent%';
    } catch (_) {
      return '⭐ Confidence: 0%';
    }
  }

  String exportMarkdown(ResponseDocument document) {
    try {
      final buffer = StringBuffer()
        ..writeln('# ${_safeText(document.title)}')
        ..writeln();

      if (document.summary.trim().isNotEmpty) {
        buffer
          ..writeln(document.summary.trim())
          ..writeln();
      }

      for (final section in document.sections) {
        buffer
          ..writeln('## ${_safeText(section.title)}')
          ..writeln();

        if (section.subtitle.trim().isNotEmpty) {
          buffer
            ..writeln(section.subtitle.trim())
            ..writeln();
        }

        final blocks = List<ResponseBlock>.from(section.blocks)
          ..sort((left, right) => left.priority.compareTo(right.priority));

        for (final block in blocks) {
          if (block.title.trim().isNotEmpty) {
            buffer.writeln('### ${block.title.trim()}');
          }
          final content = block.content.trim();
          if (content.isNotEmpty) {
            buffer
              ..writeln(content)
              ..writeln();
          }
        }
      }

      if (document.footer.trim().isNotEmpty) {
        buffer
          ..writeln('---')
          ..writeln(document.footer.trim());
      }

      return buffer.toString().trim();
    } catch (_) {
      return '# JourneyMATE AI Brain\n\nUnable to export markdown response.';
    }
  }

  String exportPlainText(ResponseDocument document) {
    try {
      final buffer = StringBuffer()
        ..writeln(_safeText(document.title))
        ..writeln();

      if (document.summary.trim().isNotEmpty) {
        buffer
          ..writeln(document.summary.trim())
          ..writeln();
      }

      for (final section in document.sections) {
        buffer
          ..writeln(_safeText(section.title))
          ..writeln();

        for (final block in section.blocks) {
          if (block.title.trim().isNotEmpty) {
            buffer.writeln('${block.title.trim()}:');
          }
          final content = block.content.trim();
          if (content.isNotEmpty) {
            buffer
              ..writeln(content)
              ..writeln();
          }
        }
      }

      if (document.footer.trim().isNotEmpty) {
        buffer.writeln(document.footer.trim());
      }

      return buffer.toString().trim();
    } catch (_) {
      return 'JourneyMATE AI Brain\n\nUnable to export plain text response.';
    }
  }

  ResponseSection _buildSingleBlockSection({
    required String title,
    required String subtitle,
    required String blockId,
    required String blockType,
    required String blockTitle,
    required String content,
    required String icon,
    required int priority,
  }) {
    try {
      return ResponseSection(
        title: title,
        subtitle: subtitle,
        blocks: <ResponseBlock>[
          ResponseBlock(
            id: blockId,
            type: blockType,
            title: blockTitle,
            content: _safeText(content),
            icon: icon,
            priority: priority,
          ),
        ],
        metadata: <String, dynamic>{'priority': priority},
      );
    } catch (_) {
      return ResponseSection(
        title: title,
        subtitle: subtitle,
        blocks: <ResponseBlock>[
          ResponseBlock(
            id: blockId,
            type: blockType,
            title: blockTitle,
            content: 'No response content is available.',
            icon: icon,
            priority: priority,
          ),
        ],
      );
    }
  }

  List<ResponseSection> _buildConciergeSections({
    required String recommendationSummary,
    required String travelPlanSummary,
    required String reasoningSummary,
    required String explanationSummary,
    required double confidence,
    required Map<String, dynamic> metadata,
  }) {
    final sections = <ResponseSection>[];

    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '📍 Destination',
        blockId: 'destination',
        blockType: 'destination',
        content: _firstAvailableText(<dynamic>[
          metadata['destination'],
          metadata['destinationSummary'],
          recommendationSummary,
        ]),
        icon: 'map-pin',
        priority: 10,
      ),
    );
    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '🏨 Recommended Hotel',
        blockId: 'recommended-hotel',
        blockType: 'hotel',
        content: _firstAvailableText(<dynamic>[
          metadata['recommendedHotel'],
          metadata['hotelSummary'],
          metadata['hotel'],
        ]),
        icon: 'hotel',
        priority: 20,
      ),
    );
    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '🍽 Food Recommendation',
        blockId: 'food-recommendation',
        blockType: 'restaurant',
        content: _firstAvailableText(<dynamic>[
          metadata['foodRecommendation'],
          metadata['restaurantSummary'],
          metadata['food'],
        ]),
        icon: 'utensils',
        priority: 30,
      ),
    );
    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '🕌 Nearby Mosque',
        blockId: 'nearby-mosque',
        blockType: 'mosque',
        content: _firstAvailableText(<dynamic>[
          metadata['nearbyMosque'],
          metadata['mosqueSummary'],
          metadata['mosque'],
        ]),
        icon: 'landmark',
        priority: 40,
      ),
    );
    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '🚗 Transportation',
        blockId: 'transportation',
        blockType: 'transport',
        content: _firstAvailableText(<dynamic>[
          metadata['transportation'],
          metadata['transportSummary'],
          metadata['transportMode'],
        ]),
        icon: 'car',
        priority: 50,
      ),
    );
    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '📅 Suggested Itinerary',
        blockId: 'suggested-itinerary',
        blockType: 'itinerary',
        content: _firstAvailableText(<dynamic>[
          _extractTimelineMarkdown(metadata),
          metadata['timelineMarkdown'],
          travelPlanSummary,
        ]),
        icon: 'calendar',
        priority: 60,
      ),
    );
    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '💰 Estimated Budget',
        blockId: 'estimated-budget',
        blockType: 'budget',
        content: _firstAvailableText(<dynamic>[
          metadata['estimatedBudget'],
          metadata['budgetSummary'],
          metadata['budget'],
        ]),
        icon: 'wallet',
        priority: 70,
      ),
    );
    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '💡 Why This Recommendation',
        blockId: 'why-this-recommendation',
        blockType: 'reasoning',
        content: _joinAvailableText(<String>[
          reasoningSummary,
          explanationSummary,
        ]),
        icon: 'lightbulb',
        priority: 80,
      ),
    );
    _addSectionIfAvailable(
      sections,
      _buildConciergeSection(
        title: '⭐ Confidence',
        blockId: 'confidence',
        blockType: 'confidence',
        content:
            '${(_safeConfidence(confidence) * 100).toStringAsFixed(0)}% confidence based on the available JourneyMATE AI Brain signals.',
        icon: 'star',
        priority: 90,
      ),
    );

    if (sections.isNotEmpty) {
      return sections;
    }

    return <ResponseSection>[
      _buildConciergeSection(
        title: '📍 Destination',
        blockId: 'destination',
        blockType: 'destination',
        content: 'JourneyMATE is ready to prepare a travel recommendation.',
        icon: 'map-pin',
        priority: 10,
      ),
    ];
  }

  ResponseSection _buildConciergeSection({
    required String title,
    required String blockId,
    required String blockType,
    required String content,
    required String icon,
    required int priority,
  }) {
    return _buildSingleBlockSection(
      title: title,
      subtitle: '',
      blockId: blockId,
      blockType: blockType,
      blockTitle: '',
      content: content,
      icon: icon,
      priority: priority,
    );
  }

  void _addSectionIfAvailable(
    List<ResponseSection> sections,
    ResponseSection section,
  ) {
    final hasContent = section.blocks.any(
      (block) => _hasMeaningfulContent(block.content),
    );
    if (hasContent) {
      sections.add(section);
    }
  }

  String _firstAvailableText(List<dynamic> values) {
    for (final value in values) {
      final text = _valueToDisplayText(value);
      if (_hasMeaningfulContent(text)) {
        return text;
      }
    }
    return '';
  }

  String _joinAvailableText(List<String> values) {
    final parts = values
        .map((value) => value.trim())
        .where(_hasMeaningfulContent)
        .toList(growable: false);
    return parts.join('\n\n');
  }

  String _valueToDisplayText(dynamic value) {
    if (value == null) {
      return '';
    }
    if (value is Iterable) {
      return value
          .map(_valueToDisplayText)
          .where(_hasMeaningfulContent)
          .join('\n');
    }
    if (value is Map) {
      return value.entries
          .where(
            (entry) => _hasMeaningfulContent(entry.value?.toString() ?? ''),
          )
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');
    }
    return value.toString().trim();
  }

  String _extractTimelineMarkdown(Map<String, dynamic> metadata) {
    return _timelineToMarkdown(
      _firstAvailableTimeline(<dynamic>[
        metadata['itineraryTimeline'],
        _nestedValue(metadata, <String>['travelPlan', 'itineraryTimeline']),
        _nestedValue(metadata, <String>[
          'travelPlan',
          'metadata',
          'itineraryTimeline',
        ]),
        _nestedValue(metadata, <String>['planner', 'itineraryTimeline']),
        _nestedValue(metadata, <String>[
          'planner',
          'metadata',
          'itineraryTimeline',
        ]),
        _nestedValue(
          metadata,
          <String>['travelPlanMetadata', 'itineraryTimeline'],
        ),
      ]),
    );
  }

  dynamic _firstAvailableTimeline(List<dynamic> values) {
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
      if (currentMap.isEmpty || !currentMap.containsKey(segment)) {
        return null;
      }
      current = currentMap[segment];
    }
    return current;
  }

  String _timelineToMarkdown(dynamic value) {
    final timeline = _normalizeMap(value);
    if (timeline.isEmpty) {
      return '';
    }

    final days = timeline['days'];
    if (days is! Map) {
      return '';
    }

    final dayNumbers =
        days.keys
            .map((key) => int.tryParse(key.toString()) ?? 0)
            .where((day) => day > 0)
            .toList(growable: false)
          ..sort();

    final buffer = StringBuffer();
    for (final day in dayNumbers) {
      final stops = days[day.toString()] ?? days[day];
      if (stops is! List || stops.isEmpty) {
        continue;
      }

      buffer
        ..writeln('📅 Day $day')
        ..writeln();

      for (final stop in stops) {
        final stopMap = _normalizeMap(stop);
        final title = stopMap['title']?.toString().trim() ?? '';
        if (title.isEmpty) {
          continue;
        }

        final category = _titleCase(
          stopMap['category']?.toString() ?? 'activity',
        );
        final duration = _formatTimelineDuration(stopMap['durationMinutes']);
        final notes = stopMap['description']?.toString().trim() ?? '';

        buffer
          ..writeln('${_formatTimelineStartTime(stopMap)} $title')
          ..writeln('Category: $category')
          ..writeln('Estimated Duration: $duration');

        if (notes.isNotEmpty) {
          buffer.writeln('Notes: $notes');
        }
        buffer.writeln();
      }
    }

    return buffer.toString().trim();
  }

  String _formatTimelineStartTime(Map<String, dynamic> stop) {
    final startTime = stop['startTime']?.toString().trim() ?? '';
    return startTime.isEmpty ? 'Flexible' : startTime;
  }

  String _formatTimelineDuration(dynamic value) {
    final minutes = value is num
        ? value.toInt()
        : int.tryParse(value?.toString() ?? '') ?? 0;
    if (minutes <= 0) {
      return 'Flexible';
    }
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    if (hours > 0 && remainder > 0) {
      return '${hours}h ${remainder}m';
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

  bool _hasMeaningfulContent(String value) {
    final text = value.trim();
    if (text.isEmpty) {
      return false;
    }
    final lowerText = text.toLowerCase();
    return lowerText != 'no insight available.' &&
        lowerText != 'no local insight available.' &&
        lowerText != 'no response content is available.';
  }

  ResponseDocument _fallbackDocument(Object error) {
    return ResponseDocument(
      title: 'JourneyMATE AI Brain',
      summary: 'JourneyMATE generated a safe fallback response.',
      sections: <ResponseSection>[
        generateExplanationSection(
          'The response generator could not format the supplied payload.',
        ),
      ],
      footer: 'Generated by JourneyMATE Intelligent Response Generator.',
      metadata: <String, dynamic>{
        'error': error.toString(),
        'safeFallback': true,
      },
    );
  }

  String _safeText(String value, {String fallback = 'No insight available.'}) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? fallback : trimmedValue;
  }

  double _safeConfidence(double value) {
    return value.clamp(0.0, 1.0).toDouble();
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
