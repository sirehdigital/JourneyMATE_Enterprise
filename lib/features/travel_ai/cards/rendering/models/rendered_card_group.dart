import 'rendered_card.dart';

class RenderedCardGroup {
  RenderedCardGroup({
    required this.id,
    required this.title,
    this.subtitle = '',
    List<RenderedCard>? cards,
    Map<String, dynamic>? metadata,
  }) : cards = List<RenderedCard>.unmodifiable(cards ?? const <RenderedCard>[]),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String id;
  final String title;
  final String subtitle;
  final List<RenderedCard> cards;
  final Map<String, dynamic> metadata;

  RenderedCardGroup copyWith({
    String? id,
    String? title,
    String? subtitle,
    List<RenderedCard>? cards,
    Map<String, dynamic>? metadata,
  }) {
    return RenderedCardGroup(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      cards: cards ?? this.cards,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'cards': cards.map((card) => card.toMap()).toList(growable: false),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory RenderedCardGroup.fromMap(Map<String, dynamic> map) {
    return RenderedCardGroup(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      cards: _parseCards(map['cards']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static List<RenderedCard> _parseCards(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) => RenderedCard.fromMap(
              item.map<String, dynamic>(
                (dynamic key, dynamic entry) =>
                    MapEntry<String, dynamic>(key.toString(), entry),
              ),
            ),
          )
          .toList(growable: false);
    }
    return const <RenderedCard>[];
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
