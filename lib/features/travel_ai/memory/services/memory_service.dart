import '../models/memory_item.dart';
import '../models/memory_profile.dart';
import '../models/memory_snapshot.dart';

class MemoryService {
  MemoryService({String userId = 'default-user'}) : _userId = userId;

  final String _userId;
  final List<MemoryItem> _memories = <MemoryItem>[];

  void remember(MemoryItem item) {
    try {
      final existingIndex = _memories.indexWhere(
        (memory) => memory.id == item.id,
      );
      if (existingIndex >= 0) {
        _memories[existingIndex] = item.copyWith(updatedAt: DateTime.now());
      } else {
        _memories.add(
          item.copyWith(createdAt: DateTime.now(), updatedAt: DateTime.now()),
        );
      }
    } catch (_) {
      // Fail closed and keep the in-memory state safe.
    }
  }

  bool forget(String id) {
    if (id.trim().isEmpty) {
      return false;
    }

    try {
      final initialLength = _memories.length;
      _memories.removeWhere((memory) => memory.id == id);
      return _memories.length < initialLength;
    } catch (_) {
      return false;
    }
  }

  void clear() {
    try {
      _memories.clear();
    } catch (_) {
      // Ignore cleanup failures.
    }
  }

  List<MemoryItem> search(String keyword) {
    if (keyword.trim().isEmpty) {
      return const <MemoryItem>[];
    }

    try {
      final normalized = keyword.trim().toLowerCase();
      return _memories
          .where((memory) {
            final haystack =
                '${memory.title} ${memory.value} ${memory.category}'
                    .toLowerCase();
            return haystack.contains(normalized);
          })
          .toList(growable: false);
    } catch (_) {
      return const <MemoryItem>[];
    }
  }

  List<MemoryItem> recent() {
    try {
      final sorted = List<MemoryItem>.from(_memories);
      sorted.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
      return sorted.take(5).toList(growable: false);
    } catch (_) {
      return const <MemoryItem>[];
    }
  }

  MemorySnapshot summarize() {
    try {
      final snapshot = MemorySnapshot(
        timestamp: DateTime.now(),
        summary: '${_memories.length} memory items tracked.',
        totalMemories: _memories.length,
        profileVersion: _memories.isEmpty ? 0 : 1,
        metadata: <String, dynamic>{'userId': _userId},
      );
      return snapshot;
    } catch (_) {
      return MemorySnapshot(
        timestamp: DateTime.now(),
        summary: 'Memory unavailable',
        totalMemories: 0,
        profileVersion: 0,
      );
    }
  }

  MemoryProfile buildProfile() {
    try {
      return MemoryProfile(
        userId: _userId,
        memories: List<MemoryItem>.from(_memories, growable: false),
        lastUpdated: DateTime.now(),
        metadata: <String, dynamic>{'source': 'local-memory-engine'},
      );
    } catch (_) {
      return MemoryProfile(
        userId: _userId,
        memories: const <MemoryItem>[],
        lastUpdated: DateTime.now(),
        metadata: <String, dynamic>{'source': 'local-memory-engine'},
      );
    }
  }
}
