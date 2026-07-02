import 'dart:convert';

import 'package:flutter/services.dart';

import 'dataset_validation_service.dart';

class DatasetLoaderService {
  const DatasetLoaderService({
    DatasetValidationService validationService =
        const DatasetValidationService(),
  }) : _validationService = validationService;

  final DatasetValidationService _validationService;

  Future<Map<String, dynamic>> loadLocalDataset({
    String rootPath = 'assets/data/malaysia',
  }) async {
    final country = await loadJsonMap('$rootPath/country.json');
    return <String, dynamic>{
      'country': country,
      'states': await loadJsonList('$rootPath/states'),
      'districts': await loadJsonList('$rootPath/districts'),
      'destinations': await loadJsonList('$rootPath/destinations'),
      'hotels': await loadJsonList('$rootPath/hotels'),
      'restaurants': await loadJsonList('$rootPath/restaurants'),
      'mosques': await loadJsonList('$rootPath/mosques'),
      'airports': await loadJsonList('$rootPath/airports'),
      'transport': await loadJsonList('$rootPath/transport'),
      'events': await loadJsonList('$rootPath/events'),
    };
  }

  Future<Map<String, dynamic>> loadStateDataset(
    String stateId, {
    String rootPath = 'assets/data/malaysia',
  }) async {
    final dataset = await loadLocalDataset(rootPath: rootPath);
    final normalizedStateId = stateId.trim().toLowerCase();

    List<Map<String, dynamic>> filterByState(String key) {
      final records = dataset[key];
      if (records is! List<Map<String, dynamic>>) {
        return const <Map<String, dynamic>>[];
      }
      return records
          .where(
            (record) =>
                record['state']?.toString().trim().toLowerCase() ==
                normalizedStateId,
          )
          .toList(growable: false);
    }

    return <String, dynamic>{
      'country': dataset['country'] ?? const <String, dynamic>{},
      'states': filterByState('states'),
      'districts': filterByState('districts'),
      'destinations': filterByState('destinations'),
      'hotels': filterByState('hotels'),
      'restaurants': filterByState('restaurants'),
      'mosques': filterByState('mosques'),
      'airports': filterByState('airports'),
      'transport': filterByState('transport'),
      'events': filterByState('events'),
    };
  }

  bool validateDataset(Map<String, dynamic> dataset) {
    final country = dataset['country'];
    if (country is Map<String, dynamic> &&
        !_validationService.validateRequiredFields(country, const <String>[
          'id',
          'name',
        ])) {
      return false;
    }

    for (final entry in dataset.entries) {
      final value = entry.value;
      if (value is List<Map<String, dynamic>>) {
        final ids = value.map((record) => record['id']?.toString() ?? '');
        if (!_validationService.validateDuplicateIds(ids)) {
          return false;
        }
        for (final record in value) {
          if (!_validationService.validateRequiredFields(
            record,
            const <String>['id', 'name'],
          )) {
            return false;
          }
          final latitude = _toDouble(record['latitude']);
          final longitude = _toDouble(record['longitude']);
          if (!_validationService.validateCoordinates(latitude, longitude)) {
            return false;
          }
        }
      }
    }

    return true;
  }

  Map<String, dynamic> mergeDatasets(
    Map<String, dynamic> baseDataset,
    Map<String, dynamic> updateDataset,
  ) {
    final merged = Map<String, dynamic>.from(baseDataset);

    for (final entry in updateDataset.entries) {
      final existingValue = merged[entry.key];
      final updateValue = entry.value;
      if (existingValue is List && updateValue is List) {
        merged[entry.key] = <dynamic>[...existingValue, ...updateValue];
      } else if (existingValue is Map && updateValue is Map) {
        merged[entry.key] = <String, dynamic>{
          ..._normalizeMap(existingValue),
          ..._normalizeMap(updateValue),
        };
      } else {
        merged[entry.key] = updateValue;
      }
    }

    return Map<String, dynamic>.unmodifiable(merged);
  }

  Future<Map<String, dynamic>> loadJsonMap(String assetPath) async {
    try {
      final rawJson = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(rawJson);
      return _normalizeMap(decoded);
    } catch (_) {
      return const <String, dynamic>{};
    }
  }

  Future<List<Map<String, dynamic>>> loadJsonList(String directoryPath) async {
    try {
      final manifestRawJson = await rootBundle.loadString('AssetManifest.json');
      final manifest = _normalizeMap(jsonDecode(manifestRawJson));
      final paths = manifest.keys
          .where(
            (path) => path.startsWith('$directoryPath/') && path.endsWith('.json'),
          )
          .toList(growable: false)
        ..sort();

      final records = <Map<String, dynamic>>[];
      for (final path in paths) {
        final decoded = await loadJsonMap(path);
        if (decoded.isNotEmpty) {
          records.add(decoded);
        }
      }
      return List<Map<String, dynamic>>.unmodifiable(records);
    } catch (_) {
      return const <Map<String, dynamic>>[];
    }
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? 0;
    return 0;
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
