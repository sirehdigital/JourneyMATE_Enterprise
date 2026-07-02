import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dataset_provider.dart';
import '../engine/dataset_synchronizer_engine.dart';
import '../services/dataset_synchronizer_service.dart';

final Provider<DatasetSynchronizerService> datasetSynchronizerProvider =
    Provider<DatasetSynchronizerService>((ref) {
      return DatasetSynchronizerService(
        loader: ref.watch(datasetLoaderProvider),
        validationService: ref.watch(datasetValidationProvider),
      );
    });

final Provider<DatasetSynchronizerEngine> datasetSynchronizerEngineProvider =
    Provider<DatasetSynchronizerEngine>((ref) {
      final service = ref.watch(datasetSynchronizerProvider);
      return DatasetSynchronizerEngine(service: service);
    });
