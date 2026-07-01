import 'routing_result.dart';
import 'routing_rules.dart';

/// Responsible for routing user prompts to the appropriate AI agents.
class AIRouter {
  AIRouter({RoutingRules? rules}) : _rules = rules ?? RoutingRules();

  final RoutingRules _rules;

  /// Routes the given [prompt] and returns the routing decision.
  RoutingResult route({required String prompt}) {
    final normalized = _normalizePrompt(prompt);
    final selectedAgents = _rules.resolveAgents(normalized);
    final matchedKeywords = _rules.resolveMatchedKeywords(normalized);
    final reasoning = _buildReasoning(matchedKeywords);
    final confidence = _estimateConfidence(
      selectedAgents.length,
      matchedKeywords,
    );

    return RoutingResult(
      matchedIntent: _deriveMatchedIntent(matchedKeywords),
      selectedAgents: selectedAgents..sort(),
      confidence: confidence,
      reasoning: reasoning,
    );
  }

  String _normalizePrompt(String prompt) {
    final cleaned = prompt.trim().toLowerCase();
    return cleaned.replaceAll(RegExp(r'\s+'), ' ');
  }

  String _deriveMatchedIntent(List<String> matchedKeywords) {
    if (matchedKeywords.isEmpty) {
      return 'Unknown';
    }

    const priorityOrder = [
      'flight',
      'hotel',
      'budget',
      'destination',
      'weather',
      'car',
      'train',
      'bus',
      'grab',
      'taxi',
      'hospital',
      'police',
      'emergency',
      'clinic',
      'passport',
    ];

    for (final keyword in priorityOrder) {
      if (matchedKeywords.contains(keyword)) {
        return _intentLabelForKeyword(keyword);
      }
    }

    return matchedKeywords.first;
  }

  String _intentLabelForKeyword(String keyword) {
    switch (keyword) {
      case 'flight':
      case 'plane':
      case 'airline':
      case 'airport':
        return 'Flight';
      case 'hotel':
      case 'resort':
      case 'homestay':
      case 'room':
        return 'Accommodation';
      case 'budget':
      case 'cheap':
      case 'cost':
      case 'expense':
      case 'money':
        return 'Budget';
      case 'visit':
      case 'attraction':
      case 'place':
      case 'destination':
        return 'Destination';
      case 'weather':
      case 'rain':
      case 'temperature':
      case 'forecast':
        return 'Weather';
      case 'car':
      case 'train':
      case 'bus':
      case 'grab':
      case 'taxi':
        return 'Transport';
      case 'hospital':
      case 'police':
      case 'emergency':
      case 'clinic':
      case 'passport':
        return 'Emergency';
      default:
        return keyword.capitalize();
    }
  }

  double _estimateConfidence(int agentCount, List<String> matchedKeywords) {
    if (matchedKeywords.isEmpty || agentCount.isZero) {
      return 0.0;
    }

    final score = matchedKeywords.length / (matchedKeywords.length + 1);
    return score.clamp(0.0, 1.0);
  }

  String _buildReasoning(List<String> matchedKeywords) {
    if (matchedKeywords.isEmpty) {
      return 'No routing keywords detected.';
    }

    final sortedKeywords = List<String>.from(matchedKeywords)..sort();
    final phrase = sortedKeywords.join(' + ');
    return 'Detected $phrase keyword${sortedKeywords.length == 1 ? '' : 's'}.';
  }
}

extension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
