import '../models/explanation_item.dart';
import '../models/explanation_report.dart';
import '../models/explanation_score.dart';

class ExplanationService {
  const ExplanationService();

  ExplanationReport buildRecommendationExplanation({
    required String title,
    required String destination,
    required double score,
  }) {
    final items = <ExplanationItem>[
      ExplanationItem(
        id: 'rec-1',
        title: 'Recommendation basis',
        description:
            'The recommendation is based on locally available knowledge and scoring logic.',
        category: 'recommendation',
        confidence: score.clamp(0.0, 1.0),
        evidence: <String>[
          'Destination: $destination',
          'Recommendation score: ${score.toStringAsFixed(2)}',
        ],
      ),
    ];

    return _buildReport(title, items, score);
  }

  ExplanationReport buildTravelPlanExplanation({
    required String title,
    required String destination,
    required double score,
  }) {
    final items = <ExplanationItem>[
      ExplanationItem(
        id: 'plan-1',
        title: 'Plan structure',
        description:
            'The plan uses structured local itinerary logic and budget allocation.',
        category: 'planner',
        confidence: score.clamp(0.0, 1.0),
        evidence: <String>[
          'Destination: $destination',
          'Planner score: ${score.toStringAsFixed(2)}',
        ],
      ),
    ];

    return _buildReport(title, items, score);
  }

  ExplanationReport buildDestinationExplanation({
    required String title,
    required String destination,
    required double score,
  }) {
    final items = <ExplanationItem>[
      ExplanationItem(
        id: 'dest-1',
        title: 'Destination reasoning',
        description:
            'The destination explanation is derived from local knowledge nodes and scoring.',
        category: 'destination',
        confidence: score.clamp(0.0, 1.0),
        evidence: <String>[
          'Destination: $destination',
          'Destination score: ${score.toStringAsFixed(2)}',
        ],
      ),
    ];

    return _buildReport(title, items, score);
  }

  ExplanationScore calculateConfidence({
    required double recommendationConfidence,
    required double knowledgeConfidence,
    required double personalizationConfidence,
    required double plannerConfidence,
  }) {
    final overall =
        (recommendationConfidence +
            knowledgeConfidence +
            personalizationConfidence +
            plannerConfidence) /
        4;
    return ExplanationScore(
      recommendationConfidence: recommendationConfidence.clamp(0.0, 1.0),
      knowledgeConfidence: knowledgeConfidence.clamp(0.0, 1.0),
      personalizationConfidence: personalizationConfidence.clamp(0.0, 1.0),
      plannerConfidence: plannerConfidence.clamp(0.0, 1.0),
      overallConfidence: overall.clamp(0.0, 1.0),
    );
  }

  List<String> summarizeReasons(List<ExplanationItem> items) {
    if (items.isEmpty) {
      return const <String>[];
    }

    return items.map((item) => item.title).toList(growable: false);
  }

  ExplanationReport _buildReport(
    String title,
    List<ExplanationItem> items,
    double score,
  ) {
    final confidence = calculateConfidence(
      recommendationConfidence: score,
      knowledgeConfidence: score,
      personalizationConfidence: score,
      plannerConfidence: score,
    );

    return ExplanationReport(
      title: title,
      summary: 'Generated local explanation for $title.',
      score: confidence,
      items: items,
      generatedAt: DateTime.now(),
      metadata: <String, dynamic>{'source': 'local-explanation-engine'},
    );
  }
}
