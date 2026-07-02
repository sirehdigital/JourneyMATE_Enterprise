import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/knowledge_engine.dart';
import '../entities/knowledge_node.dart';
import 'knowledge_state.dart';

class KnowledgeController extends StateNotifier<KnowledgeState> {
  KnowledgeController(this._engine) : super(const KnowledgeState());

  final KnowledgeEngine _engine;

  Future<void> loadGraph() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      state = state.copyWith(graphLoaded: true, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load graph',
      );
    }
  }

  Future<void> clearGraph() async {
    try {
      state = const KnowledgeState();
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to clear graph');
    }
  }

  List<KnowledgeNode> searchDestination(String keyword) {
    try {
      if (keyword.trim().isEmpty) {
        state = state.copyWith(searchQuery: '', errorMessage: null);
        return const <KnowledgeNode>[];
      }

      state = state.copyWith(searchQuery: keyword.trim(), errorMessage: null);
      return _engine.searchDestination(keyword.trim());
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to search destination');
      return const <KnowledgeNode>[];
    }
  }

  List<KnowledgeNode> searchByType(String type) {
    try {
      if (type.trim().isEmpty) {
        return const <KnowledgeNode>[];
      }

      return _engine.searchByType(type.trim());
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to search by type');
      return const <KnowledgeNode>[];
    }
  }

  KnowledgeNode? getNode(String id) {
    try {
      if (id.trim().isEmpty) {
        return null;
      }

      final node = _engine.searchDestination(id.trim());
      return node.isEmpty ? null : node.first;
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to fetch node');
      return null;
    }
  }

  List<KnowledgeNode> getNeighbors(String id) {
    try {
      if (id.trim().isEmpty) {
        return const <KnowledgeNode>[];
      }

      return _engine.nearbyNodes(id.trim());
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to fetch neighbors');
      return const <KnowledgeNode>[];
    }
  }

  void clearSelection() {
    try {
      state = state.copyWith(selectedNodeId: null, errorMessage: null);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to clear selection');
    }
  }
}
