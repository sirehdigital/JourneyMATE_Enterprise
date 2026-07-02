import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/malaysia_repository.dart';
import '../services/dataset_loader_service.dart';
import '../services/dataset_validation_service.dart';

final Provider<DatasetValidationService> datasetValidationProvider =
    Provider<DatasetValidationService>((ref) {
      return const DatasetValidationService();
    });

final Provider<DatasetLoaderService> datasetLoaderProvider =
    Provider<DatasetLoaderService>((ref) {
      return DatasetLoaderService(
        validationService: ref.watch(datasetValidationProvider),
      );
    });

final Provider<MalaysiaRepository> malaysiaRepositoryProvider =
    Provider<MalaysiaRepository>((ref) {
      return MalaysiaRepository(loader: ref.watch(datasetLoaderProvider));
    });
