import '../agents/base/agent_result.dart';
import 'composed_response.dart';
import 'response_section.dart';

/// Responsible for composing multiple [AgentResult] objects into a single
/// JourneyMATE structured response.
class ResponseComposer {
  /// Composes a list of [AgentResult] values into a unified response.
  ComposedResponse compose({required List<AgentResult> results}) {
    final successfulResults = results
        .where((result) => result.success)
        .toList();

    if (successfulResults.isEmpty) {
      return ComposedResponse(
        title: 'JourneyMATE Travel Plan',
        summary: 'No actionable results were available to compose.',
        sections: const [],
        generatedAt: DateTime.now(),
      );
    }

    successfulResults.sort((left, right) {
      final leftPriority = left.metadata['priority'] as int? ?? 0;
      final rightPriority = right.metadata['priority'] as int? ?? 0;
      return leftPriority.compareTo(rightPriority);
    });

    final sections = successfulResults
        .map(_mapResultToSection)
        .where((section) => section != null)
        .cast<ResponseSection>()
        .toList();

    final summary = _generateSummary(sections);
    final metadata = {
      'sectionCount': sections.length,
      'generatedAt': DateTime.now().toIso8601String(),
    };

    return ComposedResponse(
      title: 'JourneyMATE Travel Plan',
      summary: summary,
      sections: sections,
      generatedAt: DateTime.now(),
      metadata: metadata,
    );
  }

  ResponseSection? _mapResultToSection(AgentResult result) {
    final type = _resolveSectionType(result.agentId);
    if (type == null) {
      return null;
    }

    return ResponseSection(
      title: type.title,
      icon: type.icon,
      priority: type.priority,
      content: result.message,
      metadata: result.metadata,
    );
  }

  _SectionType? _resolveSectionType(String agentId) {
    switch (agentId) {
      case 'FlightAgent':
      case 'flight_agent':
        return const _SectionType(title: '✈ Flights', icon: '✈', priority: 10);
      case 'HotelAgent':
      case 'hotel_agent':
        return const _SectionType(title: '🏨 Hotels', icon: '🏨', priority: 20);
      case 'BudgetAgent':
      case 'budget_agent':
        return const _SectionType(title: '💰 Budget', icon: '💰', priority: 30);
      case 'DestinationAgent':
      case 'destination_agent':
        return const _SectionType(
          title: '📍 Destination',
          icon: '📍',
          priority: 40,
        );
      case 'WeatherAgent':
      case 'weather_agent':
        return const _SectionType(
          title: '🌦 Weather',
          icon: '🌦',
          priority: 50,
        );
      case 'TransportAgent':
      case 'transport_agent':
        return const _SectionType(
          title: '🚗 Transport',
          icon: '🚗',
          priority: 60,
        );
      case 'EmergencyAgent':
      case 'emergency_agent':
        return const _SectionType(
          title: '🚨 Emergency',
          icon: '🚨',
          priority: 70,
        );
      default:
        return null;
    }
  }

  String _generateSummary(List<ResponseSection> sections) {
    if (sections.isEmpty) {
      return 'No successful sections are available in this travel plan.';
    }

    final sectionTitles = sections.map((section) => section.title).toList();
    final joinedTitles = sectionTitles.join(', ');

    return 'This travel plan contains the following sections: $joinedTitles.';
  }
}

class _SectionType {
  const _SectionType({
    required this.title,
    required this.icon,
    required this.priority,
  });

  final String title;
  final String icon;
  final int priority;
}
