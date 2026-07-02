class ResponseTheme {
  ResponseTheme({
    this.primaryColor = '#2563EB',
    this.accentColor = '#14B8A6',
    this.iconStyle = 'outlined',
    this.typographyStyle = 'enterprise',
    Map<String, dynamic>? metadata,
  }) : metadata = Map<String, dynamic>.unmodifiable(
         metadata ?? const <String, dynamic>{},
       );

  final String primaryColor;
  final String accentColor;
  final String iconStyle;
  final String typographyStyle;
  final Map<String, dynamic> metadata;

  ResponseTheme copyWith({
    String? primaryColor,
    String? accentColor,
    String? iconStyle,
    String? typographyStyle,
    Map<String, dynamic>? metadata,
  }) {
    return ResponseTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      iconStyle: iconStyle ?? this.iconStyle,
      typographyStyle: typographyStyle ?? this.typographyStyle,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'primaryColor': primaryColor,
      'accentColor': accentColor,
      'iconStyle': iconStyle,
      'typographyStyle': typographyStyle,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  factory ResponseTheme.fromMap(Map<String, dynamic> map) {
    return ResponseTheme(
      primaryColor: map['primaryColor']?.toString() ?? '#2563EB',
      accentColor: map['accentColor']?.toString() ?? '#14B8A6',
      iconStyle: map['iconStyle']?.toString() ?? 'outlined',
      typographyStyle: map['typographyStyle']?.toString() ?? 'enterprise',
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
