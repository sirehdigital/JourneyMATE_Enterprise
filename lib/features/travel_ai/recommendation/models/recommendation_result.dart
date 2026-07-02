import 'recommendation_item.dart';

class RecommendationResult {
  const RecommendationResult({
    required this.items,
    required this.totalResults,
    required this.generatedAt,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  final List<RecommendationItem> items;
  final int totalResults;
  final DateTime generatedAt;
  final Map<String, dynamic> metadata;

  RecommendationResult copyWith({
    List<RecommendationItem>? items,
    int? totalResults,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return RecommendationResult(
      items: items ?? this.items,
      totalResults: totalResults ?? this.totalResults,
      generatedAt: generatedAt ?? this.generatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((item) => item.toMap()).toList(),
      'totalResults': totalResults,
      'generatedAt': generatedAt.toIso8601String(),
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory RecommendationResult.fromMap(Map<String, dynamic> map) {
    return RecommendationResult(
      items:
          (map['items'] as List<dynamic>?)
              ?.map(
                (dynamic item) => RecommendationItem.fromMap(
                  item is Map<String, dynamic>
                      ? item
                      : Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false) ??
          const <RecommendationItem>[],
      totalResults: map['totalResults'] is int ? map['totalResults'] as int : 0,
      generatedAt:
          DateTime.tryParse(map['generatedAt']?.toString() ?? '') ??
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
