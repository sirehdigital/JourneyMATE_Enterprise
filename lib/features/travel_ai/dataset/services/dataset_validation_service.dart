class DatasetValidationService {
  const DatasetValidationService();

  bool validateCoordinates(double latitude, double longitude) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  bool validateDuplicateIds(Iterable<String> ids) {
    final normalizedIds = ids
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty);
    return normalizedIds.toSet().length == normalizedIds.length;
  }

  bool validateRequiredFields(
    Map<String, dynamic> record,
    List<String> requiredFields,
  ) {
    for (final field in requiredFields) {
      final value = record[field];
      if (value == null || value.toString().trim().isEmpty) {
        return false;
      }
    }
    return true;
  }
}
