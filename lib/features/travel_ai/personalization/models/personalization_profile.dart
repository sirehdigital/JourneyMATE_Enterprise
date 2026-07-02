import 'user_preference.dart';

class PersonalizationProfile {
  const PersonalizationProfile({
    required this.userId,
    required this.preferences,
    required this.favouriteDestinations,
    required this.favouriteTravelStyles,
    required this.preferredBudgetRange,
    required this.profileVersion,
    required this.lastUpdated,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final String userId;
  final List<UserPreference> preferences;
  final List<String> favouriteDestinations;
  final List<String> favouriteTravelStyles;
  final String preferredBudgetRange;
  final int profileVersion;
  final DateTime lastUpdated;
  final Map<String, dynamic> metadata;

  PersonalizationProfile copyWith({
    String? userId,
    List<UserPreference>? preferences,
    List<String>? favouriteDestinations,
    List<String>? favouriteTravelStyles,
    String? preferredBudgetRange,
    int? profileVersion,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) {
    return PersonalizationProfile(
      userId: userId ?? this.userId,
      preferences: preferences ?? this.preferences,
      favouriteDestinations:
          favouriteDestinations ?? this.favouriteDestinations,
      favouriteTravelStyles:
          favouriteTravelStyles ?? this.favouriteTravelStyles,
      preferredBudgetRange: preferredBudgetRange ?? this.preferredBudgetRange,
      profileVersion: profileVersion ?? this.profileVersion,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'preferences': preferences
          .map((preference) => preference.toMap())
          .toList(),
      'favouriteDestinations': favouriteDestinations,
      'favouriteTravelStyles': favouriteTravelStyles,
      'preferredBudgetRange': preferredBudgetRange,
      'profileVersion': profileVersion,
      'lastUpdated': lastUpdated.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory PersonalizationProfile.fromMap(Map<String, dynamic> map) {
    return PersonalizationProfile(
      userId: map['userId']?.toString() ?? '',
      preferences:
          (map['preferences'] as List<dynamic>?)
              ?.map(
                (dynamic item) => UserPreference.fromMap(
                  item is Map<String, dynamic>
                      ? item
                      : Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false) ??
          const <UserPreference>[],
      favouriteDestinations:
          (map['favouriteDestinations'] as List<dynamic>?)
              ?.map((dynamic item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
      favouriteTravelStyles:
          (map['favouriteTravelStyles'] as List<dynamic>?)
              ?.map((dynamic item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
      preferredBudgetRange: map['preferredBudgetRange']?.toString() ?? '',
      profileVersion: (map['profileVersion'] as num?)?.toInt() ?? 0,
      lastUpdated:
          DateTime.tryParse(map['lastUpdated']?.toString() ?? '') ??
          DateTime.now(),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic entry) =>
            MapEntry<String, dynamic>(key.toString(), entry),
      );
    }
    return <String, dynamic>{};
  }
}
