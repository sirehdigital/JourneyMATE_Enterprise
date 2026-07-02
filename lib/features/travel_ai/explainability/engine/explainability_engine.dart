import '../models/explanation_item.dart';
import '../models/explanation_summary.dart';
import '../services/explainability_service.dart';

class ExplainabilityEngine {
  ExplainabilityEngine({ExplainabilityService? service})
      : _service = service ?? const ExplainabilityService();

  final ExplainabilityService _service;

  ExplanationSummary explainRecommendation({
    required String title,
    required String target,
    required double score,
    required String category,
  }) {
    final items = _service.buildReasoningItems(
      target: target,
      score: score,
      category: category,
    );
    return _service.explain(title, items);
  }

  ExplanationSummary explainPlan({
    required String title,
    required List<ExplanationItem> items,
  }) {
    return _service.explain(title, items);
  }
}
