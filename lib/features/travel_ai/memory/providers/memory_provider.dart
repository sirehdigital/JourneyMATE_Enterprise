import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/memory_engine.dart';
import '../services/memory_service.dart';

final Provider<MemoryService> memoryServiceProvider = Provider<MemoryService>(
  (_) => MemoryService(),
);

final Provider<MemoryEngine> memoryEngineProvider = Provider<MemoryEngine>(
  (ref) => MemoryEngine(service: ref.watch(memoryServiceProvider)),
);
