import '../../domain/entities/travel_intent.dart';
import '../../domain/enums/travel_intent_type.dart';

class TravelIntentService {
  TravelIntentService._();

  static TravelIntent detectIntent(String prompt) {
    final normalized = prompt.toLowerCase();

    final type = _detectType(normalized);
    final destination = _extractDestination(normalized);
    final origin = _extractOrigin(normalized);
    final durationDays = _extractDurationDays(normalized);
    final budget = _extractBudget(normalized);
    final travellers = _extractTravellers(normalized);

    return TravelIntent(
      type: type,
      destination: destination,
      origin: origin,
      durationDays: durationDays,
      budget: budget,
      travellers: travellers,
      rawPrompt: prompt,
    );
  }

  static TravelIntentType _detectType(String text) {
    if (_containsAny(text, [
      'emergency',
      'urgent',
      'help now',
      'help me',
      'accident',
      'hospital',
      'lost',
    ])) {
      return TravelIntentType.emergency;
    }

    if (_containsAny(text, [
      'weather',
      'rain',
      'storm',
      'sunny',
      'forecast',
      'temperature',
    ])) {
      return TravelIntentType.weather;
    }

    if (_containsAny(text, [
      'flight',
      'airfare',
      'plane',
      'ticket',
      'boarding',
      'departure',
    ])) {
      return TravelIntentType.flightSearch;
    }

    if (_containsAny(text, [
      'hotel',
      'accommodation',
      'stay',
      'room',
      'resort',
      'hostel',
    ])) {
      return TravelIntentType.hotelSearch;
    }

    if (_containsAny(text, [
      'budget',
      'cost',
      'expense',
      'cheap',
      'affordable',
      'price',
    ])) {
      return TravelIntentType.budgetPlanning;
    }

    if (_containsAny(text, [
      'itinerary',
      'plan my trip',
      'schedule',
      'day 1',
      'day 2',
      'day 3',
    ])) {
      return TravelIntentType.itineraryPlanning;
    }

    if (_containsAny(text, [
      'destination',
      'where to go',
      'travel ideas',
      'trip ideas',
      'discover',
    ])) {
      return TravelIntentType.destinationDiscovery;
    }

    if (_containsAny(text, [
      'food',
      'restaurant',
      'dining',
      'local cuisine',
      'eat',
      'meal',
    ])) {
      return TravelIntentType.foodDiscovery;
    }

    if (_containsAny(text, [
      'transport',
      'taxi',
      'bus',
      'train',
      'uber',
      'grab',
      'car rental',
      'transfer',
    ])) {
      return TravelIntentType.transportation;
    }

    if (_containsAny(text, [
      'trip',
      'travel',
      'vacation',
      'holiday',
      'journey',
    ])) {
      return TravelIntentType.tripPlanning;
    }

    if (_containsAny(text, [
      'hi',
      'hello',
      'hey',
      'what',
      'how',
      'can you',
      'tell me',
    ])) {
      return TravelIntentType.generalChat;
    }

    return TravelIntentType.unknown;
  }

  static String? _extractDestination(String text) {
    final patterns = [
      RegExp(r' to ([a-zA-Z ]{3,30})'),
      RegExp(r'in ([a-zA-Z ]{3,30})'),
      RegExp(r'for ([a-zA-Z ]{3,30})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final value = match.group(1)?.trim();
        if (value != null && !_isCommonWord(value)) {
          return _capitalize(value);
        }
      }
    }

    return null;
  }

  static String? _extractOrigin(String text) {
    final patterns = [
      RegExp(r'from ([a-zA-Z ]{3,30})'),
      RegExp(r'leaving ([a-zA-Z ]{3,30})'),
      RegExp(r'departing ([a-zA-Z ]{3,30})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final value = match.group(1)?.trim();
        if (value != null && !_isCommonWord(value)) {
          return _capitalize(value);
        }
      }
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
      r'([\d,.]+)\s*(?:rm|usd|eur|sgd|myr|dollars|bucks|ringgit)?',
    ).firstMatch(text);
    if (match != null) {
      final raw = match.group(1)?.replaceAll(',', '');
      if (raw != null) {
        return double.tryParse(raw);
      }
    }
    return null;
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

  static bool _containsAny(String text, List<String> candidates) {
    return candidates.any((keyword) => text.contains(keyword));
  }

  static bool _isCommonWord(String value) {
    const commonWords = {
      'please',
      'help',
      'me',
      'the',
      'a',
      'an',
      'my',
      'your',
      'ticket',
      'hotel',
      'flight',
      'trip',
      'travel',
      'plan',
      'from',
      'to',
      'in',
      'for',
    };
    return commonWords.contains(value.toLowerCase());
  }

  static String _capitalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed
        .split(' ')
        .map((part) {
          if (part.isEmpty) return part;
          return part[0].toUpperCase() + part.substring(1);
        })
        .join(' ');
  }
}
