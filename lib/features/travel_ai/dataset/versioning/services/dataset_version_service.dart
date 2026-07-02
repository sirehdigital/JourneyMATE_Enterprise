import '../models/dataset_release.dart';
import '../models/dataset_version.dart';

class DatasetVersionService {
  DatasetVersionService({List<DatasetVersion>? installedVersions})
    : _installedVersions = List<DatasetVersion>.from(
        installedVersions ?? const <DatasetVersion>[],
      );

  final List<DatasetVersion> _installedVersions;

  DatasetVersion installVersion(DatasetVersion version) {
    try {
      final existingIndex = _installedVersions.indexWhere(
        (item) => item.datasetId == version.datasetId,
      );
      final normalizedVersion = version.copyWith(
        installedAt: version.installedAt,
        source: version.source.trim().isEmpty ? 'local' : version.source,
      );

      if (existingIndex >= 0) {
        _installedVersions[existingIndex] = normalizedVersion;
      } else {
        _installedVersions.add(normalizedVersion);
      }
      return normalizedVersion;
    } catch (_) {
      return version;
    }
  }

  DatasetVersion rollbackVersion({
    required String datasetId,
    required DatasetVersion fallbackVersion,
  }) {
    try {
      final existingIndex = _installedVersions.indexWhere(
        (item) => item.datasetId == datasetId,
      );
      if (existingIndex >= 0) {
        _installedVersions[existingIndex] = fallbackVersion;
      } else {
        _installedVersions.add(fallbackVersion);
      }
      return fallbackVersion;
    } catch (_) {
      return fallbackVersion;
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

  DatasetVersion? latestVersion([String? datasetId]) {
    try {
      final candidates = datasetId == null || datasetId.trim().isEmpty
          ? List<DatasetVersion>.from(_installedVersions)
          : _installedVersions
                .where((version) => version.datasetId == datasetId)
                .toList(growable: false);

      if (candidates.isEmpty) {
        return null;
      }

      candidates.sort(
        (left, right) => compareVersions(right.version, left.version),
      );
      return candidates.first;
    } catch (_) {
      return null;
    }
  }

  bool validateCompatibility({
    required DatasetRelease release,
    required String appVersion,
    String? state,
  }) {
    try {
      final versionCompatible =
          compareVersions(appVersion, release.minimumAppVersion) >= 0;
      if (!versionCompatible) {
        return false;
      }

      final requestedState = state?.trim().toLowerCase();
      if (requestedState == null || requestedState.isEmpty) {
        return true;
      }

      return release.supportedStates
          .map((item) => item.trim().toLowerCase())
          .contains(requestedState);
    } catch (_) {
      return false;
    }
  }

  List<DatasetVersion> installedVersions() {
    return List<DatasetVersion>.unmodifiable(_installedVersions);
  }

  List<int> _parseVersion(String version) {
    return version
        .split('.')
        .map((part) => int.tryParse(part.trim()) ?? 0)
        .toList(growable: false);
  }
}
