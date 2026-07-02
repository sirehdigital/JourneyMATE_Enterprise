import '../models/memory_item.dart';
import '../models/memory_profile.dart';
import '../models/memory_snapshot.dart';
import '../services/memory_service.dart';

class MemoryEngine {
  MemoryEngine({MemoryService? service})
    : _service = service ?? MemoryService();

  final MemoryService _service;

  void rememberPreference({
    required String id,
    required String title,
    required String value,
    double confidence = 0.8,
  }) {
    try {
      _service.remember(
        MemoryItem(
          id: id,
          category: 'preference',
          title: title,
          value: value,
          confidence: confidence,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      // Intentionally ignore failures to keep API safe.
    }
  }

  void rememberTrip({
    required String id,
    required String title,
    required String value,
    double confidence = 0.8,
  }) {
    try {
      _service.remember(
        MemoryItem(
          id: id,
          category: 'trip',
          title: title,
          value: value,
          confidence: confidence,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      // Intentionally ignore failures to keep API safe.
    }
  }

  void rememberRecommendation({
    required String id,
    required String title,
    required String value,
    double confidence = 0.8,
  }) {
    try {
      _service.remember(
        MemoryItem(
          id: id,
          category: 'recommendation',
          title: title,
          value: value,
          confidence: confidence,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      // Intentionally ignore failures to keep API safe.
    }
  }

  void rememberConversation({
    required String id,
    required String title,
    required String value,
    double confidence = 0.8,
  }) {
    try {
      _service.remember(
        MemoryItem(
          id: id,
          category: 'conversation',
          title: title,
          value: value,
          confidence: confidence,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      // Intentionally ignore failures to keep API safe.
    }
  }

  MemoryProfile getProfile() {
    try {
      return _service.buildProfile();
    } catch (_) {
      return MemoryProfile(
        userId: 'default-user',
        memories: const <MemoryItem>[],
        lastUpdated: DateTime.now(),
        metadata: const <String, dynamic>{},
      );
    }
  }

  List<MemoryItem> getRecentMemory() {
    try {
      return _service.recent();
    } catch (_) {
      return const <MemoryItem>[];
    }
  }

  List<MemoryItem> searchMemory(String keyword) {
    try {
      return _service.search(keyword);
    } catch (_) {
      return const <MemoryItem>[];
    }
  }

  void clearMemory() {
    try {
      _service.clear();
    } catch (_) {
      // Intentionally ignore failures to keep API safe.
    }
  }
}
