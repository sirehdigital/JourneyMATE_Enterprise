class AICardTheme {
  AICardTheme({
    this.themeName = 'journeymate-enterprise',
    this.primaryColor = '#2563EB',
    this.accentColor = '#14B8A6',
    this.iconStyle = 'outlined',
    this.layoutStyle = 'stacked',
    Map<String, dynamic>? metadata,
  }) : metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String themeName;
  final String primaryColor;
  final String accentColor;
  final String iconStyle;
  final String layoutStyle;
  final Map<String, dynamic> metadata;

  AICardTheme copyWith({
    String? themeName,
    String? primaryColor,
    String? accentColor,
    String? iconStyle,
    String? layoutStyle,
    Map<String, dynamic>? metadata,
  }) {
    return AICardTheme(
      themeName: themeName ?? this.themeName,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      iconStyle: iconStyle ?? this.iconStyle,
      layoutStyle: layoutStyle ?? this.layoutStyle,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeName': themeName,
      'primaryColor': primaryColor,
      'accentColor': accentColor,
      'iconStyle': iconStyle,
      'layoutStyle': layoutStyle,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory AICardTheme.fromMap(Map<String, dynamic> map) {
    return AICardTheme(
      themeName: map['themeName']?.toString() ?? 'journeymate-enterprise',
      primaryColor: map['primaryColor']?.toString() ?? '#2563EB',
      accentColor: map['accentColor']?.toString() ?? '#14B8A6',
      iconStyle: map['iconStyle']?.toString() ?? 'outlined',
      layoutStyle: map['layoutStyle']?.toString() ?? 'stacked',
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
