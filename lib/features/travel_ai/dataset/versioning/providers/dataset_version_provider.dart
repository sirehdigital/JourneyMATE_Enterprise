import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/dataset_version_engine.dart';
import '../services/dataset_version_service.dart';

final Provider<DatasetVersionService> datasetVersionProvider =
    Provider<DatasetVersionService>((ref) {
      return DatasetVersionService();
    });

final Provider<DatasetVersionEngine> datasetVersionEngineProvider =
    Provider<DatasetVersionEngine>((ref) {
      final service = ref.watch(datasetVersionProvider);
      return DatasetVersionEngine(service: service);
    });
