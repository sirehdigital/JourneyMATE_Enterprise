import '../models/dataset_manifest.dart';
import '../models/dataset_sync_result.dart';
import '../services/dataset_synchronizer_service.dart';

class DatasetSynchronizerEngine {
  DatasetSynchronizerEngine({DatasetSynchronizerService? service})
    : _service = service ?? DatasetSynchronizerService();

  final DatasetSynchronizerService _service;
  DatasetSyncResult? _lastResult;
  DatasetManifest? _lastManifest;

  Future<DatasetSyncResult> synchronizeAll({
    List<DatasetManifest> localManifests = const <DatasetManifest>[],
    List<DatasetManifest> incomingManifests = const <DatasetManifest>[],
    Map<String, dynamic> localDataset = const <String, dynamic>{},
    Map<String, dynamic> incomingDataset = const <String, dynamic>{},
  }) async {
    _lastResult = await _service.synchronize(
      localManifests: localManifests,
      incomingManifests: incomingManifests,
      localDataset: localDataset,
      incomingDataset: incomingDataset,
    );
    return _lastResult!;
  }

  Future<DatasetSyncResult> synchronizeState({
    required String state,
    List<DatasetManifest> localManifests = const <DatasetManifest>[],
    List<DatasetManifest> incomingManifests = const <DatasetManifest>[],
    Map<String, dynamic> localDataset = const <String, dynamic>{},
    Map<String, dynamic> incomingDataset = const <String, dynamic>{},
  }) async {
    final normalizedState = state.trim().toLowerCase();
    final filteredLocal = localManifests
        .where((manifest) => manifest.state.trim().toLowerCase() == normalizedState)
        .toList(growable: false);
    final filteredIncoming = incomingManifests
        .where((manifest) => manifest.state.trim().toLowerCase() == normalizedState)
        .toList(growable: false);

    _lastResult = await _service.synchronize(
      localManifests: filteredLocal,
      incomingManifests: filteredIncoming,
      localDataset: localDataset,
      incomingDataset: incomingDataset,
    );
    return _lastResult!;
  }

  DatasetManifest getManifest({
    required String datasetId,
    required String version,
    required String state,
    required Map<String, dynamic> dataset,
  }) {
    _lastManifest = _service.buildManifest(
      datasetId: datasetId,
      version: version,
      state: state,
      dataset: dataset,
    );
    return _lastManifest!;
  }

  DatasetSyncResult getStatus() {
    return _lastResult ??
        DatasetSyncResult(
          success: true,
          skippedDatasets: const <String>['not-synchronized'],
          metadata: const <String, dynamic>{
            'mode': 'local-only',
            'status': 'idle',
          },
        );
  }

  DatasetManifest? get lastManifest => _lastManifest;
}
