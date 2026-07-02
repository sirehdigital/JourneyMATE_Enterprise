import '../../services/dataset_loader_service.dart';
import '../../services/dataset_validation_service.dart';
import '../models/dataset_manifest.dart';
import '../models/dataset_sync_result.dart';

class DatasetSynchronizerService {
  DatasetSynchronizerService({
    DatasetLoaderService? loader,
    DatasetValidationService? validationService,
  }) : _loader = loader ?? const DatasetLoaderService(),
       _validationService = validationService ?? const DatasetValidationService();

  final DatasetLoaderService _loader;
  final DatasetValidationService _validationService;

  Future<DatasetSyncResult> synchronize({
    List<DatasetManifest> localManifests = const <DatasetManifest>[],
    List<DatasetManifest> incomingManifests = const <DatasetManifest>[],
    Map<String, dynamic> localDataset = const <String, dynamic>{},
    Map<String, dynamic> incomingDataset = const <String, dynamic>{},
  }) async {
    try {
      final synchronizedDatasets = <String>[];
      final skippedDatasets = <String>[];
      final failedDatasets = <String>[];

      for (final manifest in incomingManifests) {
        if (!validateManifest(manifest)) {
          failedDatasets.add(manifest.datasetId);
          continue;
        }

        final localManifest = _findManifest(
          localManifests,
          manifest.datasetId,
        );
        if (localManifest == null ||
            compareVersions(manifest.version, localManifest.version) > 0 ||
            manifest.checksum != localManifest.checksum) {
          synchronizedDatasets.add(manifest.datasetId);
        } else {
          skippedDatasets.add(manifest.datasetId);
        }
      }

      final mergedDataset = mergeLocalDataset(localDataset, incomingDataset);
      final validDataset = _loader.validateDataset(mergedDataset);

      return DatasetSyncResult(
        success: failedDatasets.isEmpty && validDataset,
        synchronizedDatasets: synchronizedDatasets,
        skippedDatasets: skippedDatasets,
        failedDatasets: failedDatasets,
        metadata: <String, dynamic>{
          'mode': 'local-only',
          'totalLocalManifests': localManifests.length,
          'totalIncomingManifests': incomingManifests.length,
          'validDataset': validDataset,
        },
      );
    } catch (error) {
      return DatasetSyncResult(
        success: false,
        failedDatasets: const <String>['dataset-synchronizer'],
        metadata: <String, dynamic>{
          'mode': 'local-only',
          'error': error.toString(),
        },
      );
    }
  }

  int compareVersions(String currentVersion, String candidateVersion) {
    try {
      final currentParts = _parseVersion(currentVersion);
      final candidateParts = _parseVersion(candidateVersion);
      final maxLength = currentParts.length > candidateParts.length
          ? currentParts.length
          : candidateParts.length;

      for (var index = 0; index < maxLength; index++) {
        final current = index < currentParts.length ? currentParts[index] : 0;
        final candidate = index < candidateParts.length
            ? candidateParts[index]
            : 0;
        if (current > candidate) return 1;
        if (current < candidate) return -1;
      }
      return 0;
    } catch (_) {
      return currentVersion.compareTo(candidateVersion);
    }
  }

  Map<String, dynamic> mergeLocalDataset(
    Map<String, dynamic> localDataset,
    Map<String, dynamic> incomingDataset,
  ) {
    try {
      return _loader.mergeDatasets(localDataset, incomingDataset);
    } catch (_) {
      return Map<String, dynamic>.unmodifiable(localDataset);
    }
  }

  bool validateManifest(DatasetManifest manifest) {
    try {
      if (manifest.datasetId.trim().isEmpty ||
          manifest.version.trim().isEmpty ||
          manifest.checksum.trim().isEmpty ||
          manifest.totalRecords < 0) {
        return false;
      }

      final coordinates = manifest.metadata['coordinates'];
      if (coordinates is Map) {
        final latitude = _toDouble(coordinates['latitude']);
        final longitude = _toDouble(coordinates['longitude']);
        return _validationService.validateCoordinates(latitude, longitude);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  String generateChecksum(Map<String, dynamic> dataset) {
    try {
      final flattened = _stableString(dataset);
      var hash = 0;
      for (final unit in flattened.codeUnits) {
        hash = 0x1fffffff & (hash + unit);
        hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
        hash ^= hash >> 6;
      }
      hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
      hash ^= hash >> 11;
      hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
      return hash.toRadixString(16).padLeft(8, '0');
    } catch (_) {
      return '00000000';
    }
  }

  DatasetManifest buildManifest({
    required String datasetId,
    required String version,
    required String state,
    required Map<String, dynamic> dataset,
  }) {
    final now = DateTime.now();
    return DatasetManifest(
      datasetId: datasetId,
      version: version,
      state: state,
      checksum: generateChecksum(dataset),
      createdAt: now,
      updatedAt: now,
      totalRecords: _countRecords(dataset),
      metadata: const <String, dynamic>{'mode': 'local-only'},
    );
  }

  DatasetManifest? _findManifest(
    List<DatasetManifest> manifests,
    String datasetId,
  ) {
    for (final manifest in manifests) {
      if (manifest.datasetId == datasetId) {
        return manifest;
      }
    }
    return null;
  }

  List<int> _parseVersion(String version) {
    return version
        .split('.')
        .map((part) => int.tryParse(part.trim()) ?? 0)
        .toList(growable: false);
  }

  int _countRecords(Map<String, dynamic> dataset) {
    var total = 0;
    for (final value in dataset.values) {
      if (value is List) {
        total += value.length;
      } else if (value is Map && value.isNotEmpty) {
        total += 1;
      }
    }
    return total;
  }

  String _stableString(dynamic value) {
    if (value is Map) {
      final keys = value.keys.map((key) => key.toString()).toList()..sort();
      return keys
          .map((key) => '$key:${_stableString(value[key])}')
          .join('|');
    }
    if (value is List) {
      return value.map(_stableString).join(',');
    }
    return value?.toString() ?? '';
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? 0;
    return 0;
  }
}
