import 'response_block.dart';

class ResponseSection {
  ResponseSection({
    required this.title,
    this.subtitle = '',
    List<ResponseBlock>? blocks,
    Map<String, dynamic>? metadata,
  }) : blocks = List<ResponseBlock>.unmodifiable(
         blocks ?? const <ResponseBlock>[],
       ),
       metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String title;
  final String subtitle;
  final List<ResponseBlock> blocks;
  final Map<String, dynamic> metadata;

  ResponseSection copyWith({
    String? title,
    String? subtitle,
    List<ResponseBlock>? blocks,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseSection(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      blocks: blocks ?? this.blocks,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'blocks': blocks.map((block) => block.toMap()).toList(growable: false),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ResponseSection.fromMap(Map<String, dynamic> map) {
    return ResponseSection(
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      blocks: _parseBlocks(map['blocks']),
      metadata: _normalizeMap(map['metadata']),
    );
  }

  static List<ResponseBlock> _parseBlocks(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) => ResponseBlock.fromMap(
              item.map<String, dynamic>(
                (dynamic key, dynamic entry) =>
                    MapEntry<String, dynamic>(key.toString(), entry),
              ),
            ),
          )
          .toList(growable: false);
    }
    return const <ResponseBlock>[];
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
