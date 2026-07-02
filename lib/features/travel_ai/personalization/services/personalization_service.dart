import '../models/personalization_profile.dart';
import '../models/personalization_score.dart';
import '../models/user_preference.dart';

class PersonalizationService {
  const PersonalizationService();

  PersonalizationProfile buildProfile({
    String userId = 'default-user',
    List<UserPreference> preferences = const <UserPreference>[],
    List<String> favouriteDestinations = const <String>[],
    List<String> favouriteTravelStyles = const <String>[],
    String preferredBudgetRange = 'moderate',
  }) {
    return PersonalizationProfile(
      userId: userId,
      preferences: preferences,
      favouriteDestinations: favouriteDestinations,
      favouriteTravelStyles: favouriteTravelStyles,
      preferredBudgetRange: preferredBudgetRange,
      profileVersion: 1,
      lastUpdated: DateTime.now(),
      metadata: <String, dynamic>{'source': 'local-personalization-engine'},
    );
  }

  List<UserPreference> updatePreferences(
    List<UserPreference> current,
    List<UserPreference> incoming,
  ) {
    if (incoming.isEmpty) {
      return current;
    }

    final merged = <UserPreference>[];
    final byId = <String, UserPreference>{
      for (final preference in current) preference.id: preference,
    };

    for (final preference in incoming) {
      byId[preference.id] = preference;
    }

    merged.addAll(byId.values);
    return merged;
  }

  List<String> analyzeBehaviour(List<UserPreference> preferences) {
    if (preferences.isEmpty) {
      return const <String>[];
    }

    final insights = <String>{};
    for (final preference in preferences) {
      if (preference.confidence > 0.5) {
        insights.add('${preference.category}:${preference.value}');
      }
    }
    return insights.toList(growable: false);
  }

  PersonalizationScore calculateScore({
    required String destination,
    required double budget,
    required String travelStyle,
    required List<UserPreference> preferences,
  }) {
    final destinationMatch = _scorePreference(
      preferences,
      'destination',
      destination,
    );
    final budgetMatch = _scorePreference(
      preferences,
      'budget',
      budget > 1000 ? 'high' : 'moderate',
    );
    final travelStyleMatch = _scorePreference(
      preferences,
      'travelStyle',
      travelStyle,
    );
    final accommodationMatch = _scorePreference(
      preferences,
      'accommodation',
      'hotel',
    );
    final transportMatch = _scorePreference(
      preferences,
      'transport',
      'airport',
    );

    final overallScore =
        (destinationMatch +
            budgetMatch +
            travelStyleMatch +
            accommodationMatch +
            transportMatch) /
        5;
    final confidence = overallScore.clamp(0.0, 1.0);

    return PersonalizationScore(
      destinationMatch: destinationMatch,
      budgetMatch: budgetMatch,
      travelStyleMatch: travelStyleMatch,
      accommodationMatch: accommodationMatch,
      transportMatch: transportMatch,
      overallScore: overallScore,
      confidence: confidence,
    );
  }

  List<String> recommendAdjustments(List<UserPreference> preferences) {
    if (preferences.isEmpty) {
      return const <String>[];
    }

    return preferences
        .where((preference) => preference.confidence < 0.7)
        .map(
          (preference) =>
              'Consider refining ${preference.category}:${preference.value}',
        )
        .toList(growable: false);
  }

  String summarizeProfile(PersonalizationProfile profile) {
    if (profile.preferences.isEmpty) {
      return 'No personalization profile available.';
    }

    return 'Profile for ${profile.userId} with ${profile.preferences.length} preferences and ${profile.favouriteDestinations.length} favourite destinations.';
  }

  double _scorePreference(
    List<UserPreference> preferences,
    String category,
    String value,
  ) {
    final match = preferences
        .where(
          (preference) =>
              preference.category == category && preference.value == value,
        )
        .toList(growable: false);
    if (match.isEmpty) {
      return 0.5;
    }
    return (match.first.confidence * match.first.weight).clamp(0.0, 1.0);
  }
}
