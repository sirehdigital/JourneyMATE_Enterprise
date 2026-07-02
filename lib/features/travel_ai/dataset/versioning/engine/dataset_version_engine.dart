import '../models/dataset_release.dart';
import '../models/dataset_version.dart';
import '../services/dataset_version_service.dart';

class DatasetVersionEngine {
  DatasetVersionEngine({DatasetVersionService? service})
    : _service = service ?? DatasetVersionService();

  final DatasetVersionService _service;

  DatasetVersion? currentVersion([String? datasetId]) {
    return _service.latestVersion(datasetId);
  }

  DatasetVersion install(DatasetVersion version) {
    return _service.installVersion(version);
  }

  DatasetVersion rollback({
    required String datasetId,
    required DatasetVersion fallbackVersion,
  }) {
    return _service.rollbackVersion(
      datasetId: datasetId,
      fallbackVersion: fallbackVersion,
    );
  }

  bool validate({
    required DatasetRelease release,
    required String appVersion,
    String? state,
  }) {
    return _service.validateCompatibility(
      release: release,
      appVersion: appVersion,
      state: state,
    );
  }
}
