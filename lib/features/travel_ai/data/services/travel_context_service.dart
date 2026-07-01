import '../../domain/entities/travel_context.dart';
import '../../domain/enums/travel_style.dart';
import '../../domain/enums/transport_mode.dart';

class TravelContextService {
  TravelContextService._();

  static TravelContext buildContext(String prompt) {
    final normalized = prompt.toLowerCase();

    return TravelContext(
      destination: _extractDestination(normalized),
      origin: _extractOrigin(normalized),
      travellers: _extractTravellers(normalized),
      durationDays: _extractDurationDays(normalized),
      budget: _extractBudget(normalized),
      departureDate: _extractDepartureDate(normalized),
      returnDate: _extractReturnDate(normalized),
      travelStyle: _extractTravelStyle(normalized),
      transportMode: _extractTransportMode(normalized),
      language: _extractLanguage(normalized),
      muslimFriendly: _isMuslimFriendly(normalized),
      wheelchairAccess: _isWheelchairAccess(normalized),
      familyFriendly: _isFamilyFriendly(normalized),
      kidsFriendly: _isKidsFriendly(normalized),
      rawPrompt: prompt,
    );
  }

  static String? _extractDestination(String text) {
    final patterns = [
      RegExp(r'to ([a-zA-Z ]{3,30})'),
      RegExp(r'in ([a-zA-Z ]{3,30})'),
      RegExp(r'for ([a-zA-Z ]{3,30})'),
      RegExp(r'destination is ([a-zA-Z ]{3,30})'),
    ];

    return _extractFirstValue(text, patterns);
  }

  static String? _extractOrigin(String text) {
    final patterns = [
      RegExp(r'from ([a-zA-Z ]{3,30})'),
      RegExp(r'leaving ([a-zA-Z ]{3,30})'),
      RegExp(r'departing from ([a-zA-Z ]{3,30})'),
      RegExp(r'origin is ([a-zA-Z ]{3,30})'),
    ];

    return _extractFirstValue(text, patterns);
  }

  static int? _extractTravellers(String text) {
    final match = RegExp(
      r'(\d{1,2})\s*(?:people|persons|travellers|travelers|guests)',
    ).firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }
    return null;
  }

  static int? _extractDurationDays(String text) {
    final match = RegExp(
      r'(\d{1,2})\s*(?:days|day|nights|night)',
    ).firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }
    return null;
  }

  static double? _extractBudget(String text) {
    final match = RegExp(
      r'(\d+[\d,.]*)\s*(?:rm|ringgit|myr|usd|dollars|bucks)?',
    ).firstMatch(text);
    if (match != null) {
      final raw = match.group(1)?.replaceAll(',', '');
      if (raw != null) {
        return double.tryParse(raw);
      }
    }
    return null;
  }

  static DateTime? _extractDepartureDate(String text) {
    final match = RegExp(
      r'depart(?:ure|ing)?(?: date)?\s*(?:is|:)?\s*([0-9]{1,2}/[0-9]{1,2}/[0-9]{2,4})',
    ).firstMatch(text);
    if (match != null) {
      return _parseDate(match.group(1)!);
    }
    return null;
  }

  static DateTime? _extractReturnDate(String text) {
    final match = RegExp(
      r'return(?: date)?\s*(?:is|:)?\s*([0-9]{1,2}/[0-9]{1,2}/[0-9]{2,4})',
    ).firstMatch(text);
    if (match != null) {
      return _parseDate(match.group(1)!);
    }
    return null;
  }

  static TravelStyle _extractTravelStyle(String text) {
    if (_containsAny(text, [
      'solo',
      'alone',
      'single traveler',
      'single traveller',
    ])) {
      return TravelStyle.solo;
    }
    if (_containsAny(text, ['couple', 'husband', 'wife', 'partner'])) {
      return TravelStyle.couple;
    }
    if (_containsAny(text, ['family', 'kids', 'children', 'parents'])) {
      return TravelStyle.family;
    }
    if (_containsAny(text, ['friends', 'group', 'buddy', 'buddies'])) {
      return TravelStyle.friends;
    }
    if (_containsAny(text, [
      'business',
      'meeting',
      'conference',
      'work trip',
    ])) {
      return TravelStyle.business;
    }
    if (_containsAny(text, [
      'luxury',
      'premium',
      'five star',
      '5 star',
      'high end',
    ])) {
      return TravelStyle.luxury;
    }
    if (_containsAny(text, [
      'backpacker',
      'budget backpacking',
      'hostel',
      'backpack',
    ])) {
      return TravelStyle.backpacker;
    }
    return TravelStyle.unknown;
  }

  static TransportMode _extractTransportMode(String text) {
    if (_containsAny(text, ['flight', 'plane', 'airfare', 'airline'])) {
      return TransportMode.flight;
    }
    if (_containsAny(text, [
      'car',
      'drive',
      'driving',
      'rental car',
      'taxi',
      'uber',
      'grab',
    ])) {
      return TransportMode.car;
    }
    if (_containsAny(text, [
      'train',
      'rail',
      'express train',
      'commuter train',
    ])) {
      return TransportMode.train;
    }
    if (_containsAny(text, ['bus', 'coach', 'shuttle'])) {
      return TransportMode.bus;
    }
    if (_containsAny(text, ['ferry', 'boat', 'sea'])) {
      return TransportMode.ferry;
    }
    if (_containsAny(text, ['walk', 'walking', 'foot', 'hike'])) {
      return TransportMode.walking;
    }
    if (_containsAny(text, ['mixed', 'multi', 'combine', 'combination'])) {
      return TransportMode.mixed;
    }
    return TransportMode.unknown;
  }

  static String? _extractLanguage(String text) {
    final patterns = [
      RegExp(r'language\s*(?:is|:)?\s*([a-zA-Z]{2,20})'),
      RegExp(r'([a-zA-Z]{2,20})\s*language'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)?.trim().toLowerCase();
      }
    }
    return null;
  }

  static bool _isMuslimFriendly(String text) {
    return _containsAny(text, [
      'muslim friendly',
      'halal',
      'halal food',
      'prayer',
      'mosque',
    ]);
  }

  static bool _isWheelchairAccess(String text) {
    return _containsAny(text, [
      'wheelchair',
      'accessible',
      'wheelchair access',
      'disabled access',
    ]);
  }

  static bool _isFamilyFriendly(String text) {
    return _containsAny(text, [
      'family friendly',
      'family-friendly',
      'kids friendly',
      'child friendly',
      'children friendly',
    ]);
  }

  static bool _isKidsFriendly(String text) {
    return _containsAny(text, [
      'kids friendly',
      'kids-friendly',
      'child friendly',
      'children friendly',
    ]);
  }

  static String? _extractFirstValue(String text, List<RegExp> patterns) {
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final value = match.group(1)?.trim();
        if (value != null && value.isNotEmpty) {
          return _normalizeValue(value);
        }
      }
    }
    return null;
  }

  static String _normalizeValue(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .splitMapJoin(
          RegExp(r'\b([a-z])'),
          onMatch: (m) => m.group(1)!.toUpperCase(),
          onNonMatch: (n) => n,
        );
  }

  static DateTime? _parseDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) {
      return null;
    }
    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    var year = int.tryParse(parts[2]);
    if (month == null || day == null || year == null) {
      return null;
    }
    if (year < 100) {
      year += 2000;
    }
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  static bool _containsAny(String text, List<String> patterns) {
    return patterns.any(text.contains);
  }
}
