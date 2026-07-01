import 'routing_result.dart';

/// Provides keyword-based routing rules for the AI router.
class RoutingRules {
  RoutingRules();

  static const Map<String, List<String>> _ruleMap = {
    'flight': ['FlightAgent'],
    'plane': ['FlightAgent'],
    'airline': ['FlightAgent'],
    'airport': ['FlightAgent'],
    'hotel': ['HotelAgent'],
    'resort': ['HotelAgent'],
    'homestay': ['HotelAgent'],
    'room': ['HotelAgent'],
    'budget': ['BudgetAgent'],
    'cheap': ['BudgetAgent'],
    'cost': ['BudgetAgent'],
    'expense': ['BudgetAgent'],
    'money': ['BudgetAgent'],
    'visit': ['DestinationAgent'],
    'attraction': ['DestinationAgent'],
    'place': ['DestinationAgent'],
    'destination': ['DestinationAgent'],
    'weather': ['WeatherAgent'],
    'rain': ['WeatherAgent'],
    'temperature': ['WeatherAgent'],
    'forecast': ['WeatherAgent'],
    'car': ['TransportAgent'],
    'train': ['TransportAgent'],
    'bus': ['TransportAgent'],
    'grab': ['TransportAgent'],
    'taxi': ['TransportAgent'],
    'hospital': ['EmergencyAgent'],
    'police': ['EmergencyAgent'],
    'emergency': ['EmergencyAgent'],
    'clinic': ['EmergencyAgent'],
    'passport': ['EmergencyAgent'],
  };

  /// Returns the agent ids matching the normalized tokens.
  List<String> resolveAgents(String normalizedPrompt) {
    final tokens = normalizedPrompt.split(' ');
    final agentIds = <String>{};

    for (final token in tokens) {
      final stripped = token.trim();
      if (stripped.isEmpty) {
        continue;
      }

      final matchedAgents = _ruleMap[stripped];
      if (matchedAgents != null) {
        agentIds.addAll(matchedAgents);
      }
    }

    return agentIds.toList();
  }

  /// Returns a human-friendly list of matched keywords for reasoning.
  List<String> resolveMatchedKeywords(String normalizedPrompt) {
    final tokens = normalizedPrompt.split(' ');
    final matchedKeywords = <String>{};

    for (final token in tokens) {
      final stripped = token.trim();
      if (stripped.isEmpty) {
        continue;
      }

      if (_ruleMap.containsKey(stripped)) {
        matchedKeywords.add(stripped);
      }
    }

    return matchedKeywords.toList();
  }
}
