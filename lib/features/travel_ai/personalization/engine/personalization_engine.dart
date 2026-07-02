import '../models/personalization_profile.dart';
import '../models/personalization_score.dart';
import '../models/user_preference.dart';
import '../services/personalization_service.dart';

class PersonalizationEngine {
  PersonalizationEngine({PersonalizationService? service})
    : _service = service ?? const PersonalizationService();

  final PersonalizationService _service;

  PersonalizationProfile generateProfile({
    String userId = 'default-user',
    List<UserPreference> preferences = const <UserPreference>[],
    List<String> favouriteDestinations = const <String>[],
    List<String> favouriteTravelStyles = const <String>[],
    String preferredBudgetRange = 'moderate',
  }) {
    return _service.buildProfile(
      userId: userId,
      preferences: preferences,
      favouriteDestinations: favouriteDestinations,
      favouriteTravelStyles: favouriteTravelStyles,
      preferredBudgetRange: preferredBudgetRange,
    );
  }

  List<String> personalizeRecommendations(List<UserPreference> preferences) {
    return _service.analyzeBehaviour(preferences);
  }

  PersonalizationScore personalizeTravelPlan({
    required String destination,
    required double budget,
    required String travelStyle,
    required List<UserPreference> preferences,
  }) {
    return _service.calculateScore(
      destination: destination,
      budget: budget,
      travelStyle: travelStyle,
      preferences: preferences,
    );
  }

  PersonalizationScore personalizeDestinationRanking({
    required String destination,
    required double budget,
    required String travelStyle,
    required List<UserPreference> preferences,
  }) {
    return _service.calculateScore(
      destination: destination,
      budget: budget,
      travelStyle: travelStyle,
      preferences: preferences,
    );
  }

  PersonalizationProfile getProfile(PersonalizationProfile profile) {
    return profile;
  }

  PersonalizationProfile refreshProfile(PersonalizationProfile profile) {
    return profile.copyWith(
      lastUpdated: DateTime.now(),
      profileVersion: profile.profileVersion + 1,
    );
  }
}
