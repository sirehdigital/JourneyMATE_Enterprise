import 'ai_card.dart';

class CardResponse {
  CardResponse({
    required this.markdown,
    List<AICard>? cards,
    Map<String, dynamic>? metadata,
  }) : cards = List<AICard>.unmodifiable(cards ?? const <AICard>[]),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String markdown;
  final List<AICard> cards;
  final Map<String, dynamic> metadata;

  CardResponse copyWith({
    String? markdown,
    List<AICard>? cards,
    Map<String, dynamic>? metadata,
  }) {
    return CardResponse(
      markdown: markdown ?? this.markdown,
      cards: cards ?? this.cards,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'markdown': markdown,
      'cards': cards.map((card) => card.toMap()).toList(growable: false),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory CardResponse.fromMap(Map<String, dynamic> map) {
    return CardResponse(
      markdown: map['markdown']?.toString() ?? '',
      cards: _parseCards(map['cards']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static List<AICard> _parseCards(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) => AICard.fromMap(
              item.map<String, dynamic>(
                (dynamic key, dynamic entry) =>
                    MapEntry<String, dynamic>(key.toString(), entry),
              ),
            ),
          )
          .toList(growable: false);
    }
    return const <AICard>[];
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
