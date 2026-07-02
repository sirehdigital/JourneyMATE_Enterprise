import '../models/explanation_item.dart';
import '../models/explanation_report.dart';
import '../services/explanation_service.dart';

class ExplanationEngine {
  ExplanationEngine({ExplanationService? service})
    : _service = service ?? const ExplanationService();

  final ExplanationService _service;

  ExplanationReport explainRecommendation({
    required String title,
    required String destination,
    required double score,
  }) {
    return _service.buildRecommendationExplanation(
      title: title,
      destination: destination,
      score: score,
    );
  }

  ExplanationReport explainTravelPlan({
    required String title,
    required String destination,
    required double score,
  }) {
    return _service.buildTravelPlanExplanation(
      title: title,
      destination: destination,
      score: score,
    );
  }

  ExplanationReport explainDestination({
    required String title,
    required String destination,
    required double score,
  }) {
    return _service.buildDestinationExplanation(
      title: title,
      destination: destination,
      score: score,
    );
  }

  ExplanationReport explainRanking({
    required String title,
    required String destination,
    required double score,
  }) {
    return _service.buildRecommendationExplanation(
      title: title,
      destination: destination,
      score: score,
    );
  }

  ExplanationReport generateReport({
    required String title,
    required List<ExplanationItem> items,
    required double score,
  }) {
    final report = _service.buildRecommendationExplanation(
      title: title,
      destination: title,
      score: score,
    );
    return report.copyWith(items: items);
  }
}
