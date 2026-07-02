import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../knowledge/engine/knowledge_engine.dart';
import '../../knowledge/providers/knowledge_provider.dart';
import '../engine/destination_engine.dart';

final Provider<DestinationEngine> destinationEngineProvider =
    Provider<DestinationEngine>(
      (ref) => DestinationEngine(
        knowledgeEngine: ref.watch(knowledgeEngineProvider),
      ),
    );
