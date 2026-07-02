import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/knowledge_engine.dart';
import '../services/graph_query_service.dart';
import '../entities/knowledge_graph.dart';
import 'knowledge_controller.dart';
import 'knowledge_state.dart';

final Provider<KnowledgeGraph> knowledgeGraphProvider =
    Provider<KnowledgeGraph>((_) => KnowledgeGraph());

final Provider<GraphQueryService> knowledgeQueryServiceProvider =
    Provider<GraphQueryService>(
      (ref) => GraphQueryService(ref.watch(knowledgeGraphProvider)),
    );

final Provider<KnowledgeEngine> knowledgeEngineProvider =
    Provider<KnowledgeEngine>(
      (ref) => KnowledgeEngine(
        queryService: ref.watch(knowledgeQueryServiceProvider),
      ),
    );

final StateNotifierProvider<KnowledgeController, KnowledgeState>
knowledgeControllerProvider =
    StateNotifierProvider<KnowledgeController, KnowledgeState>(
      (ref) => KnowledgeController(ref.watch(knowledgeEngineProvider)),
    );

final Provider<KnowledgeState> knowledgeStateProvider =
    Provider<KnowledgeState>((ref) => ref.watch(knowledgeControllerProvider));
